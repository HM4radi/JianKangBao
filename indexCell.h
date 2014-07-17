//
//  indexCell.h
//  Health
//
//  Created by GeoBeans on 14-7-15.
//  Copyright (c) 2014年 RADI Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface indexCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *indexNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *referenceLabel;

@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@end
