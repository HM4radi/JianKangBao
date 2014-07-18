//
//  RTSportTimingVC.m
//  Health
//
//  Created by GeoBeans on 14-7-18.
//  Copyright (c) 2014年 RADI Team. All rights reserved.
//

#import "RTSportTimingVC.h"

@interface RTSportTimingVC ()

@end

@implementation RTSportTimingVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.gifView.image=[YLGIFImage imageNamed:@"running.gif"];
    
    self.timerProgressView.progressTintColor = [UIColor colorWithRed:130.0/255.0 green:190.0/255.0 blue:20.0/255.0 alpha:0.6];
    [self.timerProgressView setMeterType:DPMeterTypeLinearHorizontal];
    self.timerProgressView.trackTintColor = [UIColor colorWithRed:222/255.f green:222/255.f blue:222/255.f alpha:0.6f];
    [self.timerProgressView setShape:[UIBezierPath bezierPathWithRoundedRect:self.timerProgressView.bounds cornerRadius:0.f].CGPath];
    [self.timerProgressView.layer setBorderWidth:0.0f];
    [self.timerProgressView.layer setBorderColor:[UIColor colorWithRed:130.0/255.0 green:190.0/255.0 blue:20.0/255.0 alpha:1.0].CGColor];
    [self updateProgressWithDelta:0 shapeView:self.timerProgressView animated:true];
    
    startButton = [[DKCircleButton alloc] initWithFrame:CGRectMake(0, 0, 90, 90)];
    
    startButton.center = CGPointMake(160, 454);
    startButton.titleLabel.font = [UIFont systemFontOfSize:22];
    
    [startButton setTitleColor:[UIColor colorWithWhite:1 alpha:1.0] forState:UIControlStateNormal];
    [startButton setTitleColor:[UIColor colorWithWhite:1 alpha:1.0] forState:UIControlStateSelected];
    [startButton setTitleColor:[UIColor colorWithWhite:1 alpha:1.0] forState:UIControlStateHighlighted];
    
    [startButton setTitle:NSLocalizedString(@"START", nil) forState:UIControlStateNormal];
    [startButton setTitle:NSLocalizedString(@"START", nil) forState:UIControlStateSelected];
    [startButton setTitle:NSLocalizedString(@"START", nil) forState:UIControlStateHighlighted];
    
    [startButton addTarget:self action:@selector(tapOnButton) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:startButton];
    
}

- (void)updateProgressWithDelta:(CGFloat)delta shapeView:(DPMeterView*)shapeView animated:(BOOL)animated
{
    if (delta < 0) {
        [shapeView minus:fabs(delta) animated:animated];
    } else {
        [shapeView add:fabs(delta) animated:animated];
    }
}

-(void)initTimer
{
    started=NO;
    //时间间隔
    NSTimeInterval timeInterval =0.1 ;
    //定时器
    timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(handleMaxShowTimer:) userInfo:nil repeats:YES];
    passedTime=0;
    [[NSRunLoop currentRunLoop] run];
}

-(void)handleMaxShowTimer:(NSTimer *)theTimer
{
    passedTime++;
    //用来判断30秒记录一次数据
    if (passedTime>=30) {
        passedTime=0;
    }
    
    float percent=0.003333;
    [self updateProgressWithDelta:percent shapeView:self.timerProgressView animated:NO];
}

-(void)tapOnButton{
    
    if (started==NO) {
        [NSThread detachNewThreadSelector:@selector(initTimer) toTarget:self withObject:nil];
        [startButton setTitle:NSLocalizedString(@"STOP", nil) forState:UIControlStateNormal];
        [startButton setTitle:NSLocalizedString(@"STOP", nil) forState:UIControlStateSelected];
        [startButton setTitle:NSLocalizedString(@"STOP", nil) forState:UIControlStateHighlighted];
        started=YES;
        NSLog(@"start");
    }
    else{
        //[timer invalidate];
        [timer setFireDate:[NSDate distantFuture]];
        [startButton setTitle:NSLocalizedString(@"START", nil) forState:UIControlStateNormal];
        [startButton setTitle:NSLocalizedString(@"START", nil) forState:UIControlStateSelected];
        [startButton setTitle:NSLocalizedString(@"START", nil) forState:UIControlStateHighlighted];
        started=NO;
        NSLog(@"stop");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
