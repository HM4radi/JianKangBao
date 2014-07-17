//
//  RTMsgShowViewController.h
//  Health
//
//  Created by GeoBeans on 14-7-2.
//  Copyright (c) 2014年 RADI Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVOSCloud/AVOSCloud.h>
@interface RTMsgShowViewController : UIViewController<UITextViewDelegate>{
    
}

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (strong, nonatomic) NSString *objectId;

@end
