//
//  RTAddFamilyMemberViewController.h
//  Health
//
//  Created by Mac on 7/10/14.
//  Copyright (c) 2014 RADI Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVOSCloud/AVOSCloud.h>
#import "RTUserInfo.h"
@class RTAddMemResultView;
@interface RTAddFamilyMemberViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextInputDelegate,UITextFieldDelegate>
@property (strong,nonatomic) AVUser *currentLoginUser;
@property (strong,nonatomic) NSArray *targetAVUserArray;

@property (strong, nonatomic) IBOutlet UITextField *AddMemPhoneInputInText;
@property (strong, nonatomic) IBOutlet UIButton *SubmitAddBtn;
- (IBAction)SubmitAndDismiss:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *rightAndErrorImage;
@property (strong, nonatomic) IBOutlet UILabel *errorInfoLabel;
@property (strong, nonatomic) IBOutlet UITableView *resultTableView;
@property (strong, nonatomic) IBOutlet UILabel *resultCountLabel;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *SearchActivityIndicator;
@property (strong, nonatomic) IBOutlet RTAddMemResultView *resultView;

@property (strong, nonatomic) IBOutlet RTAddMemResultView *resultView2;




@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *resultFixedInfoLabelCollection;



@end
