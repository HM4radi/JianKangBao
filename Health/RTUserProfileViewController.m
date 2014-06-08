//
//  RTUserProfileViewController.m
//  Health
//
//  Created by Mac on 6/5/14.
//  Copyright (c) 2014 RADI Team. All rights reserved.
//

#import "RTUserProfileViewController.h"

@interface RTUserProfileViewController ()
{
    int stepCountflag;
}
@end

@implementation RTUserProfileViewController

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
    self.formerStepBtn.hidden=YES;
    self.formerStepBtn.enabled=NO;
    
    self.DoneBtn.hidden=YES;
    self.DoneBtn.enabled=NO;
    
    stepCountflag=0;
    [self.settingInfoView addSubview:self.step1View];
    
    self.birthdayInputTextField.inputView=self.dataPicker;
    self.birthdayInputTextField.inputAccessoryView=self.inputAccessoryView;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)nextStep:(id)sender {
    
    //step2 to step3
    if (stepCountflag==1) {
        [UIView beginAnimations:@"animation" context:nil];
        [UIView setAnimationDuration:1.0f];
        //     [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.settingInfoView cache:YES];
        
        
        //     [UIView setAnimationTransition:UIViewAnimationOptionTransitionFlipFromRight forView:self.settingInfoView cache:YES];
        [self.step2View removeFromSuperview];
        [self.settingInfoView addSubview:self.step3View];
        self.stepIndicatorImage.image=[UIImage imageNamed:@"3(1).png"];
        for (UILabel *label in self.step3IndicatorTextLabel) {
            label.textColor=[UIColor colorWithRed:0.5f green:0.75f blue:0.17f alpha:1.0f];
        }
        [UIView commitAnimations];
        stepCountflag=2;
        
        self.next.hidden=YES;
        self.next.enabled=NO;
        self.DoneBtn.hidden=NO;
        self.DoneBtn.enabled=YES;
        
        

    }
    
    //step1 to step2
    if (stepCountflag==0) {
        [UIView beginAnimations:@"animation" context:nil];
        [UIView setAnimationDuration:1.0f];
        //     [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.settingInfoView cache:YES];
        
        
        //     [UIView setAnimationTransition:UIViewAnimationOptionTransitionFlipFromRight forView:self.settingInfoView cache:YES];
        [self.step1View removeFromSuperview];
        [self.settingInfoView addSubview:self.step2View];
        self.stepIndicatorImage.image=[UIImage imageNamed:@"2(1).png"];
        for (UILabel *label in self.step2IndicatorTextLabel) {
            label.textColor=[UIColor colorWithRed:0.5f green:0.75f blue:0.17f alpha:1.0f];
        }
        [UIView commitAnimations];
        stepCountflag=1;
        self.formerStepBtn.hidden=NO;
        self.formerStepBtn.enabled=YES;
        self.cancelBtn.hidden=YES;
        self.cancelBtn.enabled=NO;
        
    }
    
   
   
}

- (IBAction)formerStep:(id)sender {
    
    
    //step2 backto step1
    if (stepCountflag==1) {
        [UIView beginAnimations:@"animation" context:nil];
        [UIView setAnimationDuration:1.0f];
        //     [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.settingInfoView cache:YES];
        
        
        //     [UIView setAnimationTransition:UIViewAnimationOptionTransitionFlipFromRight forView:self.settingInfoView cache:YES];
        [self.step2View removeFromSuperview];
        [self.settingInfoView addSubview:self.step1View];
        self.stepIndicatorImage.image=[UIImage imageNamed:@"1(1).png"];
        for (UILabel *label in self.step2IndicatorTextLabel) {
            label.textColor=[UIColor colorWithRed:0.88f green:0.88f blue:0.88f alpha:1.0f];
        }
        [UIView commitAnimations];
        stepCountflag=0;
        self.formerStepBtn.hidden=YES;
        self.formerStepBtn.enabled=NO;
        self.cancelBtn.hidden=NO;
        self.cancelBtn.enabled=YES;
    }
    
    
    //step3 backto step1
    if (stepCountflag==2) {
        [UIView beginAnimations:@"animation" context:nil];
        [UIView setAnimationDuration:1.0f];
        //     [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.settingInfoView cache:YES];
        
        
        //     [UIView setAnimationTransition:UIViewAnimationOptionTransitionFlipFromRight forView:self.settingInfoView cache:YES];
        [self.step3View removeFromSuperview];
        [self.settingInfoView addSubview:self.step2View];
        self.stepIndicatorImage.image=[UIImage imageNamed:@"2(1).png"];
        for (UILabel *label in self.step3IndicatorTextLabel) {
            label.textColor=[UIColor colorWithRed:0.88f green:0.88f blue:0.88f alpha:1.0f];
        }
        [UIView commitAnimations];
        stepCountflag=1;
        
        self.DoneBtn.hidden=YES;
        self.DoneBtn.enabled=NO;
        self.next.hidden=NO;
        self.next.enabled=YES;
        
    }
    
    
}
- (IBAction)DoneAction:(id)sender {
}

- (IBAction)cancelAction:(id)sender {
    
}




-(IBAction)dataChanged:(id)sender
{
    UIDatePicker *picker = (UIDatePicker *)sender;
    
    self.birthdayInputTextField.text = [NSString stringWithFormat:@"%@", picker.date];


}
@end
