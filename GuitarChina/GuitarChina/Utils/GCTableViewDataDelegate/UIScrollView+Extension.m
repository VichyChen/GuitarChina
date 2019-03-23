//
//  UIScrollView+Extension.m
//  GuitarChina
//
//  Created by mac on 17/1/3.
//  Copyright © 2017年 陈大捷. All rights reserved.
//

#import "UIScrollView+Extension.h"
#import "MJRefresh.h"

@implementation UIScrollView (Extension)

- (void(^)(void))headerRefreshBlock {
    return objc_getAssociatedObject(self, @selector(headerRefreshBlock));
}

- (void)setHeaderRefreshBlock:(void (^)(void))headerRefreshBlock {
    objc_setAssociatedObject(self, @selector(headerRefreshBlock), headerRefreshBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);

    if (headerRefreshBlock) {
        self.header = ({
            MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                headerRefreshBlock();
            }];
            header.lastUpdatedTimeLabel.hidden = YES;
            header.stateLabel.hidden = YES;
            header;
        });
    } else {
        self.header = nil;
    }
}

- (void(^)(void))footerRefreshBlock {
    return objc_getAssociatedObject(self, @selector(footerRefreshBlock));
}

- (void)setFooterRefreshBlock:(void (^)(void))footerRefreshBlock {
    objc_setAssociatedObject(self, @selector(footerRefreshBlock), footerRefreshBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    if (footerRefreshBlock) {
        self.footer = ({
            MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                footerRefreshBlock();
            }];
            footer.automaticallyRefresh = YES;
            footer.refreshingTitleHidden = YES;
            [footer setTitle:@"加载更多" forState:MJRefreshStateIdle];
            footer;
        });
    } else {
        self.footer = nil;
    }
}

- (void)headerBeginRefresh {
    [self.header beginRefreshing];
}

- (void)headerEndRefresh {
    [self.header endRefreshing];
}

- (void)footerBeginRefresh {
    [self.footer beginRefreshing];
}

- (void)footerEndRefresh {
    [self.footer endRefreshing];
}

- (BOOL)isRefreshing {
    return [self.header isRefreshing] || [self.footer isRefreshing];
}

- (void)noticeNoMoreData {
    [self.footer noticeNoMoreData];
}

- (void)resetNoMoreData {
    [self.footer resetNoMoreData];
}

@end
