//
//  RTChecksUpViewController.h
//  Health
//
//  Created by GeoBeans on 14-7-12.
//  Copyright (c) 2014年 RADI Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTCheckUp.h"
#import "RTTimeLineCell.h"
#import "RTCheckUpRecord.h"
#import "MJRefresh.h"
#import "UIPopoverListView.h"

@interface RTChecksUpViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,addCheckUpRecord,UIPopoverListViewDataSource, UIPopoverListViewDelegate>{
    RTCheckUp *addCheckUp;
    NSMutableArray *checkUpRecordsArray;
    RTCheckUpRecord *checkUpRecord;
    int refreshTimes;
    BOOL footer;

    NSString *currentMemberObjectId;
    NSMutableArray *familyMemberID;
    NSMutableArray *familyMemberInfo;
    BOOL familyMemberAdded;
    UIActivityIndicatorView *act;
}
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
