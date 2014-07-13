//
//  RTAddCheckUpVC.h
//  Health
//
//  Created by GeoBeans on 14-7-12.
//  Copyright (c) 2014年 RADI Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTTypeCell.h"
#import "RTIndexCell.h"

@interface RTAddCheckUpVC : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray *checkPlist;
    NSMutableArray *typeList;
    NSMutableArray *indexList;
    NSInteger currentRow;
}
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView1;
@property (weak, nonatomic) IBOutlet UITableView *tableView2;

@end
