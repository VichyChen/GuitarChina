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
        _hiddenNavigationBarWhenScrollToBottom = NO;
        _autoBeginRefresh = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
    if (!iOS7) {
        [backItem setBackButtonBackgroundImage:[UIImage imageNamed:@"icon_backArrow"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];//更改背景图片
    }
    [backItem setBackButtonTitlePositionAdjustment:UIOffsetMake(-500, 0)
                                     forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.backBarButtonItem=backItem;
    
    [self.tableView setSeparatorInset:(UIEdgeInsetsMake(0, 0, 0, 0))];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.view.backgroundColor = [UIColor GCBackgroundColor];
    //    self.view.nightBackgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
    //    self.tableView.nightBackgroundColor = [UIColor whiteColor];
    
    self.tableView.header = ({
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(beginRefresh)];
        header.lastUpdatedTimeLabel.hidden = YES;
        header.stateLabel.hidden = YES;
        header;
    });
    
    if (self.pageIndex == 1) {
        self.tableView.footer = ({
            //            MJRefreshAutoStateFooter *footer = [MJRefreshAutoStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(beginFetchMore)];
            //            footer.automaticallyRefresh = NO;
            //
            //            footer;
            MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(beginFetchMore)];
            footer.automaticallyRefresh = NO;
            footer.refreshingTitleHidden = YES;
            [footer setTitle:NSLocalizedString(@"Load More", nil) forState:MJRefreshStateIdle];
            footer;
        });
    }
    if (self.autoBeginRefresh) {
        [self.tableView.header beginRefreshing];
    }
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }    
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
    if (self.tableView.separatorStyle == UITableViewCellSeparatorStyleNone) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
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
    if (_hiddenNavigationBarWhenScrollToBottom == YES) {
        if (lastContentOffsetY >= scrollView.contentOffset.y) {
            lastContentOffsetY = scrollView.contentOffset.y;
            if (lastPosition != 0) {
                [UIView animateWithDuration:0.2 animations:^{
                    self.navigationController.navigationBar.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0.f,0);
                    lastPosition = 0;
                }];
            }
        } else {
            NSInteger position = scrollView.contentOffset.y;
            lastContentOffsetY = position;
            if (position < 0) {
                position = 0;
            }
            else if (position > 44) {
                position = 64;
            }
            [UIView animateWithDuration:0.25 animations:^{
                self.navigationController.navigationBar.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0.f,-position);
            }];
            lastPosition = -position;
        }
    }
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
