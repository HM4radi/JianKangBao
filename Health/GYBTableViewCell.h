//
//  GYBTableViewCell.h
//  TableView
//
//  Created by Mac on 5/17/14.
//  Copyright (c) 2014 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPMeterView.h"
#import "UIBezierPath+BasicShapes.h"



@interface GYBTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property CGFloat *statueValue;


@property (strong, nonatomic)IBOutlet DPMeterView *statueView;
- (IBAction)locateInMap:(id)sender;

- (void)updateProgressWithDelta:(CGFloat)delta animated:(BOOL)animated;
@property (strong, nonatomic) IBOutlet UIImageView *WarningImage;
@property (strong, nonatomic) IBOutlet UIImageView *sportImage;

@property (strong, nonatomic) IBOutlet UILabel *otherNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *dynamicMessageLabel;
@property (strong, nonatomic) IBOutlet UIImageView *protaitView;

@end
