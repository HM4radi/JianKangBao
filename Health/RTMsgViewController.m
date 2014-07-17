//
//  RTMsgViewController.m
//  Health
//
//  Created by GeoBeans on 14-5-28.
//  Copyright (c) 2014年 RADI Team. All rights reserved.
//

#import "RTMsgViewController.h"

@interface RTMsgViewController ()

@end

@implementation RTMsgViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        userInfo=[RTUserInfo shareInstance];
        loadDirect=NO;
        if (![self readDataFromLocal]) {
            [self readDataFromAVOS];
        }
    }
    return self;
}

- (BOOL)readDataFromLocal{
    bool success=NO;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    [fileManager changeCurrentDirectoryPath:[documentsDirectory stringByExpandingTildeInPath]];

    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
    NSString *fileName=[NSString stringWithFormat:@"%@.chl",[mySettingData objectForKey:@"CurrentUserName"]];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    if ([fileManager fileExistsAtPath:path]) {
        success=YES;
        loadDirect=YES;
        userInfo.userChannelNews=[NSArray arrayWithContentsOfFile:path];
    }
    
    return success;
}

- (void)readDataFromAVOS{
    
    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
    
    AVQuery *query = [AVQuery queryWithClassName:@"_User"];
    [query whereKey:@"username" equalTo:[mySettingData objectForKey:@"CurrentUserName"]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            AVObject *user=[objects objectAtIndex:0];
            userInfo.userChannelNews=[user objectForKey:@"userChannelNews"];
            if ([userInfo.userChannelNews count]>0) {
                loadDirect=YES;
            }
        } else {
            // Log details of the failure
            
        }
    }];
}

-(void)writeDataToLocal{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray*  paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString* DocumentDirectory = [paths objectAtIndex:0];
    [fileManager changeCurrentDirectoryPath:[DocumentDirectory stringByExpandingTildeInPath]];
    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
    NSString *fileName=[NSString stringWithFormat:@"%@.chl",[mySettingData objectForKey:@"CurrentUserName"]];
    [fileManager removeItemAtPath:fileName error:nil];
    NSString* path = [DocumentDirectory stringByAppendingPathComponent:fileName];
    [userInfo.userChannelNews writeToFile:path atomically:YES];
    
    
    AVQuery *query = [AVQuery queryWithClassName:@"_User"];
    [query whereKey:@"username" equalTo:[mySettingData objectForKey:@"CurrentUserName"]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            AVObject *user=[objects objectAtIndex:0];
            [user setObject:userInfo.userChannelNews forKey:@"userChannelNews"];
            [user saveInBackground];
        } else {
            // Log details of the failure
            
        }
    }];
}

- (void)touchOK{
    
    [self writeDataToLocal];
    
    if (!detailVC) {
        detailVC=[[RTMsgDetailViewController alloc] init];
    }
    
    [self.navigationController pushViewController:detailVC animated:YES];
    titleLabel.text=@"健康资讯";
}

- (void)showDetailVC{
    if (!detailVC) {
        detailVC=[[RTMsgDetailViewController alloc] init];
    }
    titleLabel.text=@"健康资讯";
    [self.navigationController pushViewController:detailVC animated:NO];
}

- (void)viewWillLayoutSubviews{

    self.navBar.frame=CGRectMake(0, 0, 320, 64);
    if (DEVICE_IS_IPHONE5) {
        self.collectionView.frame=CGRectMake(0, 0, 320, 518);
    }else{
        self.collectionView.frame=CGRectMake(0, 0, 320, 430);
    }
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"确定"
                                                                    style:UIBarButtonItemStyleDone target:self action:@selector(touchOK)];
    rightButton.tintColor=[UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(95, 10, 130, 26)];
    [titleLabel setTextColor:[UIColor whiteColor]];
    titleLabel.font=[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:22.00];
    titleLabel.text=@"";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.navigationController.navigationBar addSubview:titleLabel];
    
    if (loadDirect) {
        [self showDetailVC];
    }
    
    [self.collectionView registerClass:[RTCollectionViewCell class] forCellWithReuseIdentifier:@"RTCollectionViewCell"];
    
    msgArray=[[NSMutableArray alloc]init];
    msgArray = [NSMutableArray arrayWithObjects:
                [NSDictionary dictionaryWithObjectsAndKeys:@"减肥整形", @"name",@"jfsx.jpg", @"imagename", nil],
                [NSDictionary dictionaryWithObjectsAndKeys:@"中医养生", @"name",@"zy.jpg", @"imagename", nil],
                [NSDictionary dictionaryWithObjectsAndKeys:@"关爱老人", @"name",@"mxb.jpg", @"imagename", nil],
                [NSDictionary dictionaryWithObjectsAndKeys:@"流行病", @"name",@"gm.jpg", @"imagename", nil],
                [NSDictionary dictionaryWithObjectsAndKeys:@"颈椎健康", @"name",@"jzjk.jpg", @"imagename", nil],
                [NSDictionary dictionaryWithObjectsAndKeys:@"两性知识", @"name",@"lxzs.jpg", @"imagename", nil],
                [NSDictionary dictionaryWithObjectsAndKeys:@"男性健康", @"name",@"nxjk.jpg", @"imagename", nil],
                [NSDictionary dictionaryWithObjectsAndKeys:@"女性健康", @"name",@"nxjk1.jpg", @"imagename", nil],
                [NSDictionary dictionaryWithObjectsAndKeys:@"心理健康", @"name",@"xljk.jpg", @"imagename", nil],
                [NSDictionary dictionaryWithObjectsAndKeys:@"运动饮食", @"name",@"ydys.jpg", @"imagename", nil],
                [NSDictionary dictionaryWithObjectsAndKeys:@"母婴健康", @"name",@"yfjk.jpg", @"imagename", nil],
                [NSDictionary dictionaryWithObjectsAndKeys:@"医学前沿", @"name",@"yxqy.jpg", @"imagename", nil],nil];
    
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    self.collectionView.backgroundColor=[UIColor clearColor];
    self.collectionView.allowsMultipleSelection=YES;
    self.collectionView.userInteractionEnabled=YES;
    
}


- (void)viewDidAppear:(BOOL)animated{
    
    [self programmaticallySelectItem];
}

- (void)viewWillAppear:(BOOL)animated{
    titleLabel.text=@"资讯频道";
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 12;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RTCollectionViewCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"RTCollectionViewCell" forIndexPath:indexPath];
    
    NSUInteger row=[indexPath row];
    NSDictionary *dic=[msgArray objectAtIndex:row];
    
    if (dic) {
        
        cell.imageView.image = [UIImage imageNamed:[dic objectForKey:@"imagename"]];
        
        cell.cellLabel.text = [dic objectForKey:@"name"];

    }
        cell.backgroundColor=[UIColor clearColor];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIView *selectView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 117)];
    UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(35, 86, 30, 30)];
    imgView.image=[UIImage imageNamed:@"tick1.jpg"];
    [selectView addSubview:imgView];
    [[collectionView cellForItemAtIndexPath:indexPath] setSelectedBackgroundView:selectView];
    selectView=nil;
    
    //在频道数组中加入选择的频道
    NSNumber *num=[NSNumber numberWithInteger:[indexPath row]];
    [userInfo.userChannelNews addObject:num];
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    int num =[userInfo.userChannelNews indexOfObject:[NSNumber numberWithInteger:[indexPath row]]];
    [userInfo.userChannelNews removeObjectAtIndex:num];
}

-(void)programmaticallySelectItem{
    if ([userInfo.userChannelNews count]>0) {
        
        for (NSNumber*chl in userInfo.userChannelNews) {
            UIView *selectView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 117)];
            UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(35, 86, 30, 30)];
            imgView.image=[UIImage imageNamed:@"tick1.jpg"];
            NSIndexPath *index = [NSIndexPath indexPathForRow:[chl intValue] inSection:0];
            [self.collectionView selectItemAtIndexPath:index animated:YES scrollPosition:UICollectionViewScrollPositionNone];
            [selectView addSubview:imgView];
            [[self.collectionView cellForItemAtIndexPath:index] setSelectedBackgroundView:selectView];
            selectView=nil;
        }
        
    }
    
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//定义每个UICollectionView 的大小
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return CGSizeMake(80, 120);
//}

//定义每个UICollectionView 的 margin
//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(2.5, 2.5, 2.5, 2.5);
//}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
