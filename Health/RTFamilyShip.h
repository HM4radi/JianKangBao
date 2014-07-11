//
//  RTFamilyShip.h
//  Health
//
//  Created by Mac on 7/10/14.
//  Copyright (c) 2014 RADI Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud/AVOSCloud.h>
@interface RTFamilyShip : NSObject

//实例化
+(RTFamilyShip*)initWithUser:(AVUser*) usr targetUser:(AVUser*) targetUser;
//错误信息

@property NSString *errorInfoString;
//本用户
@property (strong,nonatomic) AVUser *currentLoginUser;
@property NSArray *selfFamilyShipArray;

//添加用户

@property (strong,nonatomic)AVUser *wantedAddUser;
@property NSArray *TargetUserFamilyShipArray;


//公用方法

-(NSString*)doAddRelationship;

//私有方法

-(void)findUserFamilyShipFromAVOSCloud:(AVUser *)hostUser;
-(void)addFamilyMemberIntoBothUserFamilyShipArray;

-(void)updateBothFamilyShipArrayToAVOSCloud;

-(void)errorInfo:(NSError *)error;
@end
