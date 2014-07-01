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
        loadDirect=NO;
        if (![self readDataFromLocal]) {
            [self readDataFromAVOS];
        }
    }
    return self;
}


- (BOOL)readDataFromLocal{
    bool success=NO;
    
    if (!channel) {
        channel=[[NSMutableArray alloc]init];
    }
    
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
        channel=[NSArray arrayWithContentsOfFile:path];
    }
    
    return success;
}

- (BOOL)readDataFromAVOS{
    bool success=NO;
    
    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
    
    AVQuery *query = [AVQuery queryWithClassName:@"_User"];
    [query whereKey:@"username" equalTo:[mySettingData objectForKey:@"CurrentUserName"]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            AVObject *user=[objects objectAtIndex:0];
            channel=[user objectForKey:@"userChannel"];
            if ([channel count]>0) {
                loadDirect=YES;
            }
        } else {
            // Log details of the failure
            
        }
    }];
    
    return success;
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
    [channel writeToFile:path atomically:YES];
}

- (void)touchOK{
    if (!detailVC) {
        detailVC=[[RTMsgDetailViewController alloc] init];
    }
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)showDetailVC{
    if (!detailVC) {
        detailVC=[[RTMsgDetailViewController alloc] init];
    }
    [self.navigationController pushViewController:detailVC animated:NO];
}

- (void)viewWillLayoutSubviews{

    self.navBar.frame=CGRectMake(0, 0, 320, 64);
    self.collectionView.frame=CGRectMake(0, 0, 320, 518);
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"确定"
                                                                    style:UIBarButtonItemStyleDone target:self action:@selector(touchOK)];
    rightButton.tintColor=[UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(95, 10, 130, 26)];
    [titleLabel setTextColor:[UIColor whiteColor]];
    titleLabel.font=[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:22.00];
    titleLabel.text=@"健康资讯";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.navigationController.navigationBar addSubview:titleLabel];
    self.navigationController.navigationItem.titleView=titleLabel;
    titleLabel=nil;
    
    if (!loadDirect) {
        [self showDetailVC];
    }
    
    [self.collectionView registerClass:[RTCollectionViewCell class] forCellWithReuseIdentifier:@"RTCollectionViewCell"];
    
    msgArray=[[NSMutableArray alloc]init];
    msgArray = [NSMutableArray arrayWithObjects:
                [NSDictionary dictionaryWithObjectsAndKeys:@"养生", @"name",@"ys.jpg", @"imagename", nil],
                [NSDictionary dictionaryWithObjectsAndKeys:@"中医", @"name",@"zy.jpg", @"imagename", nil],
                [NSDictionary dictionaryWithObjectsAndKeys:@"慢性病", @"name",@"mxb.jpg", @"imagename", nil],
                [NSDictionary dictionaryWithObjectsAndKeys:@"感冒", @"name",@"gm.jpg", @"imagename", nil],
                [NSDictionary dictionaryWithObjectsAndKeys:@"颈椎健康", @"name",@"jzjk.jpg", @"imagename", nil],
                [NSDictionary dictionaryWithObjectsAndKeys:@"两性知识", @"name",@"lxzs.jpg", @"imagename", nil],
                [NSDictionary dictionaryWithObjectsAndKeys:@"男性健康", @"name",@"nxjk.jpg", @"imagename", nil],
                [NSDictionary dictionaryWithObjectsAndKeys:@"女性健康", @"name",@"nxjk1.jpg", @"imagename", nil],
                [NSDictionary dictionaryWithObjectsAndKeys:@"心理健康", @"name",@"xljk.jpg", @"imagename", nil],
                [NSDictionary dictionaryWithObjectsAndKeys:@"运动饮食", @"name",@"ydys.jpg", @"imagename", nil],
                [NSDictionary dictionaryWithObjectsAndKeys:@"孕妇健康", @"name",@"yfjk.jpg", @"imagename", nil],
                [NSDictionary dictionaryWithObjectsAndKeys:@"医学前沿", @"name",@"yxqy.jpg", @"imagename", nil],nil];
    
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    self.collectionView.backgroundColor=[UIColor clearColor];
    self.collectionView.allowsMultipleSelection=YES;
    self.collectionView.userInteractionEnabled=YES;
}


//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 12;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RTCollectionViewCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"RTCollectionViewCell" forIndexPath:indexPath];
    
    NSUInteger row=[indexPath row];
    NSDictionary *dic=[msgArray objectAtIndex:row];
    
    if (dic) {
        //加载图片
        cell.imageView.image = [UIImage imageNamed:[dic objectForKey:@"imagename"]];
        //设置label文字
        cell.cellLabel.text = [dic objectForKey:@"name"];

    }
        cell.backgroundColor=[UIColor clearColor];
    return cell;
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

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    UIView *selectView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 117)];
    UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(35, 86, 30, 30)];
    imgView.image=[UIImage imageNamed:@"tick1.jpg"];
    [selectView addSubview:imgView];
    NSLog(@"%d",[indexPath item]);
    [[collectionView cellForItemAtIndexPath:indexPath] setSelectedBackgroundView:selectView];
    selectView=nil;
    
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
