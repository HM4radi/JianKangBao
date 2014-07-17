//
//  RTForthNavVC.h
//  Health
//
//  Created by GeoBeans on 14-7-3.
//  Copyright (c) 2014年 RADI Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ForthViewController.h"
#import "RTMainViewController.h"


@interface RTForthNavVC : UINavigationController<logOut>
{
    ForthViewController *forthVC;
}

- (void)userLogOut;
@end
