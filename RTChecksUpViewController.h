//
//  RTChecksUpViewController.h
//  Health
//
//  Created by GeoBeans on 14-7-12.
//  Copyright (c) 2014年 RADI Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTAddCheckUpVC.h"


@interface RTChecksUpViewController : UIViewController{
    RTAddCheckUpVC *addCheckUp;
}
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;

@end
