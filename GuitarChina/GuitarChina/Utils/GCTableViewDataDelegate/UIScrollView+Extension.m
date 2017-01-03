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

- (void(^)(void))headerRefreshing {
    return objc_getAssociatedObject(self, @selector(headerRefreshing));
}

- (void)setHeaderRefreshing:(void (^)(void))headerRefreshing {
    objc_setAssociatedObject(self, @selector(headerRefreshing), headerRefreshing, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    if (headerRefreshing) {
        self.header = ({
            MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                headerRefreshing();
            }];
            header.lastUpdatedTimeLabel.hidden = YES;
            header.stateLabel.hidden = YES;
            header;
        });
    } else {
        self.header = nil;
    }
}

- (void(^)(void))footerRefreshing {
    return objc_getAssociatedObject(self, @selector(footerRefreshing));
}

- (void)setFooterRefreshing:(void (^)(void))footerRefreshing {
    objc_setAssociatedObject(self, @selector(footerRefreshing), footerRefreshing, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    if (footerRefreshing) {
        self.footer = ({
            MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                footerRefreshing();
            }];
            footer.automaticallyRefresh = YES;
            footer.refreshingTitleHidden = YES;
            [footer setTitle:NSLocalizedString(@"Load More", nil) forState:MJRefreshStateIdle];
            footer;
        });
    } else {
        self.footer = nil;
    }
}

@end
