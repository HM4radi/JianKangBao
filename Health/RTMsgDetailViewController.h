//
//  RTMsgDetailViewController.h
//  Health
//
//  Created by GeoBeans on 14-5-29.
//  Copyright (c) 2014年 RADI Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTMsgDetailTableViewCell.h"
#import "MJRefresh.h"
#import <AVOSCloud/AVOSCloud.h>
#import "RTUserInfo.h"
#import "RTMsgShowViewController.h"

@protocol setTitle <NSObject>
@required
- (void)setMessageTitle:(NSString*)title;
@end

@interface RTMsgDetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray *msgArray;
    RTUserInfo *userInfo;
    int cellNum;
    int skipTimes;
    RTMsgShowViewController *showTextVC;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property(nonatomic,weak) id<setTitle> setTitleDelegate;
@end
