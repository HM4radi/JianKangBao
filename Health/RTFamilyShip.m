//
//  RTFamilyShip.m
//  Health
//
//  Created by Mac on 7/10/14.
//  Copyright (c) 2014 RADI Team. All rights reserved.
//

#import "RTFamilyShip.h"

@implementation RTFamilyShip


+(RTFamilyShip*)initWithUser:(AVUser*) usr targetUser:(AVUser*) targetUser
{
    RTFamilyShip *a=[[self alloc]init];
    a.currentLoginUser=usr;
    a.wantedAddUser=targetUser;
    a.errorInfoString=@"";
    return a;
}


-(NSString*)doAddRelationship
{
    if (self.currentLoginUser!=nil &&self.wantedAddUser!=nil) {
        if ([self checkIfNotHasUserRecordInAVOSAndCreateIt:self.currentLoginUser]) {
            [self findUserFamilyShipFromAVOSCloud:self.currentLoginUser];
        }
        if ([self checkIfNotHasUserRecordInAVOSAndCreateIt:self.wantedAddUser]) {
            [self findUserFamilyShipFromAVOSCloud:self.wantedAddUser];
        }
        
        
        [self addFamilyMemberIntoBothUserFamilyShipArray];
        [self updateBothFamilyShipArrayToAVOSCloud];
        
        return @"成功";
    }
    
    return @"失败";
}


-(BOOL)checkIfNotHasUserRecordInAVOSAndCreateIt:(AVUser*) usr
{
    AVQuery * query =[AVQuery queryWithClassName:@"JKFriendShip"];
    
    [query whereKey:@"frienda_objectid" equalTo:usr.objectId];
    //服务器上没有该用户的好有关系记录责创建。
    if ([[query findObjects]count]>0) {
        return YES;
    }
    else
    {
    AVObject *familyShipObject = [AVObject objectWithClassName:@"JKFriendShip"];
    [familyShipObject setObject:usr.objectId forKey:@"frienda_objectid"];
    [familyShipObject save];
    return YES;
    }
    return NO;
}




//查询用户好友关系表中记录，取出friendb_objectid字段
-(void)findUserFamilyShipFromAVOSCloud:(AVUser *)hostUser
{
    AVQuery * query =[AVQuery queryWithClassName:@"JKFriendShip"];

  [query whereKey:@"frienda_objectid" equalTo:hostUser.objectId];
  
    NSArray *objects=[query findObjects];
    
          if ([objects count]<=2)
          {
              if (hostUser.objectId==self.currentLoginUser.objectId) {
                  AVObject *temp=[objects objectAtIndex:0];
                  self.selfFamilyShipArray=[temp objectForKey:@"friendb_objectid"];
              }
              if (hostUser.objectId==self.wantedAddUser.objectId) {
                  AVObject *temp=[objects objectAtIndex:0];
                  self.TargetUserFamilyShipArray=[temp objectForKey:@"friendb_objectid"];
              }
          
          }

//  [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//      
//      //服务器有该用户的记录，查询出来,并复值给数组变量。
//      
//      if ([objects count]<=2)
//      {
//          if (hostUser.objectId==self.currentLoginUser.objectId) {
//              AVObject *temp=[objects objectAtIndex:0];
//              self.selfFamilyShipArray=[temp objectForKey:@"friendb_objectid"];
//          }
//          if (hostUser.objectId==self.wantedAddUser.objectId) {
//              AVObject *temp=[objects objectAtIndex:0];
//              self.TargetUserFamilyShipArray=[temp objectForKey:@"friendb_objectid"];
//          }
//      
//      }
//      
//      
//  }];
    
}



-(void)addFamilyMemberIntoBothUserFamilyShipArray
{
    
        if (self.wantedAddUser!=nil)
        {
            
            if (self.selfFamilyShipArray==nil) {
                self.selfFamilyShipArray=[[NSArray alloc]init];
            }
            if (self.TargetUserFamilyShipArray==nil) {
                self.TargetUserFamilyShipArray=[[NSArray alloc]init];
            }
           //将本用户的ID加到目标用户;
           
            NSLog(@"currentLoginUser:%@",self.currentLoginUser.objectId);
            
             NSLog(@"wantedUserId:%@",self.wantedAddUser.objectId);
            
            self.TargetUserFamilyShipArray=[self.TargetUserFamilyShipArray arrayByAddingObject:self.currentLoginUser.objectId];
            
           
                //将目标用户id加入到本用户关系中；
                self.selfFamilyShipArray=[self.selfFamilyShipArray arrayByAddingObject:self.wantedAddUser.objectId];
            
        }
        
    

}


-(void)updateBothFamilyShipArrayToAVOSCloud;
{
    NSArray *tempArray;
    //在本用户的familyMemberObjectId,
    AVQuery *query = [AVQuery queryWithClassName:@"JKFriendShip"];
      [query whereKey:@"frienda_objectid" equalTo:self.currentLoginUser.objectId];
    tempArray=[query findObjects];
   
    if ([tempArray count]==1) {
        AVObject *gameScore =[tempArray objectAtIndex:0];
    
        [gameScore addUniqueObjectsFromArray:self.selfFamilyShipArray
                        forKey:@"friendb_objectid"];
        [gameScore saveInBackground];
        [gameScore saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [self errorInfo:error];
        }];

    }
    
    
      //提交目标用户请求
    
    AVQuery *query1 = [AVQuery queryWithClassName:@"JKFriendShip"];
    [query1 whereKey:@"frienda_objectid" equalTo:self.wantedAddUser.objectId];
    NSArray *tempArray1=[query1 findObjects];
    if ([tempArray1 count]==1) {
        AVObject *gameScore1 =[tempArray1 objectAtIndex:0];
        [gameScore1 addUniqueObjectsFromArray:self.TargetUserFamilyShipArray
                                       forKey:@"friendb_objectid"];
        [gameScore1 saveInBackground];
        [gameScore1 saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [self errorInfo:error];
        }];
    }
    

}

-(void)errorInfo:(NSError *)error
{
    self.errorInfoString=error.localizedDescription;
}

@end
