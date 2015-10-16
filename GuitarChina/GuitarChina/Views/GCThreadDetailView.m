//
//  GCThreadDetailView.m
//  GuitarChina
//
//  Created by mac on 15/10/16.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCThreadDetailView.h"
#import "MJRefresh.h"

@interface GCThreadDetailView ()

@end

@implementation GCThreadDetailView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64);
        [self configureView];
    }
    return self;
}

- (void)configureView {
    [self addSubview:self.webView];
}

- (void)beginRefresh {
    self.webViewRefreshBlock();
}

- (void)beginFetchMore {
    self.webViewFetchMoreBlock();
}

- (void)webViewEndRefresh {
    [self.webView.scrollView.header endRefreshing];
}

- (void)webViewEndFetchMore {
    [self.webView.scrollView.footer endRefreshing];
}

#pragma mark - Getters

- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64 - 44)];
        _webView.dataDetectorTypes = UIDataDetectorTypeLink;
        _webView.alpha = 0.0;
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
        _webView.scrollView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight);
        _webView.scrollView.header = ({
            MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(beginRefresh)];
            header.lastUpdatedTimeLabel.hidden = YES;
            header.stateLabel.hidden = YES;
            header;
        });
        _webView.scrollView.footer = ({
            MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(beginFetchMore)];
            footer.automaticallyRefresh = NO;
            footer;
        });
    }
    return _webView;
}

@end
