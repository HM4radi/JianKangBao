//
//  RTChecksUpViewController.m
//  Health
//
//  Created by GeoBeans on 14-7-12.
//  Copyright (c) 2014年 RADI Team. All rights reserved.
//

#import "RTChecksUpViewController.h"

@interface RTChecksUpViewController ()

@end

@implementation RTChecksUpViewController

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
    // Do any additional setup after loading the view from its nib.
}


- (void)viewWillLayoutSubviews{
    [self.navBar setFrame:CGRectMake(0, 0, 320, 64)];
    self.navBar.translucent=YES;
}

- (IBAction)touchBack:(id)sender {
    [UIView beginAnimations:@"view flip" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView transitionWithView:self.view.superview
                      duration:0.2
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{ [self.view removeFromSuperview];  }
                    completion:NULL];
    [UIView commitAnimations];

}
- (IBAction)touchAdd:(id)sender {
    if (!addCheckUp) {
        addCheckUp=[[RTAddCheckUpVC alloc]init];
    }
    
    addCheckUp.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    [self presentViewController:addCheckUp animated:YES completion:nil];
    
    addCheckUp=nil;
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
