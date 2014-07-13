//
//  RTDoingViewController.m
//  Health
//
//  Created by GeoBeans on 14-6-24.
//  Copyright (c) 2014年 RADI Team. All rights reserved.
//

#import "RTDoingViewController.h"


@interface RTDoingViewController ()

@end

@implementation RTDoingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)startButton:(id)sender {
    if (!started) {
        [NSThread detachNewThreadSelector:@selector(initTimer) toTarget:self withObject:nil];
        started=YES;
        [self.startButton setTitle:@"停止" forState:UIControlStateNormal];
        _mapView.recording=YES;
        [sportRecord resetData];
        isRecorded=NO;
        sportRecord.lastPoint=CLLocationCoordinate2DMake(-9999.9999,-9999.9999);
        self.speedLabel.text = [NSString stringWithFormat:@"%.1f",0.0];
        self.distLabel.text = [NSString stringWithFormat:@"%.0f",0.0];
        self.calLabel.text = [NSString stringWithFormat:@"%.0f",0.0];

    }else{
        [self freeTimer];
        started=NO;
        [self.startButton setTitle:@"开始" forState:UIControlStateNormal];
        _mapView.recording=NO;
        [self saveDataToAVOS];
    }
}

- (void)viewWillLayoutSubviews{
    [self.navBar setFrame:CGRectMake(0, 0, 320, 64)];
    self.navBar.translucent=YES;
    
    if (DEVICE_IS_IPHONE5) {
        self.controlView.frame=CGRectMake(0, 327, 320, 191);
    }else{
        self.controlView.frame=CGRectMake(0, 239, 320, 191);
    }
    
    [self.startButton setStyleType:ACPButtonOK];
    [self.startButton setLabelTextColor:[UIColor whiteColor] highlightedColor:[UIColor greenColor] disableColor:nil];
    [self.startButton setCornerRadius:40];
    [self.startButton setLabelFont:[UIFont fontWithName:@"Trebuchet MS" size:20]];
    [self.startButton setBorderStyle:[UIColor greenColor] andInnerColor:nil];
    [self.speedLabel setFont:[UIFont fontWithName:@"DS-Digital" size:40]];
    [self.timeLabel setFont:[UIFont fontWithName:@"DS-Digital" size:30]];
    [self.calLabel setFont:[UIFont fontWithName:@"DS-Digital" size:40]];
    [self.distLabel setFont:[UIFont fontWithName:@"DS-Digital" size:40]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (!_mapView) {
        if (DEVICE_IS_IPHONE5) {
            _mapView= [[RTMapView alloc] initWithFrame:CGRectMake(0, 64, 320, 264)];
        }else{
            _mapView= [[RTMapView alloc] initWithFrame:CGRectMake(0, 64, 320, 176)];
        }
        
        [self.view addSubview:_mapView];
    }
    
    [_mapView showLocation];
    
    planData=[RTPlanData shareInstance];
    route=[_mapView convertToCoord2D:planData.routeCoord];
    if ([planData.routeCoord count]>1) {
        [_mapView addPolyline:route withcount:[planData.routeCoord count]];
    }else if ([planData.routeCoord count]==1){
        [self addPointAnno:route[0]];
        [_mapView setCenterCoord:route[0]];
    }
    started=NO;
    
    sportRecord=[RTSportRecord shareInstance];
    
    [NSThread detachNewThreadSelector:@selector(startDetector) toTarget:self withObject:nil];
}

-(void)startDetector{
    
    [SOMotionDetector sharedInstance].delegate = self;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        [SOMotionDetector sharedInstance].useM7IfAvailable = YES; //Use M7 chip if available, otherwise use lib's algorithm
    }
    [[SOMotionDetector sharedInstance] startDetection];
    [[NSRunLoop currentRunLoop] run];
    sportStatus=0;
}

-(void)initTimer
{
    //时间间隔
    NSTimeInterval timeInterval =1.0 ;
    //定时器
    timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(handleMaxShowTimer:) userInfo:nil repeats:YES];
    seconds=0;
    timeLoop=0;
    [[NSRunLoop currentRunLoop] run];
}

-(void)freeTimer{
    [timer invalidate];
}

- (void)showTimer{

    int hour=seconds/3600;
    int minute=(seconds%3600)/60;
    int second=(seconds%3600)%60;
    
    NSString *time=[NSString stringWithFormat:@"%02d:%02d:%02d",hour,minute,second];
    self.timeLabel.text=time;
}

//触发事件
-(void)handleMaxShowTimer:(NSTimer *)theTimer
{
    seconds++;
    timeLoop++;
    
    //用来判断30秒记录一次数据
    if ((seconds%10)==0) {
        isRecorded=NO;
    }
    
    [self performSelectorOnMainThread:@selector(showTimer) withObject:nil waitUntilDone:YES];
    
}

-(void)addPointAnno:(CLLocationCoordinate2D)point{
    [currentAnno setCoordinate:point];
    [currentAnno setTitle:@"途经点"];
    [_mapView addPointAnno:currentAnno];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)touchBack:(UIBarButtonItem *)sender {
    self.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - MotiionDetector Delegate
- (void)motionDetector:(SOMotionDetector *)motionDetector motionTypeChanged:(SOMotionType)motionType
{

    switch (motionType) {
        case MotionTypeNotMoving:
            sportStatus= 0;
            break;
        case MotionTypeWalking:
            sportStatus= 1;
            break;
        case MotionTypeRunning:
            sportStatus= 2;
            break;
        case MotionTypeAutomotive:
            sportStatus= 3;
            break;
    }
}

- (void)motionDetector:(SOMotionDetector *)motionDetector locationChanged:(CLLocation *)location
{

    if (started&&sportStatus!=0) {

        //计算距离
        sportRecord.thisPoint=location.coordinate;
        CGPoint p2=CGPointMake(sportRecord.thisPoint.longitude, sportRecord.thisPoint.latitude);
        NSDate *t2=[NSDate date];
        
        if (sportRecord.lastPoint.longitude!=-9999.9999) {
            CGPoint p1=CGPointMake(sportRecord.lastPoint.longitude,sportRecord.lastPoint.latitude);
            double s=sqrt((p2.x-p1.x)*(p2.x-p1.x)+(p2.y-p1.y)*(p2.y-p1.y));
            sportRecord.nowDistance+=s*3600*30.8;
        }else{
            sportRecord.nowDistance+=0;
        }
        
        sportRecord.nowCalories+=0.4;
        
        if (!isRecorded) {
            NSString *coordinate=NSStringFromCGPoint(p2);
            [sportRecord.realCoordinate addObject:coordinate];
            [sportRecord.realTime addObject:t2];
            [sportRecord.realCalories addObject:[NSNumber numberWithFloat:sportRecord.nowCalories]];
            [sportRecord.realSpeed addObject:[NSNumber numberWithFloat:motionDetector.currentSpeed * 3.6f]];
            isRecorded=YES;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
        self.speedLabel.text = [NSString stringWithFormat:@"%.1f",motionDetector.currentSpeed * 3.6f];
        self.distLabel.text = [NSString stringWithFormat:@"%.0f",sportRecord.nowDistance];
        self.calLabel.text = [NSString stringWithFormat:@"%.0f",sportRecord.nowCalories];
        });
        
        sportRecord.lastPoint=sportRecord.thisPoint;
    }
}

- (void)motionDetector:(SOMotionDetector *)motionDetector accelerationChanged:(CMAcceleration)acceleration
{
    //    BOOL isShaking = motionDetector.isShaking;
    //    self.isShakingLabel.text = isShaking ? @"shaking":@"not shaking";
    //    NSLog(@"%hhd",isShaking);
}

- (void)saveDataToAVOS{

    AVQuery *query = [AVQuery queryWithClassName:@"JKHistorySportPlan"];
    AVObject *record=[query getObjectWithId:planData.objectId];
    
    [record setObject:sportRecord.realSpeed forKey:@"speedRecord"];
    [record setObject:sportRecord.realCoordinate forKey:@"coordinateRecord"];
    [record setObject:sportRecord.realTime forKey:@"timeRecord"];
    [record setObject:sportRecord.realCalories forKey:@"caloriesRecord"];
    float caloriesPlan=[planData.calories floatValue];
    planData.progress=[NSNumber numberWithFloat:sportRecord.nowCalories/caloriesPlan];
    [record setObject:planData.progress forKey:@"planCompleteProgress"];
    [record saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [record saveEventually];
        if (!error) {
            [self.dataDelegate refreshTableView1];
        }
    }];
    record=nil;
}


@end
