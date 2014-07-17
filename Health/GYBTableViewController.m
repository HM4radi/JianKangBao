//
//  GYBTableViewController.m
//  TableView
//
//  Created by Mac on 5/17/14.
//  Copyright (c) 2014 Mac. All rights reserved.
//

#import "GYBTableViewController.h"
#import"GYBTableViewCell.h"
#import "DPMeterView.h"
#import "UIBezierPath+BasicShapes.h"
#import "RTUserInfo.h"
#import "RTFamilyDetailViewController.h"
#import "RTDetailViewNewViewController.h"
#import "RTAddFamilyMemberViewController.h"
#import <AVOSCloud/AVOSCloud.h>

@interface GYBTableViewController ()
@property (nonatomic,strong)NSMutableDictionary *listItem;
@property (nonatomic,strong)NSMutableDictionary *Statue;

@property (nonatomic,strong)NSArray *familyShipObjectId;
@property (nonatomic,strong)NSMutableArray *protaitImageArray;


-(void)initNameDataDiction;
//-(void)initLocationData;
-(void)initStatusData;

@end

@implementation GYBTableViewController

 static BOOL nibsRegistered = NO;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
          }
    return self;
}


-(void)checkOutDataOnAVOS
{
    //初始化数据
    [self queryFamilyShipFromAVOS];
    

}

-(void)queryFamilyShipFromAVOS
{
    AVUser *current=[AVUser currentUser];
    AVQuery *query = [AVQuery queryWithClassName:@"JKFriendShip"];
    [query whereKey:@"frienda_objectid" equalTo:current.objectId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([objects count]>0) {
            AVObject *o=[objects objectAtIndex:0];
            self.familyShipObjectId=[o objectForKey:@"friendb_objectid"];
            [self queryFamilyUser];
        }
        else
        {
        
        }
    }];
    
}


-(void)queryFamilyUser
{
     NSMutableArray *protaitImageArray=[[NSMutableArray alloc]init];
    NSMutableDictionary *listItem = [NSMutableDictionary dictionary];

    if (self.familyShipObjectId!=nil) {
    //循环查询
        for (NSString *objectId in self.familyShipObjectId)
        {
            NSLog(@"for循环次数");
            AVQuery *queryUser=[AVUser query];
            [queryUser whereKey:@"objectId" equalTo:objectId];
        
            [queryUser findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (error == nil) {
                    RTUserInfo *user=[objects objectAtIndex:0];
                    [listItem setObject:@"0" forKey:user.username];
                    AVFile *imageFile=user.userImage;
                    NSData *imageData=[imageFile getData];
                    
                    if (imageData==nil) {
                        UIImage *imgDefault=[UIImage imageNamed:@"tabbar_profile.png"];
                        [protaitImageArray addObject:imgDefault];
                    }else
                    {
                        UIImage *img=[UIImage imageWithData:imageData];;
                        [protaitImageArray addObject:img];
                    }
                    
                   
                  NSLog(@"for后protaitImageArray长达:%d", [protaitImageArray count]);
                    [self.protaitImageArray addObjectsFromArray:protaitImageArray];
                    [self.listItem addEntriesFromDictionary:listItem];
                }
                
                else {
                    
                }
            }];
           
        }
    }
  

}


- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
////    GYBDetailViewController *detailViewController=[[GYBDetailViewController alloc]init];
////    
////    [self.navigationController pushViewController:detailViewController animated:YES];
////    NSLog(@"%d",indexPath.row);
//
}


//添加点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    RTDetailViewNewViewController *detailViewController=[[RTDetailViewNewViewController alloc]initWithNibName:@"RTDetailViewNewViewController" bundle:nil];
    detailViewController.friendNameList=[self.listItem allKeys];
    detailViewController.friendImage=self.protaitImageArray;
    [detailViewController setCurrentSelectedIndex:indexPath.row];
    [self.navigationController pushViewController:detailViewController animated:YES];
    
}

#pragma mark- Star status  UI object

- (void)updateProgressWithDelta:(CGFloat)delta animated:(BOOL)animated
{
    NSArray *shapeViews = [self shapeViews];
    for (DPMeterView *shapeView in shapeViews) {
        if (delta < 0) {
            [shapeView minus:fabs(delta) animated:animated];
        } else {
            [shapeView add:fabs(delta) animated:animated];
        }
    }
    
//    self.title = [NSString stringWithFormat:@"%.2f%%",
//                  [(DPMeterView *)[shapeViews lastObject] progress]*100];
}

- (NSArray *)shapeViews
{
    NSMutableArray *shapeViews = [NSMutableArray array];
//    
//    if (self.shape4StarView && [self.shape4StarView isKindOfClass:[DPMeterView class]])
//        [shapeViews addObject:self.shape4StarView];
    
//    if (self.shape2View && [self.shape2View isKindOfClass:[DPMeterView class]])
//        [shapeViews addObject:self.shape2View];
//    
//    if (self.shape3View && [self.shape3View isKindOfClass:[DPMeterView class]])
//        [shapeViews addObject:self.shape3View];
//    
//    if (self.shape4View && [self.shape4View isKindOfClass:[DPMeterView class]])
//        [shapeViews addObject:self.shape4View];
//    
//    if (self.shape5View && [self.shape5View isKindOfClass:[DPMeterView class]])
//        [shapeViews addObject:self.shape5View];
    
    return [NSArray arrayWithArray:shapeViews];
}
//-(void)initNameDataDiction
//{
//    
//    //初始化key Array
//
//    //NSLog(@"%@",[self.key objectAtIndex:0]);
//    
//}




-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [self updateProgressWithDelta:0.6 animated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    
    if ([[self.listItem allKeys] count]==0) {
        
    }
    else{
    [self.tableView reloadData];
    }
}
- (void)viewDidLoad
{
    
    

    [super viewDidLoad];
//初始化数据本地化数组
    self.protaitImageArray=[[NSMutableArray alloc]init];
    self.listItem = [NSMutableDictionary dictionary];

    
    
    [self.navigationController.navigationBar setFrame:CGRectMake(0, 0, 320, 64)];

    self.navigationController.navigationBar.translucent=YES;
    
    // UIApperance
    [[DPMeterView appearance] setTrackTintColor:[UIColor lightGrayColor]];
    [[DPMeterView appearance] setProgressTintColor:[UIColor darkGrayColor]];
    
//    // shape 4 -- 3 Stars
//    [self.shape4StarView setMeterType:DPMeterTypeLinearHorizontal];
//    [self.shape4StarView setShape:[UIBezierPath stars:5 shapeInFrame:self.shape4StarView.frame].CGPath];
//    self.shape4StarView.progressTintColor = [UIColor colorWithRed:255/255.f green:199/255.f blue:87/255.f alpha:1.f];
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(95, 10, 130, 26)];
    [titleLabel setTextColor:[UIColor whiteColor]];
    titleLabel.font=[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:22.00];
    titleLabel.text=@"家庭圈";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView=titleLabel;
    titleLabel=nil;
    
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd   target:self action:@selector(addFamilyMemberAction:)];
    
    
    //初始化下拉刷新控件
    UIRefreshControl *rc=[[UIRefreshControl alloc]init];
    rc.attributedTitle=[[NSAttributedString alloc]initWithString:@"下拉刷新家人列表"];
    [rc addTarget:self action:@selector(refreshTableView) forControlEvents:UIControlEventValueChanged];
    self.refreshControl=rc;

}


-(void)refreshTableView
{
    
    [self.listItem removeAllObjects];
    [self.protaitImageArray removeAllObjects];
    if(self.refreshControl.refreshing)
    {
        self.refreshControl.attributedTitle=[[NSAttributedString alloc]initWithString:@"数据紧张加载中..."];
        
        //刷新数据
        [self checkOutDataOnAVOS];
        //请求完成后回调
        [self performSelector:@selector(callBackMethod:) withObject:nil afterDelay:3];
        
        
        
    
    }


}


-(void)callBackMethod:(id) obj
{
    [self.refreshControl endRefreshing];
    self.refreshControl.attributedTitle=[[NSAttributedString alloc]initWithString:@"下拉刷新家人列表刷新"];
    [self.tableView reloadData];

}


-(IBAction)addFamilyMemberAction:(id)sender
{
    RTAddFamilyMemberViewController* addFamilyShipVC=[[RTAddFamilyMemberViewController alloc]initWithNibName:nil bundle:nil];
     [self presentViewController:addFamilyShipVC animated:YES completion:nil];

}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [[self.listItem allKeys] count];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   NSMutableArray *colorArray=[[NSMutableArray alloc]init];
    static NSString *Cellidentifier=@"CustomCellRed";
    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:@"GYBTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:Cellidentifier];
        nibsRegistered = YES;
    }
     NSUInteger row=[indexPath row];
    GYBTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:Cellidentifier forIndexPath:indexPath];
    
    
   
    UIColor *darkBlue;
    UIColor *darkYellow;
    UIColor *darkGreen;
    for (int i=0; i<=[[self.listItem allKeys]count]; i++)
    {
        int a=i%3;
        switch (a) {
            case 0:
                darkBlue=[UIColor colorWithRed:54/255.f green:73/255.f blue:93/255.f alpha:1.f];
                [colorArray addObject:darkBlue];
                darkBlue=nil;
                break;
            case 1:
                darkYellow=[UIColor colorWithRed:240/255.f green:197/255.f blue:44/255.f alpha:1.f];
                
                [colorArray addObject:darkYellow];
                darkYellow=nil;
                break;
            case 2:
                darkGreen=[UIColor colorWithRed:44/255.f green:206/255.f blue:118/255.f alpha:1.f];
                [colorArray addObject:darkGreen];
                darkGreen=nil;
                break;
        }
        
        
    }
    

   
  
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    cell.backgroundColor= [UIColor colorWithRed: 1 green: 0 blue: 0 alpha: 0.235];
//    
//    cell.contentView.backgroundColor=[UIColor colorWithRed: 1 green: 0 blue: 0 alpha: 0.235];
    
    NSArray *keyArray=[self.listItem allKeys];
    
    cell.nameLabel.text=[keyArray objectAtIndex:row];
    
    UIImageView *portraitView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 20, 62, 62)];
    [portraitView.layer setCornerRadius:CGRectGetHeight(portraitView.bounds)/2];
    portraitView.layer.borderColor = [UIColor blueColor].CGColor;
//    portraitView.layer.borderWidth = 0.5;
    [portraitView.layer setMasksToBounds:YES];
    [portraitView setImage:[self.protaitImageArray objectAtIndex:indexPath.row]];
    [cell.contentView addSubview:portraitView];
    
    
    cell.contentView.backgroundColor=[colorArray objectAtIndex:indexPath.row];
    // shape 4 -- 3 Stars
    [cell.statueView setMeterType:DPMeterTypeLinearHorizontal];
    [cell.statueView setShape:[UIBezierPath stars:5 shapeInFrame:cell.statueView.frame].CGPath];
    
    cell.statueView.progressTintColor = [UIColor colorWithRed:255/255.f green:199/255.f blue:87/255.f alpha:1.f];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    
    //从字典中读取string 然后转化为CGFloat
    NSString *key=cell.nameLabel.text;
    
    NSString *Delta=[self.listItem objectForKey:key];
    float floatString = [Delta floatValue];
//    NSLog(@"%@",Delta);
    CGFloat f = (CGFloat)floatString;
    
    //set statue Value
    cell.statueValue=&(f);
    [cell updateProgressWithDelta:*(cell.statueValue) animated:YES];
    
//     cell.accessoryType=UITableViewCellAccessoryDetailDisclosureButton;
    
    return cell;
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

@end
