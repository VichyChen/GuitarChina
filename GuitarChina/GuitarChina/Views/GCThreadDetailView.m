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
        self.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight);
        [self configureView];
    }
    return self;
}

- (void)configureView {
    [self addSubview:self.webView];
    [self addSubview:self.separatorLineView];
    [self addSubview:self.pageButton];
    [self addSubview:self.backButton];
    [self addSubview:self.forwardButton];
    [self addSubview:self.scrollTopButton];
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

- (void)pageAction {
    if (!self.pageActionBlock) {
        self.pageActionBlock();
    }
}

- (void)backAction {
    if (self.backActionBlock) {
        self.backActionBlock();
    }
}

- (void)forwardAction {
    if (self.forwardActionBlock) {
        self.forwardActionBlock();
    }
}

- (void)scrollTopAction {
    [self.webView.scrollView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
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

- (UIView *)separatorLineView {
    if (!_separatorLineView) {
        _separatorLineView = [UIView createHorizontalLine:ScreenWidth originX:0 originY:ScreenHeight - 64 - 44 color:[UIColor GCGrayLineColor]];
    }
    return _separatorLineView;
}

- (UIButton *)pageButton {
    if (!_pageButton) {
        _pageButton = [UIView createButton:CGRectMake(ScreenWidth / 2 - 30, ScreenHeight - 64 - 44, 60, 44)
                                      text:@"1"
                                    target:self
                                    action:@selector(pageAction)];
        _pageButton.tintColor = [UIColor GCRedColor];
    }
    return _pageButton;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIView createButton:CGRectMake(ScreenWidth / 2 - 30 - 44, ScreenHeight - 64 - 44, 44, 44)
                                    target:self
                                    action:@selector(backAction)];
        [_backButton setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
        _backButton.tintColor = [UIColor GCRedColor];
    }
    return _backButton;
}

- (UIButton *)forwardButton {
    if (!_forwardButton) {
        _forwardButton = [UIView createButton:CGRectMake(ScreenWidth / 2 + 30, ScreenHeight - 64 - 44, 44, 44)
                                       target:self
                                       action:@selector(forwardAction)];
        [_forwardButton setImage:[UIImage imageNamed:@"icon_forward"] forState:UIControlStateNormal];
        _forwardButton.tintColor = [UIColor GCRedColor];
    }
    return _forwardButton;
}

- (UIButton *)scrollTopButton {
    if (!_scrollTopButton) {
        _scrollTopButton = [UIView createButton:CGRectMake(ScreenWidth - 15 - 44, ScreenHeight - 64 - 44, 44, 44)
                                         target:self
                                         action:@selector(scrollTopAction)];
        [_scrollTopButton setImage:[UIImage imageNamed:@"icon_up"] forState:UIControlStateNormal];
        _scrollTopButton.tintColor = [UIColor GCRedColor];
    }
    return _scrollTopButton;
}


@end
