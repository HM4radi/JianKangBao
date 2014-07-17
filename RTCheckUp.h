//
//  RTCheckUp.h
//  Health
//
//  Created by GeoBeans on 14-7-14.
//  Copyright (c) 2014年 RADI Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACPButton.h"
#import "RTAddCheckUpVC.h"
#import "RTCheckUpRecord.h"
#import "indexCell.h"
#import "ZYQAssetPickerController.h"
#import <AVOSCloud/AVOSCloud.h>

@protocol addCheckUpRecord <NSObject>
@required
- (void)addRecord:(NSDictionary *)dic;
@end

@interface RTCheckUp : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource,UIActionSheetDelegate,UITableViewDelegate,UITableViewDataSource,refreshCheckUp,ZYQAssetPickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate,UIImagePickerControllerDelegate>
{
    RTAddCheckUpVC *inputCheckUp;
    
    UIPickerView *typePicker;
    UIDatePicker *timePicker;
    UIActionSheet *actionView;
    NSArray *checkUpType;
    NSString *selectedType;
    NSDate *selectedDate;
    NSDateFormatter *dateFormatter;
    NSDateFormatter *dateFormatter1;
    RTCheckUpRecord *checkUpRecord;
    
    int imageNum;
    NSMutableArray *imagePathArray;
    NSMutableArray *imageArray;
    
    UIView *showImage;
    UIImageView *addImgview;
    
    BOOL first;
}

@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *input;
@property (weak, nonatomic) IBOutlet UIImageView *inputTime;
@property (weak, nonatomic) IBOutlet UIImageView *inputType;
@property (nonatomic,weak) id<addCheckUpRecord> dataDelegate;
@property (weak, nonatomic) IBOutlet UILabel *lbl1;
@property (weak, nonatomic) IBOutlet UILabel *lbl2;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightButton;

- (void)refreshTableView;
@end
