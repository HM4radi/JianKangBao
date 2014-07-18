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
    //// PaintCode Trial Version
    //// www.paintcodeapp.com
    
    //// Color Declarations
    UIColor* color7 = [UIColor colorWithRed: 1 green: 0 blue: 0 alpha: 0.235];
    
    //// Rectangle Drawing
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(0, 0, 320, 130)];
    [color7 setFill];
    [rectanglePath fill];

}


@end
