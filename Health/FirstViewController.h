//
//  FirstViewController.h
//  Health
//
//  Created by GeoBeans on 14-5-14.
//  Copyright (c) 2014年 RADI Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PICircularProgressView.h"
#import "RTTableViewCell.h"
#import "RTStepCounter.h"
#import "RTSportPlanViewController.h"
#import "RTPlanData.h"
#import <AVOSCloud/AVOSCloud.h>
#import "RTDetailViewController.h"
#import "RTDoingViewController.h"
#import "MJRefresh.h"
#import "RTSportTimingVC.h"

@interface FirstViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,refreshData>
{
    UINavigationItem *navigationItem;
    PICircularProgressView *progressView;
    
    float progressNow;
    float complete;
    int tag;
    NSMutableArray *recordArray;
    
    int cellNum;
    int totalCalories;
    
    RTStepCounter *stepCounter;
    
    RTSportPlanViewController *sportPlanVC;
    RTPlanData *planData;
    
    RTDetailViewController *detailVC;
    
    NSDateFormatter *dateFormatter1;
    NSDateFormatter *dateFormatter2;
    NSDateFormatter *dateFormatter3;
    NSDateFormatter *dateFormatter4;
    
    RTDoingViewController *doingVC;
    RTSportTimingVC *timingVC;
    
    int selectingRow;
    
    int skipTimes;
    
    BOOL firstLoad;
    UIActivityIndicatorView  *act;
    
    BOOL headerRefreshing;
    BOOL footerRefreshing;
}

- (void)refreshTableView;
- (void)refreshTableView1;

@property (retain, nonatomic) IBOutlet UINavigationBar *navigationbar;

@property (weak, nonatomic) IBOutlet UIView *progressView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property int cellNum;

@property (weak, nonatomic) IBOutlet UILabel *navLabel;


@end
