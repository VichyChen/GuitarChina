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
        self.tableView.showsVerticalScrollIndicator = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
    [backItem setBackButtonBackgroundImage:[UIImage imageNamed:@"icon_backarrow"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];//更改背景图片
    [backItem setBackButtonTitlePositionAdjustment:UIOffsetMake(-500, 0)
                                     forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.backBarButtonItem=backItem;

    
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
    else {
        [self endRefresh];
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

- (void)test111 {
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
    [backItem setBackButtonBackgroundImage:[UIImage imageNamed:@"icon_backarrow"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];//更改背景图片
    [backItem setBackButtonTitlePositionAdjustment:UIOffsetMake(0, 0)
                                     forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.backBarButtonItem=backItem;
    
}


@end
