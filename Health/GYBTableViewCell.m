//
//  GYBTableViewCell.m
//  TableView
//
//  Created by Mac on 5/17/14.
//  Copyright (c) 2014 Mac. All rights reserved.
//

#import "GYBTableViewCell.h"
#import "DPMeterView.h"
#import "UIBezierPath+BasicShapes.h"
#import "RTCustomView.h"

@implementation GYBTableViewCell




- (void)awakeFromNib
{
    // Initialization code
    UIImageView *portraitView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 20, 62, 62)];
    [portraitView.layer setCornerRadius:CGRectGetHeight(portraitView.bounds)/2];
    portraitView.layer.borderColor = [UIColor blueColor].CGColor;
    //    portraitView.layer.borderWidth = 0.5;
    [portraitView.layer setMasksToBounds:YES];

    self.protaitView=portraitView;
    [self addSubview:portraitView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)locateInMap:(id)sender {
}

- (void)updateProgressWithDelta:(CGFloat)delta animated:(BOOL)animated
{
    NSArray *shapeViews = [self shapeViewss];
    for (DPMeterView *shapeView in shapeViews) {
        if (delta < 0) {
            [shapeView minus:fabs(delta) animated:animated];
        } else {
            [shapeView add:fabs(delta) animated:animated];
        }
    }
    
//    self.title = [NSString stringWithFormat:@"%.2f%%",
//                  [(DPMeterView *)[shapeViews lastObject] progress]*100];
}

- (NSArray *)shapeViewss
{
    NSMutableArray *shapeViews = [NSMutableArray array];
    
    if (self.statueView && [self.statueView isKindOfClass:[DPMeterView class]])
        [shapeViews addObject:self.statueView];
    
  
    return [NSArray arrayWithArray:shapeViews];
}
@end
