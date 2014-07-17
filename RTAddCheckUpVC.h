//
//  RTAddCheckUpVC.h
//  Health
//
//  Created by GeoBeans on 14-7-14.
//  Copyright (c) 2014年 RADI Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
#import "RTTypeCell.h"
#import "RTCheckUpRecord.h"
#import "BDKNotifyHUD.h"

@protocol refreshCheckUp <NSObject>
@required
- (void)refreshTableView;
@end


@interface RTAddCheckUpVC : UIViewController<UITableViewDelegate, UITableViewDataSource, SWTableViewCellDelegate,UISearchDisplayDelegate,UISearchBarDelegate>{
    
    NSMutableArray *checkPlist;
    NSMutableArray *typeList;
    NSMutableArray *indexList;
    NSInteger currentRow;
    
    NSMutableArray *searchResults;
    NSArray *allIndex;
    NSMutableArray *_testArray;
    RTCheckUpRecord *checkUpRecord;
    
    BOOL beginSearch;
}

@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView1;

@property (weak, nonatomic) IBOutlet UITableView *tableView2;
@property (weak, nonatomic) IBOutlet UISearchBar *search;

@property (strong, nonatomic) BDKNotifyHUD *notify;

@property(nonatomic,weak) id<refreshCheckUp> dataDelegate;
@end
