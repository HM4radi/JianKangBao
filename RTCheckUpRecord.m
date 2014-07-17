//
//  RTCheckUpRecord.m
//  Health
//
//  Created by GeoBeans on 14-7-15.
//  Copyright (c) 2014年 RADI Team. All rights reserved.
//

#import "RTCheckUpRecord.h"

@implementation RTCheckUpRecord
@synthesize indexArray;
@synthesize checkUpStyle;
@synthesize checkUpTime;
@synthesize exist;
@synthesize objectId;

+ (RTCheckUpRecord*)shareInstance{
    
    static RTCheckUpRecord* record=nil;
    
    @synchronized(self)
    {
        if (!record){
            record = [[RTCheckUpRecord alloc] init];
        }
        return record;
    }
}

- (id)init{
    if(self = [super init]){
        indexArray=[[NSMutableArray alloc]init];
    }
    return self;
}

- (void)resetting{
    [indexArray removeAllObjects];
    checkUpStyle=nil;
    checkUpTime=nil;
    exist=NO;
}
@end
