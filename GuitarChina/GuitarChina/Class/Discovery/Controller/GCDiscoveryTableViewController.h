//
//  GCDiscoveryTableViewController.h
//  GuitarChina
//
//  Created by 陈大捷 on 16/4/10.
//  Copyright © 2016年 陈大捷. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCBaseViewController.h"

typedef NS_ENUM(NSInteger, GCDiscoveryTableViewType) {
    GCDiscoveryTableViewTypeHot,
    GCDiscoveryTableViewTypeNew,
    GCDiscoveryTableViewTypeSofa,
    GCDiscoveryTableViewTypeDigest
};

@interface GCDiscoveryTableViewController : GCBaseViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) GCDiscoveryTableViewType discoveryTableViewType;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *data;

@property (nonatomic, strong) NSMutableArray *rowHeightArray;

@property (nonatomic, assign) NSInteger pageIndex;

@end
