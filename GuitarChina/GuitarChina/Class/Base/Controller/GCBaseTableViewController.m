//
//  GCBaseTableViewController.m
//  GuitarChina
//
//  Created by 陈大捷 on 15/8/30.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCBaseTableViewController.h"

@interface GCBaseTableViewController () {
    NSInteger lastContentOffsetY;
    NSInteger lastPosition;
}

@end

@implementation GCBaseTableViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _autoBeginRefresh = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    if (!iOS7) {
        [backItem setBackButtonBackgroundImage:[UIImage imageNamed:@"icon_backArrow"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    }
    [backItem setBackButtonTitlePositionAdjustment:UIOffsetMake(-500, 0)
                                     forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.backBarButtonItem = backItem;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.header = ({
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(beginRefresh)];
        header.lastUpdatedTimeLabel.hidden = YES;
        header.stateLabel.hidden = YES;
        header;
    });
    if (self.pageIndex == 1) {
        self.tableView.footer = ({
            MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(beginFetchMore)];
            footer.automaticallyRefresh = YES;
            footer.refreshingTitleHidden = YES;
            [footer setTitle:NSLocalizedString(@"Load More", nil) forState:MJRefreshStateIdle];
            footer;
        });
    }
    self.tableView.tableFooterView = [[UIView alloc] init];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if (self.autoBeginRefresh) {
        [self.tableView.header beginRefreshing];
    }
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

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
  
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - Getters

- (NSMutableArray *)rowHeightArray {
    if (!_rowHeightArray) {
        _rowHeightArray = [NSMutableArray array];
    }
    return _rowHeightArray;
}

- (NSMutableDictionary *)rowHeightDictionary {
    if (!_rowHeightDictionary) {
        _rowHeightDictionary = [NSMutableDictionary dictionary];
    }
    return _rowHeightDictionary;
}

@end
