//
//  GCBaseTableViewController.h
//  GuitarChina
//
//  Created by 陈大捷 on 15/8/30.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"

@interface GCBaseTableViewController : UITableViewController

@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, assign) BOOL hiddenNavigationBarWhenScrollToBottom;

@property (nonatomic, strong) NSMutableArray *rowHeightArray;
@property (nonatomic, strong) NSMutableDictionary *rowHeightDictionary;

@property (nonatomic, copy) void (^refreshBlock)();
@property (nonatomic, copy) void (^fetchMoreBlock)();

- (void)beginFetchMore;
- (void)endFetchMore;

- (void)beginRefresh;
- (void)endRefresh;

@end
