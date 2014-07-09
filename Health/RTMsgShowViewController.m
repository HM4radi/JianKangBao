//
//  RTMsgShowViewController.m
//  Health
//
//  Created by GeoBeans on 14-7-2.
//  Copyright (c) 2014年 RADI Team. All rights reserved.
//

#import "RTMsgShowViewController.h"

@interface RTMsgShowViewController ()

@end

@implementation RTMsgShowViewController
@synthesize objectId;
@synthesize textView;

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
    
    self.textView.textColor = [UIColor blackColor];
    self.textView.font = [UIFont fontWithName:@"Arial" size:18.0];
    self.textView.delegate = self;
    self.textView.scrollEnabled = YES;
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.textView.editable=NO;
}

-(void)viewDidAppear:(BOOL)animated{
    
    UIActivityIndicatorView  *act=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [act setCenter:CGPointMake(160,100)];
    [self.view addSubview:act];
    [act startAnimating];
    AVQuery *query = [AVQuery queryWithClassName:@"JKChannelNew"];
    [query whereKey:@"objectId" equalTo:self.objectId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            AVObject *news=[query getFirstObject];
            NSString *text=[news objectForKey:@"newsContent"];
            NSString *title=[news objectForKey:@"newsTitle"];
            self.textView.text =text;
            //self.navigationController.
            //self.titleLabel.text=title;
            [act stopAnimating];
        } else {
            [act stopAnimating];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"信息加载失败" message:@"网络有点不给力哦，请稍后再试~" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    }];
}


- (void)viewWillLayoutSubviews{
    [self.navBar setFrame:CGRectMake(0, 0, 320, 64)];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                   style:UIBarButtonItemStylePlain target:self action:@selector(touchBack)];
    leftButton.tintColor=[UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = leftButton;
    
}

- (void)touchBack{
    [[self navigationController] popViewControllerAnimated:YES];
    self.textView.text =nil;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
