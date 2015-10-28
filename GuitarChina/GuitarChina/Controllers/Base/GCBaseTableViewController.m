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
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
    [backItem setBackButtonBackgroundImage:[UIImage imageNamed:@"icon_backArrow"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];//更改背景图片
    [backItem setBackButtonTitlePositionAdjustment:UIOffsetMake(-500, 0)
                                     forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.backBarButtonItem=backItem;
    
    [self.tableView setSeparatorInset:(UIEdgeInsetsMake(0, 15, 0, 15))];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.header = ({
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(beginRefresh)];
        header.lastUpdatedTimeLabel.hidden = YES;
        header.stateLabel.hidden = YES;
        header;
    });
    
    if (self.pageIndex == 1) {
        self.tableView.footer = ({
            MJRefreshAutoStateFooter *footer = [MJRefreshAutoStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(beginFetchMore)];
            footer.automaticallyRefresh = NO;
            
            footer;
        });
    }
    [self.tableView.header beginRefreshing];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
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

@end
