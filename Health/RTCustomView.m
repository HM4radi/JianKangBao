//
//  RTCustomView.m
//  Health
//
//  Created by Mac on 7/8/14.
//  Copyright (c) 2014 RADI Team. All rights reserved.
//

#import "RTCustomView.h"

@implementation RTCustomView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    //// PaintCode Trial Version
    //// www.paintcodeapp.com
    
    //// General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    UIColor* color = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
    
    //// Shadow Declarations
    UIColor* shadow = [UIColor.lightGrayColor colorWithAlphaComponent: 0.45];
    CGSize shadowOffset = CGSizeMake(5.1, 5.1);
    CGFloat shadowBlurRadius = 5;
    
    //// Rectangle Drawing
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(108, 164, 320, 140) cornerRadius: 21];
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, [shadow CGColor]);
    [color setFill];
    [rectanglePath fill];
    CGContextRestoreGState(context);

}


@end
