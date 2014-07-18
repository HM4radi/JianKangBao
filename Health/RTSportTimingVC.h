//
//  RTSportTimingVC.h
//  Health
//
//  Created by GeoBeans on 14-7-18.
//  Copyright (c) 2014年 RADI Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLGIFImage.h"
#import "YLImageView.h"
#import "DPMeterView.h"
#import "DKCircleButton.h"

@interface RTSportTimingVC : UIViewController
{
    DKCircleButton *startButton;
    NSTimer *timer;
    float passedTime;
    BOOL started;
}
@property (strong, nonatomic) IBOutlet DPMeterView *timerProgressView;

@property (weak, nonatomic) IBOutlet YLImageView *gifView;

@end
