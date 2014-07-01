//
//  RTDoingViewController.h
//  Health
//
//  Created by GeoBeans on 14-6-27.
//  Copyright (c) 2014年 RADI Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTMapView.h"
#import "RTPlanData.h"
#import "ACPButton.h"
#import "RTSportRecord.h"
#import "SOMotionDetector.h"
#import <AVOSCloud/AVOSCloud.h>

@protocol refreshData <NSObject>
@required
- (void)refreshTableView1;
@end

@interface RTDoingViewController : UIViewController<SOMotionDetectorDelegate>{
    RTMapView *_mapView;
    RTPlanData *planData;
    CLLocationCoordinate2D *route;
    QPointAnnotation* currentAnno;
    NSTimer *timer;
    long seconds;
    BOOL started;
    int timeLoop;
    RTSportRecord *sportRecord;
    int sportStatus;
    BOOL isRecorded;
}

@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;

@property (weak, nonatomic) IBOutlet ACPButton *startButton;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *distLabel;

@property (weak, nonatomic) IBOutlet UILabel *calLabel;

@property (weak, nonatomic) IBOutlet UILabel *speedLabel;

@property(nonatomic,weak) id<refreshData> dataDelegate;

@end
