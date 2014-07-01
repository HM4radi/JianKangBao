//
//  RTGYBNaviViewController.m
//  Health
//
//  Created by Mac on 5/18/14.
//  Copyright (c) 2014 RADI Team. All rights reserved.
//

#import "RTGYBNaviViewController.h"
#import "GYBTableViewController.h"
#import "RTFamilyDetailViewController.h"

@interface RTGYBNaviViewController ()

@end

@implementation RTGYBNaviViewController

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
    
     UIViewController *rootController = [[GYBTableViewController alloc] init];
    
    [self.navigationController.navigationBar setFrame:CGRectMake(0, 0, 320, 64)];
    self.navigationController.navigationBar.translucent=YES;
    self.navigationItem.titleView=self.titleLabel;
    
    //将自定义视图控制器push到导航堆栈顶部

    [self pushViewController:rootController animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
