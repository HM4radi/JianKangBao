//
//  RTChecksUpViewController.m
//  Health
//
//  Created by GeoBeans on 14-7-12.
//  Copyright (c) 2014年 RADI Team. All rights reserved.
//

#import "RTChecksUpViewController.h"



@interface RTChecksUpViewController ()

@end

@implementation RTChecksUpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    checkUpRecordsArray=[[NSMutableArray alloc]init];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight=110;
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    refreshTimes=0;
    footer=NO;
    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
    currentMemberName=[mySettingData objectForKey:@"CurrentUserName"];

    [self readDataFromAVOS];
    checkUpRecord=[RTCheckUpRecord shareInstance];
    
    self.titleLabel.userInteractionEnabled=YES;
    UITapGestureRecognizer *Gesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showPullDown)];
    [self.titleLabel addGestureRecognizer:Gesture];
}

- (void)headerRereshing{
    refreshTimes=0;
    [self readDataFromAVOS];
}

- (void)footerRereshing{
    footer=YES;
    [self readDataFromAVOS];
}

- (void)viewWillLayoutSubviews{
    [self.navBar setFrame:CGRectMake(0, 0, 320, 64)];
    self.navBar.translucent=YES;
}

- (IBAction)touchBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)touchAdd:(id)sender {
    
    [checkUpRecord resetting];
    
    if (!addCheckUp) {
        addCheckUp=[[RTCheckUp alloc]init];
        addCheckUp.dataDelegate=self;
    }
    
    [self presentViewController:addCheckUp animated:YES completion:nil];
    
    addCheckUp=nil;
}

-(void)readDataFromAVOS{
    
    AVQuery *query=[AVQuery queryWithClassName:@"JKCheckUpRecord"];
    query.limit = 10;
    query.skip=10*refreshTimes;
    [query selectKeys:@[@"checkTime", @"checkType",@"indexArray"]];
    [query addDescendingOrder:@"checkTime"];
    [query whereKey:@"userObjectId" equalTo:currentMemberName];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            refreshTimes++;
            if (!footer) {
                [checkUpRecordsArray removeAllObjects];
            }else{
                footer=NO;
            }
            for (int i=0; i<[objects count]; i++) {
                NSDate *checkTime=[[objects objectAtIndex:i] objectForKey:@"checkTime"];
                NSString *checkType=[[objects objectAtIndex:i] objectForKey:@"checkType"];
                NSMutableArray *indexArray=[[objects objectAtIndex:i] objectForKey:@"indexArray"];
                NSString *objectId=[[objects objectAtIndex:i] objectForKey:@"objectId"];
                NSMutableDictionary *dic=[[NSMutableDictionary alloc]initWithObjectsAndKeys:checkTime,@"date",checkType,@"type",[NSString stringWithFormat:@"%d",[indexArray count]],@"indexArrayCount",objectId ,@"objectId",nil];
                [checkUpRecordsArray addObject:dic];
                indexArray=nil;
            }
            [self.tableView reloadData];
            [self.tableView headerEndRefreshing];
            [self.tableView footerEndRefreshing];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"信息加载失败" message:@"网络有点不给力哦，请稍后再试~" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    }];
    query=nil;

}

//*********************tableView********************//
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    BOOL nibsRegistered = NO;
    
    static NSString *Cellidentifier=@"RTTimeLineCell";
    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:@"RTTimeLineCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:Cellidentifier];
        nibsRegistered = YES;
    }
    
    RTTimeLineCell *cell=[tableView dequeueReusableCellWithIdentifier:Cellidentifier forIndexPath:indexPath];
    
	NSUInteger row=[indexPath row];
    cell.typeLabel.text=[[checkUpRecordsArray objectAtIndex:row] objectForKey:@"type"];
    cell.abnormalNum.text=[NSString stringWithFormat:@"%@项",[[checkUpRecordsArray objectAtIndex:row] objectForKey:@"indexArrayCount"]];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"M月"];
    NSDateFormatter *dateFormatter1=[[NSDateFormatter alloc]init];
    [dateFormatter1 setDateFormat:@"d"];
    cell.monthLabel.text=[dateFormatter stringFromDate:[[checkUpRecordsArray objectAtIndex:row] objectForKey:@"date"]];
    cell.dayLabel.text=[dateFormatter1 stringFromDate:[[checkUpRecordsArray objectAtIndex:row] objectForKey:@"date"]];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [checkUpRecordsArray count];
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
    return 110;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[tableView cellForRowAtIndexPath:indexPath] setSelectionStyle:UITableViewCellSelectionStyleGray];
    NSUInteger row = [indexPath row];
    [self loadDetailView:row];
    
    [self performSelector:@selector(deselect) withObject:nil afterDelay:0.5f];
}

- (void)addRecord:(NSDictionary *)dic{
    [checkUpRecordsArray addObject:dic];
    [self.tableView reloadData];
}

-(void)loadDetailView:(NSInteger)row{
    
    [checkUpRecord resetting];
    checkUpRecord.checkUpStyle=[[checkUpRecordsArray objectAtIndex:row] objectForKey:@"type"];
    checkUpRecord.checkUpTime=[[checkUpRecordsArray objectAtIndex:row] objectForKey:@"date"];
    checkUpRecord.objectId=[[checkUpRecordsArray objectAtIndex:row] objectForKey:@"objectId"];
    checkUpRecord.exist=YES;
    if (!addCheckUp) {
        addCheckUp=[[RTCheckUp alloc]init];
        addCheckUp.dataDelegate=self;
    }
    
    [self presentViewController:addCheckUp animated:YES completion:nil];
    
    addCheckUp=nil;
}

- (void)deselect
{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}


#pragma mark - UIPopoverListViewDataSource

- (UITableViewCell *)popoverListView:(UIPopoverListView *)popoverListView
                    cellForIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                    reuseIdentifier:identifier];
    
    int row = indexPath.row;
    
    if(row == 0){
        cell.textLabel.text = @"AngelaBaby";
        cell.imageView.image = [UIImage imageNamed:@"1.jpg"];
    }else if (row == 1){
        cell.textLabel.text = @"Lucas";
        cell.imageView.image = [UIImage imageNamed:@"2.jpg"];
    }else if (row == 2){
        cell.textLabel.text = @"Ray";
        cell.imageView.image = [UIImage imageNamed:@"3.jpg"];
    }
    return cell;
}

- (NSInteger)popoverListView:(UIPopoverListView *)popoverListView
       numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

#pragma mark - UIPopoverListViewDelegate
- (void)popoverListView:(UIPopoverListView *)popoverListView
     didSelectIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s : %d", __func__, indexPath.row);
    // your code here
}

- (CGFloat)popoverListView:(UIPopoverListView *)popoverListView
   heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

-(void)showPullDown{
    CGFloat xWidth = self.view.bounds.size.width - 20.0f;
    CGFloat yHeight = 272.0f;
    CGFloat yOffset = (self.view.bounds.size.height - yHeight)/2.0f;
    UIPopoverListView *poplistview = [[UIPopoverListView alloc] initWithFrame:CGRectMake(10, yOffset, xWidth, yHeight)];
    poplistview.delegate = self;
    poplistview.datasource = self;
    poplistview.listView.scrollEnabled = FALSE;
    [poplistview setTitle:@"切换家庭成员"];
    [poplistview show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
