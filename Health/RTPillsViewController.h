//
//  RTPillsViewController.h
//  Health
//
//  Created by GeoBeans on 14-5-27.
//  Copyright (c) 2014年 RADI Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTPillsTableViewCell.h"
#import "DDList.h"
#import <AVOSCloud/AVOSCloud.h>
#import "MJRefresh.h"

@interface RTPillsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,PassValueDelegate>{
    int cellNum;
    NSMutableArray *recordArray;

    NSString *currentName;
    NSString *currentNum;
    NSString *currentBeforeAfter;
    NSString *selectedTime;
    
    BOOL setAlarm;
    DDList *_ddList;
    
    NSMutableArray *pillsInDB;
    NSMutableArray *pillsSearching;
    
    NSDateFormatter *dateFormatter1;
    NSDateFormatter *dateFormatter;
    int refreshTimes;
    
    BOOL footer;
}

@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *addView;

@property (weak, nonatomic) IBOutlet UIDatePicker *timePicker;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *numField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *beforeAfter;
@property (weak, nonatomic) IBOutlet UINavigationBar *addNavBar;
@property (weak, nonatomic) IBOutlet UILabel *navLabel1;
@property (weak, nonatomic) IBOutlet UILabel *navLabel2;
@property (weak, nonatomic) IBOutlet UISwitch *alarmSwitch;
@property (weak, nonatomic) IBOutlet UIScrollView *controlScroll;

@end
