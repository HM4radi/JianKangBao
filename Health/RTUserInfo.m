//
//  RTUserInfo.m
//  Health
//
//  Created by GeoBeans on 14-6-8.
//  Copyright (c) 2014年 RADI Team. All rights reserved.
//

#import "RTUserInfo.h"

@implementation RTUserInfo

@dynamic username;
@dynamic userAge;
@dynamic userGender;
@dynamic userHeight;
@dynamic userWeight;
@dynamic userImage;
@dynamic pwd;
@dynamic phone;
@dynamic email;
@synthesize userChannelNews;

+ (NSString *)parseClassName {
    return @"_User";
}

+ (RTUserInfo*)shareInstance{
    
    static RTUserInfo* userInfo=nil;
    
    @synchronized(self)
    {
        if (!userInfo){
            userInfo = [[RTUserInfo alloc] init];
        }
        return userInfo;
    }
}

- (id)init{
    if(self = [super init]){
        userChannelNews=[[NSMutableArray alloc]init];
    }
    return self;
}

@end
