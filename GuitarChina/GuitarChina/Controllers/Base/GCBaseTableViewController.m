//
//  GCBaseTableViewController.m
//  GuitarChina
//
//  Created by 陈大捷 on 15/8/30.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCBaseTableViewController.h"

@interface GCBaseTableViewController ()

@end

@implementation GCBaseTableViewController

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.header = ({
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(beginRefresh)];
        header.lastUpdatedTimeLabel.hidden = YES;
        header.stateLabel.hidden = YES;
        header;
    });
    if (self.pageIndex == 1) {
        self.tableView.footer = ({
            MJRefreshAutoStateFooter *footer = [MJRefreshAutoStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(beginFetchMore)];
            
            footer;
        });
    }
    
    [self.tableView.header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Public Methods

- (void)beginRefresh {
    if (self.refreshBlock) {
        if (self.pageIndex == 0) {
            
        } else {
            self.pageIndex = 1;
        }
        self.refreshBlock();
    }
}

- (void)endRefresh {
    [self.tableView.header endRefreshing];
}

- (void)beginFetchMore {
    if (self.refreshBlock) {
        if (self.pageIndex != 0) {
            self.pageIndex++;
            self.refreshBlock();
        }
    }
}

- (void)endFetchMore {
    [self.tableView.footer endRefreshing];
}

@end
