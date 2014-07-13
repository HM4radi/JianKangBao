//
//  DDList.h
//  DropDownList
//
//  Created by kingyee on 11-9-19.
//  Copyright 2011 Kingyee. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PassValueDelegate

- (void)passValue:(NSString *)value;

@end

@interface DDList : UITableViewController {
	NSString		*_searchText;
	NSString		*_selectedText;
	NSMutableArray	*_resultList;
	id <PassValueDelegate>	_delegate;
}

@property (nonatomic, copy)NSString		*_searchText;
@property (nonatomic, copy)NSString		*_selectedText;
@property (nonatomic, retain)NSMutableArray	*_resultList;
@property(assign) id <PassValueDelegate> _delegate;

- (void)updateData:(NSMutableArray *)list;

@end

