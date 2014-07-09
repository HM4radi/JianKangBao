//
//  RTMsgDetailViewController.m
//  Health
//
//  Created by GeoBeans on 14-5-29.
//  Copyright (c) 2014年 RADI Team. All rights reserved.
//

#import "RTMsgDetailViewController.h"



@interface RTMsgDetailViewController ()

@end

@implementation RTMsgDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillLayoutSubviews{
    [self.navBar setFrame:CGRectMake(0, 0, 320, 64)];
    [self.tableView setFrame:CGRectMake(0, 64, 320, 464)];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"频道"
                                                                    style:UIBarButtonItemStylePlain target:self action:@selector(touchSelect)];
    leftButton.tintColor=[UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = leftButton;

}

- (void)touchSelect{
    [[self navigationController] popViewControllerAnimated:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    cellNum=0;
    [self.tableView setDelegate:self];
	[self.tableView setDataSource:self];
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    self.tableView.separatorColor=[UIColor colorWithRed:130.0/255.0 green:190.0/255.0 blue:20.0/255.0 alpha:1.0];
   
    userInfo=[RTUserInfo shareInstance];
    msgArray=[[NSMutableArray alloc]init];
    
    if (!showTextVC) {
        showTextVC=[[RTMsgShowViewController alloc]init];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [self.setTitleDelegate setMessageTitle:@"健康资讯"];
}

-(void)viewDidAppear:(BOOL)animated{
    skipTimes=0;
    [self headerRereshing];
}

//*********************tableView********************//

- (void)headerRereshing{
    
    AVQuery *query = [AVQuery queryWithClassName:@"JKChannelNew"];
    query.limit=6;
    [query whereKey:@"channelName" containedIn:userInfo.userChannelNews];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [msgArray removeAllObjects];
            for (AVObject* news in objects ) {
                NSString *newsTitle=[news objectForKey:@"newsTitle"];
                NSString *newsSubTitle=[news objectForKey:@"newsSubTitle"];
                NSString *objectId=[news objectForKey:@"objectId"];
                AVFile *imageFile=[news objectForKey:@"newsPicture"];
                
                UIImage *newsPicture=[UIImage imageWithData:[imageFile getData]];
                NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:newsTitle, @"newsTitle",newsSubTitle, @"newsSubTitle",newsPicture, @"newsPicture", objectId,@"objectId",nil];
                [msgArray addObject:dic];
            }
            cellNum=[msgArray count];
            [self.tableView reloadData];
            [self.tableView headerEndRefreshing];
            if (skipTimes==0) {
                skipTimes++;
            }
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"信息加载失败" message:@"网络有点不给力哦，请稍后再试~" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    }];
}

- (void)footerRereshing{

    AVQuery *query = [AVQuery queryWithClassName:@"JKChannelNew"];
    query.limit=6;
    query.skip=6*skipTimes;
    [query whereKey:@"channelName" containedIn:userInfo.userChannelNews];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (AVObject* news in objects ) {
                NSString *newsTitle=[news objectForKey:@"newsTitle"];
                NSString *newsSubTitle=[news objectForKey:@"newsSubTitle"];
                NSString *objectId=[news objectForKey:@"objectId"];
                AVFile *imageFile=[news objectForKey:@"newsPicture"];
                UIImage *newsPicture=[UIImage imageWithData:[imageFile getData]];
                NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:newsTitle, @"newsTitle",newsSubTitle, @"newsSubTitle",newsPicture, @"newsPicture", objectId,@"objectId",nil];
                [msgArray addObject:dic];
            }
            cellNum=[msgArray count];
            [self.tableView reloadData];
            [self.tableView footerEndRefreshing];
            skipTimes++;
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"信息加载失败" message:@"网络有点不给力哦，请稍后再试~" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    }];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static BOOL nibsRegistered = NO;
    
    static NSString *Cellidentifier=@"cell2";
    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:@"RTMsgDetailTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:Cellidentifier];
        nibsRegistered = YES;
    }
    
    RTMsgDetailTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:Cellidentifier forIndexPath:indexPath];
	NSUInteger row=[indexPath row];
    
    NSDictionary *dic=[msgArray objectAtIndex:row];
    UIImage *icon = [dic objectForKey:@"newsPicture"];
    CGSize itemSize = CGSizeMake(64, 64);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO ,0.0);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [icon drawInRect:imageRect];
    
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    cell.titleLabel.text=[dic objectForKey:@"newsTitle"];
    cell.contentLabel.text=[dic objectForKey:@"newsSubTitle"];
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
    return 77;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row=[indexPath row];
    [self loadDetailView:row];
    [[tableView cellForRowAtIndexPath:indexPath] setSelectionStyle:UITableViewCellSelectionStyleNone];
}

- (void)loadDetailView:(NSInteger)row{
    NSDictionary *dic=[msgArray objectAtIndex:row];
    showTextVC.objectId=[dic objectForKey:@"objectId"];
    [self.setTitleDelegate setMessageTitle:[dic objectForKey:@"newsTitle"]];
    [self.navigationController pushViewController:showTextVC animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
