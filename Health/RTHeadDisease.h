//
//  RTHeadDisease.h
//  Health
//
//  Created by Mac on 5/28/14.
//  Copyright (c) 2014 RADI Team. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RTHeadDisease : NSObject
@property(nonatomic,strong)NSString* name;
@property(nonatomic,strong)NSString* info;
+(id)headDiseaseOfCategory:(NSString*)info name:(NSString*)name;
@end
