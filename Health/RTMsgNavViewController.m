//
//  RTMsgNavViewController.m
//  Health
//
//  Created by GeoBeans on 14-7-1.
//  Copyright (c) 2014年 RADI Team. All rights reserved.
//

#import "RTMsgNavViewController.h"

@interface RTMsgNavViewController ()

@end

@implementation RTMsgNavViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        msg=[[RTMsgViewController alloc]init];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController.navigationBar setFrame:CGRectMake(0, 0, 320, 64)];
    self.navigationController.navigationBar.translucent=YES;
        
    [self pushViewController:msg animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
