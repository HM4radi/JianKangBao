//
//  RTCheckUpRecord.h
//  Health
//
//  Created by GeoBeans on 14-7-15.
//  Copyright (c) 2014年 RADI Team. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RTCheckUpRecord : NSObject
{
    NSMutableArray *indexArray;
}

@property (nonatomic,strong) NSDate *checkUpTime;
@property (nonatomic,strong) NSString *checkUpStyle;
@property (nonatomic,strong) NSMutableArray *indexArray;
@property (nonatomic) BOOL exist;
@property (nonatomic,strong) NSString *objectId;
+ (RTCheckUpRecord*)shareInstance;
- (void)resetting;
@end
