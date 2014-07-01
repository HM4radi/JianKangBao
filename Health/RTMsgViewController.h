//
//  RTMsgViewController.h
//  Health
//
//  Created by GeoBeans on 14-5-28.
//  Copyright (c) 2014年 RADI Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTCollectionViewCell.h"
#import "RTMsgDetailViewController.h"
#import <AVOSCloud/AVOSCloud.h>

@interface RTMsgViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    NSMutableArray *msgArray;
    NSMutableArray *channel;
    RTMsgDetailViewController *detailVC;
    
    BOOL loadDirect;
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@end
