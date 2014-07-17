//
//  UIPopoverListView.m
//  UIPopoverListViewDemo
//
//  Created by su xinde on 13-3-13.
//  Copyright (c) 2013年 su xinde. All rights reserved.
//

#import "UIPopoverListView.h"
#import <QuartzCore/QuartzCore.h>

//#define FRAME_X_INSET 20.0f
//#define FRAME_Y_INSET 40.0f

@interface UIPopoverListView ()

- (void)defalutInit;
- (void)fadeIn;
- (void)fadeOut;

@end

@implementation UIPopoverListView

@synthesize datasource = _datasource;
@synthesize delegate = _delegate;

@synthesize listView = _listView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self defalutInit];
    }
    return self;
}

- (void)defalutInit
{
    self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.layer.borderWidth = 1.0f;
    self.layer.cornerRadius = 10.0f;
    self.clipsToBounds = TRUE;
    
    _titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleView.font = [UIFont systemFontOfSize:17.0f];

    _titleView.backgroundColor =[UIColor colorWithRed:130.0/255.0 green:190.0/255.0 blue:20.0/255.0 alpha:1.0];
    _titleView.textAlignment = NSTextAlignmentCenter;
    _titleView.textColor = [UIColor whiteColor];
    CGFloat xWidth = self.bounds.size.width;
    _titleView.lineBreakMode = UILineBreakModeTailTruncation;
    _titleView.frame = CGRectMake(0, 0, xWidth, 32.0f);
    [self addSubview:_titleView];
    
    CGRect tableFrame = CGRectMake(0, 32.0f, xWidth, self.bounds.size.height-32.0f);
    _listView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
    _listView.dataSource = self;
    _listView.delegate = self;
    [self addSubview:_listView];
    
    _overlayView = [[UIControl alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _overlayView.backgroundColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.5];
    [_overlayView addTarget:self
                     action:@selector(dismiss)
           forControlEvents:UIControlEventTouchUpInside];
    
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.datasource &&
       [self.datasource respondsToSelector:@selector(popoverListView:numberOfRowsInSection:)])
    {
        return [self.datasource popoverListView:self numberOfRowsInSection:section];
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.datasource &&
       [self.datasource respondsToSelector:@selector(popoverListView:cellForIndexPath:)])
    {
        return [self.datasource popoverListView:self cellForIndexPath:indexPath];
    }
    return nil;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.delegate &&
       [self.delegate respondsToSelector:@selector(popoverListView:heightForRowAtIndexPath:)])
    {
        return [self.delegate popoverListView:self heightForRowAtIndexPath:indexPath];
    }
    
    return 0.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.delegate &&
       [self.delegate respondsToSelector:@selector(popoverListView:didSelectIndexPath:)])
    {
        [self.delegate popoverListView:self didSelectIndexPath:indexPath];
    }
    
    [self dismiss];
}


#pragma mark - animations

- (void)fadeIn
{
    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];
    
}
- (void)fadeOut
{
    [UIView animateWithDuration:.35 animations:^{
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [_overlayView removeFromSuperview];
            [self removeFromSuperview];
        }
    }];
}

- (void)setTitle:(NSString *)title
{
    _titleView.text = title;
}

- (void)show
{
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview:_overlayView];
    [keywindow addSubview:self];
    
    self.center = CGPointMake(keywindow.bounds.size.width/2.0f,
                              keywindow.bounds.size.height/2.0f);
    [self fadeIn];
}

- (void)dismiss
{
    [self fadeOut];
}

#define mark - UITouch
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // tell the delegate the cancellation
    if (self.delegate && [self.delegate respondsToSelector:@selector(popoverListViewCancel:)]) {
        [self.delegate popoverListViewCancel:self];
    }
    
    // dismiss self
    [self dismiss];
}


@end
