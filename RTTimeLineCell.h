//
//  RTTimeLineCell.h
//  Health
//
//  Created by GeoBeans on 14-7-16.
//  Copyright (c) 2014年 RADI Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RTTimeLineCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@property (weak, nonatomic) IBOutlet UILabel *abnormalNum;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@end
