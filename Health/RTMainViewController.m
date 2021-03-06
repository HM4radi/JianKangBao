//
//  RTMainViewController.m
//  Health
//
//  Created by GeoBeans on 14-5-14.
//  Copyright (c) 2014年 RADI Team. All rights reserved.
//

#import "RTMainViewController.h"
#import "tabbarView.h"
#import <AVOSCloud/AVOSCloud.h>
#import "RTLoginViewController.h"
#import "RTAppDelegate.h"
#import "RTUserProfileViewController.h"



#define SELECTED_VIEW_CONTROLLER_TAG 98456345

@interface RTMainViewController ()

@end

@implementation RTMainViewController

static RTMainViewController* singleInstanceOfRTMainViewController=nil;

+(id)shareMainViewControllor
{
    @synchronized(self){
    if (singleInstanceOfRTMainViewController==nil) {
        singleInstanceOfRTMainViewController=[RTMainViewController alloc];
    }
    }
    return singleInstanceOfRTMainViewController;
    
}

+(id)alloc
{
    @synchronized(self)
    {
        if (singleInstanceOfRTMainViewController == nil)
        {
            singleInstanceOfRTMainViewController = [[super alloc]init];
            return singleInstanceOfRTMainViewController;
        }
    }
    return nil;
}

+(id) allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if (singleInstanceOfRTMainViewController == nil)
        {
            singleInstanceOfRTMainViewController = [[super allocWithZone:zone]init];
            return singleInstanceOfRTMainViewController;
        }
    }
    return nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    @synchronized(self)
    {
        if (singleInstanceOfRTMainViewController != nil)
        {
            
            return singleInstanceOfRTMainViewController;
        }
        else if(singleInstanceOfRTMainViewController==nil){
            singleInstanceOfRTMainViewController = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
            return singleInstanceOfRTMainViewController;
        }
    }
    
    return nil;
}


-(void)viewWillAppear:(BOOL)animated
{
//    [self CheckCurrentUserAndLoadViewControllor];
 

}
- (void)viewDidLoad
{
    [super viewDidLoad];
   
    
    
    CGFloat orginHeight = self.view.frame.size.height- 60;
    if (!iPhone5) {
        orginHeight = self.view.frame.size.height- 60 - addHeight;
    }
    //add tabbar to mainview
    _tabbar = [[tabbarView alloc]initWithFrame:CGRectMake(0,orginHeight, 320, 60)];
    _tabbar.delegate = self;
    [self.view addSubview:_tabbar];
    
    _arrayViewcontrollers = [self getViewcontrollers];
    [self touchCenterBtn];
    
    //for center button
//    RNLongPressGestureRecognizer *longPress = [[RNLongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
//    [self.view addGestureRecognizer:longPress];
    
    [self CheckUserProfileIfSetted];
   
 
}

//分享至微信
- (void)shareToWechat
{
    RTShareMsg* share=[[RTShareMsg alloc]init];
    [share sendTextContent];
}

-(void)touchBtnAtIndex:(NSInteger)index
{
    UIView* currentView = [self.view viewWithTag:SELECTED_VIEW_CONTROLLER_TAG];
    [currentView removeFromSuperview];
    
    NSDictionary* data = [_arrayViewcontrollers objectAtIndex:index];
    
    UIViewController *viewController = [data objectForKey:@"viewController"];
    viewController.view.tag = SELECTED_VIEW_CONTROLLER_TAG;
    viewController.view.frame = CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height- 50);
    
   
    
    [self.view insertSubview:viewController.view belowSubview:_tabbar];
    
    
}

-(void)touchCenterBtn
{
    //[self showGrid];
    UIView* currentView = [self.view viewWithTag:SELECTED_VIEW_CONTROLLER_TAG];
    [currentView removeFromSuperview];
    
    NSDictionary* data = [_arrayViewcontrollers objectAtIndex:4];
    
    UIViewController *viewController = [data objectForKey:@"viewController"];
    viewController.view.tag = SELECTED_VIEW_CONTROLLER_TAG;
    viewController.view.frame = CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height- 50);
    
    [self.view insertSubview:viewController.view belowSubview:_tabbar];
    
}

-(NSArray *)getViewcontrollers
{
    NSArray* tabBarItems = nil;
    
    RTMsgNavViewController *msg=[[RTMsgNavViewController alloc]init];
    
    SecondViewController *second = [[SecondViewController alloc]init];
    
     RTForthNavVC *forth = [[RTForthNavVC alloc]init];

    RTGYBNaviViewController *thd=[[RTGYBNaviViewController alloc]init];
    
    RTCenterViewController *center=[[RTCenterViewController alloc]init];
    
    [self addChildViewController:center];
    [self addChildViewController:second];
    [self addChildViewController:forth];
    [self addChildViewController:thd];
    [self addChildViewController:msg];
    
    tabBarItems = [NSArray arrayWithObjects:
                   [NSDictionary dictionaryWithObjectsAndKeys:@"tabicon_home", @"image",@"tabicon_home", @"image_locked", msg, @"viewController",@"主页",@"title", nil],
                   [NSDictionary dictionaryWithObjectsAndKeys:@"tabicon_home", @"image",@"tabicon_home", @"image_locked", second, @"viewController",@"主页",@"title", nil],
                   [NSDictionary dictionaryWithObjectsAndKeys:@"tabicon_home", @"image",@"tabicon_home", @"image_locked", thd, @"viewController",@"主页",@"title", nil],
                   [NSDictionary dictionaryWithObjectsAndKeys:@"tabicon_home", @"image",@"tabicon_home", @"image_locked", forth, @"viewController",@"主页",@"title", nil],
                   [NSDictionary dictionaryWithObjectsAndKeys:@"tabicon_home", @"image",@"tabicon_home", @"image_locked", center, @"viewController",@"主页",@"title", nil],nil];
    return tabBarItems;
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)longPress {
    if (longPress.state == UIGestureRecognizerStateBegan) {
        [self showGridWithHeaderFromPoint:[longPress locationInView:self.view]];
    }
}

#pragma mark - RNGridMenuDelegate

- (void)gridMenu:(RNGridMenu *)gridMenu willDismissWithSelectedItem:(RNGridMenuItem *)item atIndex:(NSInteger)itemIndex {
    NSLog(@"Dismissed with item %ld: %@", (long)itemIndex, item.title);
    //分享至微信
    if (itemIndex==0) {
        [self shareToWechat];
    }
}

#pragma mark - Private

- (void)showImagesOnly {
    NSInteger numberOfOptions = 5;
    NSArray *images = @[
                        [UIImage imageNamed:@"arrow"],
                        [UIImage imageNamed:@"attachment"],
                        [UIImage imageNamed:@"block"],
                        [UIImage imageNamed:@"bluetooth"],
                        [UIImage imageNamed:@"cube"],
                        [UIImage imageNamed:@"download"],
                        [UIImage imageNamed:@"enter"],
                        [UIImage imageNamed:@"file"],
                        [UIImage imageNamed:@"github"]
                        ];
    RNGridMenu *av = [[RNGridMenu alloc] initWithImages:[images subarrayWithRange:NSMakeRange(0, numberOfOptions)]];
    av.delegate = self;
    [av showInViewController:self center:CGPointMake(self.view.bounds.size.width/2.f, self.view.bounds.size.height/2.f)];
}

- (void)showList {
    NSInteger numberOfOptions = 5;
    NSArray *options = @[
                         @"Next",
                         @"Attach",
                         @"Cancel",
                         @"Bluetooth",
                         @"Deliver",
                         @"Download",
                         @"Enter",
                         @"Source Code",
                         @"Github"
                         ];
    RNGridMenu *av = [[RNGridMenu alloc] initWithTitles:[options subarrayWithRange:NSMakeRange(0, numberOfOptions)]];
    av.delegate = self;
    //    av.itemTextAlignment = NSTextAlignmentLeft;
    av.itemFont = [UIFont boldSystemFontOfSize:18];
    av.itemSize = CGSizeMake(150, 55);
    [av showInViewController:self center:CGPointMake(self.view.bounds.size.width/2.f, self.view.bounds.size.height/2.f)];
}

- (void)showGrid {
    NSInteger numberOfOptions = 9;
    NSArray *items = @[
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"arrow"] title:@"分享至微信"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"attachment"] title:@"Attach"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"block"] title:@"Cancel"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"bluetooth"] title:@"Bluetooth"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"cube"] title:@"Deliver"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"download"] title:@"Download"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"enter"] title:@"Enter"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"file"] title:@"Source Code"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"github"] title:@"Github"]
                       ];
    
    RNGridMenu *av = [[RNGridMenu alloc] initWithItems:[items subarrayWithRange:NSMakeRange(0, numberOfOptions)]];
    av.delegate = self;
    //    av.bounces = NO;
    [av showInViewController:self center:CGPointMake(self.view.bounds.size.width/2.f, self.view.bounds.size.height/2.f)];
}

- (void)showGridWithHeaderFromPoint:(CGPoint)point {
    NSInteger numberOfOptions = 9;
    NSArray *items = @[
                       [RNGridMenuItem emptyItem],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"attachment"] title:@"Attach"],
                       [RNGridMenuItem emptyItem],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"bluetooth"] title:@"Bluetooth"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"cube"] title:@"Deliver"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"download"] title:@"Download"],
                       [RNGridMenuItem emptyItem],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"file"] title:@"Source Code"],
                       [RNGridMenuItem emptyItem]
                       ];
    
    RNGridMenu *av = [[RNGridMenu alloc] initWithItems:[items subarrayWithRange:NSMakeRange(0, numberOfOptions)]];
    av.delegate = self;
    av.bounces = NO;
    av.animationDuration = 0.2;
    //av.blurExclusionPath = [UIBezierPath bezierPathWithOvalInRect:self.imageView.frame];
    av.backgroundPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0.f, 0.f, av.itemSize.width*3, av.itemSize.height*3)];
    
    UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 44)];
    header.text = @"Example Header";
    header.font = [UIFont boldSystemFontOfSize:18];
    header.backgroundColor = [UIColor clearColor];
    header.textColor = [UIColor whiteColor];
    header.textAlignment = NSTextAlignmentCenter;
    // av.headerView = header;
    
    [av showInViewController:self center:point];
}

- (void)showGridWithPath {
    NSInteger numberOfOptions = 9;
    NSArray *items = @[
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"arrow"] title:@"Next"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"attachment"] title:@"Attach"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"block"] title:@"Cancel"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"bluetooth"] title:@"Bluetooth"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"cube"] title:@"Deliver"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"download"] title:@"Download"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"enter"] title:@"Enter"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"file"] title:@"Source Code"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"github"] title:@"Github"]
                       ];
    
    RNGridMenu *av = [[RNGridMenu alloc] initWithItems:[items subarrayWithRange:NSMakeRange(0, numberOfOptions)]];
    av.delegate = self;
    //    av.bounces = NO;
    [av showInViewController:self center:CGPointMake(self.view.bounds.size.width/2.f, self.view.bounds.size.height/2.f)];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


-(void)logout
{
    
    UIWindow* window=[RTAppDelegate shareWindow];
    if (window.rootViewController==[RTMainViewController shareMainViewControllor]) {
        window.rootViewController=[RTLoginViewController shareLoginControllor];
        singleInstanceOfRTMainViewController=nil;
    }
    else{
        [self dismissViewControllerAnimated:YES completion:nil];
          singleInstanceOfRTMainViewController=nil;
    }
}


-(BOOL)CheckUserProfileIfSetted
{
    
    
    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
    if ([mySettingData objectForKey:@"CurrentUserProfileIsSetted"]!=nil) {
        return YES;
    }
    else
    {
        UIAlertView *alerView=[[UIAlertView alloc]initWithTitle:@"欢迎来到健康宝!" message:@"您是第一次登录，为了更准确的提供服务，请先设置下个人基本信息！" delegate:self cancelButtonTitle:@"下次再说" otherButtonTitles:@"马上设置", nil];
        [alerView show];
       
        
        return NO;
    }
    
  
}


#pragma -mark UIAlertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        
    }
    if (buttonIndex==1) {
        [self PushModalToUserProfileViewControllor];
    }


}

-(void)PushModalToUserProfileViewControllor
{
    UIViewController *UserProfileVC=[[RTUserProfileViewController alloc]initWithNibName:@"RTUserProfileViewController" bundle:nil] ;
    [self presentViewController:UserProfileVC animated:YES completion:nil];

}

@end
