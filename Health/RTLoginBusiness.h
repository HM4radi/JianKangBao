//
//  RTLoginBusiness.h
//  Health
//
//  Created by Mac on 6/4/14.
//  Copyright (c) 2014 RADI Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud/AVOSCloud.h>

@interface RTLoginBusiness : NSObject
{
   

}

@property (nonatomic,strong)NSString *username;
@property (nonatomic,strong)NSString *pwd;
@property (nonatomic,strong)NSString *phone;
@property (nonatomic,strong)NSString *email;
@property (nonatomic,strong)NSString *feedback;
@property  BOOL isSucceed;


-(void) loginInbackground:(NSString*) username Pwd:(NSString*)pwd;



-(void) login:(NSString*) username Pwd:(NSString*)pwd;

-(BOOL) loginIsSucceed:(BOOL)result;
@end
