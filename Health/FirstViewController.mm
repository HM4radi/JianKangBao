//
//  FirstViewController.m
//  Health
//
//  Created by GeoBeans on 14-5-14.
//  Copyright (c) 2014年 RADI Team. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController
@synthesize cellNum;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        //载入运动次数
        cellNum=0;
    }
    return self;
}

- (void)viewWillLayoutSubviews{
    
    [self.navigationbar setFrame:CGRectMake(0, 0, 320, 64)];
    self.navigationbar.translucent=YES;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    progressView=[[PICircularProgressView alloc]initWithFrame:CGRectMake(80, 70, 160, 160)];
    progressView.thicknessRatio=0.08;
    progressView.roundedHead=false;
    progressView.showShadow=false;
    
    //为progressView 添加点击事件
    progressView.userInteractionEnabled=YES;
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewClick:)];
    [progressView addGestureRecognizer:tapGesture];
    tag=0;
    
    //stepCounter
    stepCounter=[RTStepCounter sharedRTSterCounter];
    [stepCounter addObserver:self forKeyPath:@"step" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    
    //plandata
    planData=[RTPlanData shareInstance];
    
    dateFormatter1=[[NSDateFormatter alloc]init];
    [dateFormatter1 setDateFormat:@"HH:mm"];
    dateFormatter2=[[NSDateFormatter alloc]init];
    [dateFormatter2 setDateFormat:@"H小时m分"];
    dateFormatter3=[[NSDateFormatter alloc]init];
    [dateFormatter3 setDateFormat:@"H"];
    dateFormatter4=[[NSDateFormatter alloc]init];
    [dateFormatter4 setDateFormat:@"m"];
    
    firstLoad=YES;
    headerRefreshing=NO;
    footerRefreshing=NO;
    [self tableViewInit];
    
}


- (void)tableViewInit{
    //add tableView
    recordArray=[[NSMutableArray alloc]init];
    [self.tableView setDelegate:self];
	[self.tableView setDataSource:self];
    self.tableView.scrollEnabled=YES;
    self.tableView.separatorColor=[UIColor colorWithRed:130.0/255.0 green:190.0/255.0 blue:20.0/255.0 alpha:1.0];
    self.tableView.tableHeaderView=progressView;
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    [self.view addSubview:self.tableView];
    [self refreshData];
}

-(void)refreshData{

    if (firstLoad) {
        act=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [act setCenter:CGPointMake(160,250)];
        [self.view addSubview:act];
        [act startAnimating];
    }
    
    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
    AVQuery *query=[AVQuery queryWithClassName:@"JKHistorySportPlan"];
    query.limit = 5;
    query.skip=skipTimes*5;
    skipTimes++;
    [query addDescendingOrder:@"createdAt"];
    [query whereKey:@"userObjectId" equalTo:[mySettingData objectForKey:@"CurrentUserName"]];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (headerRefreshing) {
                [recordArray removeAllObjects];
            }
            for (int i=0; i<[objects count]; i++) {
                NSString *placeName=[[[objects objectAtIndex:i] objectForKey:@"sportGeoPointDescription"] objectAtIndex:0];
                NSString *startTime=[dateFormatter1 stringFromDate: [[objects objectAtIndex:i] objectForKey:@"startTime"]];
                NSString *endTime=[dateFormatter1 stringFromDate: [[objects objectAtIndex:i] objectForKey:@"endTime"]];
                NSString *sportType=[[objects objectAtIndex:i] objectForKey:@"sportType"];
                NSString *strength=[[objects objectAtIndex:i] objectForKey:@"strength"];
                NSNumber *calories=[[objects objectAtIndex:i] objectForKey:@"sportCaloriesPlan"];
                NSString *objectId=[[objects objectAtIndex:i] objectForKey:@"objectId"];
                NSNumber *progress=[[objects objectAtIndex:i] objectForKey:@"planCompleteProgress"];
                [recordArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:placeName, @"location",startTime, @"startTime", endTime, @"endTime",sportType,@"type",strength,@"strength",calories,@"calories",objectId,@"objectId",progress,@"progress",nil]];
            }
            cellNum=[recordArray count];
            [self.tableView reloadData];
            
            if (headerRefreshing) {
                [self.tableView headerEndRefreshing];
                headerRefreshing=NO;
            }
            if (footerRefreshing) {
                [self.tableView footerEndRefreshing];
                footerRefreshing=NO;
            }
            
            if (firstLoad) {
                [act stopAnimating];
                act=nil;
                firstLoad=NO;
            }
        } else {
            if (headerRefreshing) {
                [self.tableView headerEndRefreshing];
                headerRefreshing=NO;
            }
            if (footerRefreshing) {
                [self.tableView footerEndRefreshing];
                footerRefreshing=NO;
            }
            if (firstLoad) {
                [act stopAnimating];
                act=nil;
                firstLoad=NO;
            }
            [act stopAnimating];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"信息加载失败" message:@"网络有点不给力哦，请稍后再试~" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    }];
    query=nil;
}

- (IBAction)addPlan:(id)sender {
    if (!sportPlanVC) {
        sportPlanVC=[[RTSportPlanViewController alloc]init];
        sportPlanVC.dataDelegate=self;
    }
    
    sportPlanVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    [self presentViewController:sportPlanVC animated:YES completion:nil];
    
    sportPlanVC=nil;

}

//*******************************动态图********************************//
- (void)viewClick:(UITapGestureRecognizer *)gesture
{
    if (tag==0) {
        progressView.type=0;
        UIColor *col1=[UIColor colorWithRed:15.0/255.0 green:97.0/255.0 blue:189.0/255.0 alpha:1.0];
        UIColor *col2=[UIColor colorWithRed:114.0/255.0 green:174.0/255.0 blue:235.0/255.0 alpha:1.0];
        [self setupPregressView:@"步   数" goal:@"目标:5000" complete:[stepCounter.step floatValue] withTopColor:col1 AndBottomColor:col2];
        tag++;
    }else if (tag==1){
        progressView.type=1;
        UIColor *col2=[UIColor colorWithRed:183.0/255.0 green:242.0/255.0 blue:151.0/255.0 alpha:1.0];
        UIColor *col1=[UIColor colorWithRed:0.0/255.0 green:255.0/255.0 blue:0.0/255.0 alpha:1.0];
        [self setupPregressView:@"里   程" goal:@"目标:9.4" complete:6.2 withTopColor:col1 AndBottomColor:col2];
        tag++;
    }else if (tag==2){
        progressView.type=2;
        UIColor *col1=[UIColor colorWithRed:255.0/255.0 green:136/255.0 blue:49/255.0 alpha:1.0];
        UIColor *col2=[UIColor colorWithRed:244.0/255.0 green:237.0/255.0 blue:138.0/255.0 alpha:1.0];
        [self setupPregressView:@"卡路里" goal:@"目标:300" complete:236 withTopColor:col1 AndBottomColor:col2];
        tag=0;
    }
}

- (void)setupPregressView:(NSString *)title goal:(NSString *)goal complete:(float)_complete withTopColor:(UIColor*)color1 AndBottomColor:(UIColor*)color2
{
    progressNow=0;
    progressView.title=title;
    progressView.goal=goal;
    complete=_complete;
    progressView.progressTopGradientColor=color1;
    progressView.progressBottomGradientColor=color2;
    NSString *finishAnimat;
    finishAnimat=@"notFinished";
    
    for (int i=0; i<=100*complete/[[progressView.goal substringFromIndex:3] floatValue]; i++) {
        if (100*complete/[[progressView.goal substringFromIndex:3] floatValue]-i<1) {
            finishAnimat=@"finished";
        }
        [self performSelector:@selector(setProgress:) withObject:finishAnimat afterDelay:0.005*i];
    }
}

- (void)setProgress:(NSString *)finish{
    float goal=[[progressView.goal substringFromIndex:3] floatValue];
    progressView.progress=(progressNow++)/100;
    if ([finish isEqual:@"finished"]) {
        progressView.progress=float(complete)/goal;
    }
}

- (void)viewDidAppear:(BOOL)animated{
    UIColor *col1=[UIColor colorWithRed:255.0/255.0 green:136/255.0 blue:49/255.0 alpha:1.0];
    UIColor *col2=[UIColor colorWithRed:244.0/255.0 green:237.0/255.0 blue:138.0/255.0 alpha:1.0];
    progressView.type=2;
    [self setupPregressView:@"卡路里" goal:@"目标:300" complete:236 withTopColor:col1 AndBottomColor:col2];
    
    if (DEVICE_IS_IPHONE5) {
        [self.tableView setFrame:CGRectMake(0, 68, 320, 460)];
    }else{
        [self.tableView setFrame:CGRectMake(0, 68, 320, 372)];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{

    if ([keyPath isEqual:@"step"]) {
        if (progressView.type==0) {
            float goal=[[progressView.goal substringFromIndex:3] floatValue];
            progressView.progress=float([stepCounter.step floatValue])/goal;
        }
    }
}

//*********************tableView********************//

- (void)footerRereshing{
    footerRefreshing=YES;
    [self refreshData];
}

- (void)headerRereshing{
    headerRefreshing=YES;
    skipTimes=0;
    [self refreshData];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static BOOL nibsRegistered = NO;
    
    static NSString *Cellidentifier=@"cell1";
    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:@"RTTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:Cellidentifier];
        nibsRegistered = YES;
    }

    RTTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:Cellidentifier forIndexPath:indexPath];
    
	NSUInteger row=[indexPath row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSDictionary *dic=[recordArray objectAtIndex:row];
    cell.location.text=[dic objectForKey:@"location"];
    cell.startTime.text=[dic objectForKey:@"startTime"];
    cell.endTime.text=[dic objectForKey:@"endTime"];
    cell.type.text=[dic objectForKey:@"type"];
    cell.progressView.progress=[[dic objectForKey:@"progress"] floatValue];
    if ([[dic objectForKey:@"type"] isEqualToString:@"跑步"]||[[dic objectForKey:@"type"] isEqualToString:@"走路"]) {
        cell.title2.text=@"平均速度";
    }
    cell.strength.text=[dic objectForKey:@"strength"];
    
    NSNumberFormatter *ft=[[NSNumberFormatter alloc]init];
    cell.calories.text=[ft stringFromNumber:[dic objectForKey:@"calories"]];
    ft=nil;
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return cellNum;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//行缩进
-(NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger row = [indexPath row];
    return row;
}

//改变行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[tableView cellForRowAtIndexPath:indexPath] setSelectionStyle:UITableViewCellSelectionStyleGray];
    NSUInteger row = [indexPath row];
    [self loadDetailView:row];
    [self performSelector:@selector(deselect) withObject:nil afterDelay:0.5f];

}

- (void)deselect
{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)refreshTableView{
    [recordArray insertObject:[NSDictionary dictionaryWithObjectsAndKeys:[planData.sportGeoPointDescription objectAtIndex:0], @"location",[dateFormatter1 stringFromDate: planData.startTime ], @"startTime", [dateFormatter1 stringFromDate: planData.endTime], @"endTime",planData.sportType,@"type",planData.strength,@"strength",planData.calories,@"calories",planData.objectId,@"objectId",planData.progress,@"progress",nil] atIndex:0];
    cellNum=[recordArray count];
    [self.tableView reloadData];
}

- (void)refreshTableView1{
    cellNum=[recordArray count];
    NSMutableDictionary *dic=[recordArray objectAtIndex:selectingRow];
    [dic setObject:planData.progress forKey:@"progress"];
    [self.tableView reloadData];
}

//*********************detailsView********************//

- (void)loadDetailView:(NSInteger)row{
    
    selectingRow=row;
    NSDictionary *dic=[recordArray objectAtIndex:row];
    NSString *objectId=[dic objectForKey:@"objectId"];
    
    AVQuery *query=[AVQuery queryWithClassName:@"JKHistorySportPlan"];
    [query whereKey:@"objectId" equalTo:objectId];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            cellNum=[objects count];
            
            planData.routeCoord=[[objects objectAtIndex:0] objectForKey:@"sportGeoPoint"];
            planData.startTime=[[objects objectAtIndex:0] objectForKey:@"startTime"];
            planData.endTime=[[objects objectAtIndex:0] objectForKey:@"endTime"];
            planData.sportType=[[objects objectAtIndex:0] objectForKey:@"sportType"];
            planData.strength=[[objects objectAtIndex:0] objectForKey:@"strength"];
            planData.calories=[[objects objectAtIndex:0] objectForKey:@"sportCaloriesPlan"];
            planData.progress=[[objects objectAtIndex:0] objectForKey:@"planCompleteProgress"];
            planData.objectId=objectId;
            if (![planData.progress isEqualToNumber:[NSNumber numberWithFloat:0]]) {
                if(!detailVC){
                    detailVC=[[RTDetailViewController alloc]init];
                }
                detailVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
                [self presentViewController:detailVC animated:YES completion:nil];
                detailVC=nil;
            }
            else{
                if(!doingVC){
                    doingVC=[[RTDoingViewController alloc]init];
                    doingVC.dataDelegate=self;
                }
                doingVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
                [self presentViewController:doingVC animated:YES completion:nil];
                doingVC=nil;
            }
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"信息加载失败" message:@"网络有点不给力哦，请稍后再试~" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    }];
}


- (IBAction)touchBack:(id)sender {
    [UIView beginAnimations:@"view flip" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView transitionWithView:self.view.superview
                      duration:0.2
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{ [self.view removeFromSuperview];  }
                    completion:NULL];
    [UIView commitAnimations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
