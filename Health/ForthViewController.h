//
//  ForthViewController.h
//  Health
//
//  Created by GeoBeans on 14-5-15.
//  Copyright (c) 2014年 RADI Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVOSCloud/AVOSCloud.h>

@protocol logOut <NSObject>
@required
- (void)userLogOut;
@end

@interface ForthViewController : UIViewController

@property (retain, nonatomic) IBOutlet UINavigationBar *navigationbar;

@property (weak, nonatomic) IBOutlet UIScrollView *configScroll;

@property(nonatomic,weak) id<logOut> logOutDelegate;

- (IBAction)signOutsignOut:(id)sender;


@end
