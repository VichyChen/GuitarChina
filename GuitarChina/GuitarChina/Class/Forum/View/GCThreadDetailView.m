//
//  GCThreadDetailView.m
//  GuitarChina
//
//  Created by mac on 15/10/16.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCThreadDetailView.h"

@interface GCThreadDetailView ()

@end

@implementation GCThreadDetailView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configureView];
    }
    return self;
}

#pragma mark - Public Methods

- (void)webViewStartRefresh {
    [self.webView.scrollView headerBeginRefresh];
}

- (void)webViewStartFetchMore {
    [self.webView.scrollView headerBeginRefresh];
}

- (void)webViewEndRefresh {
    [self.webView.scrollView headerEndRefresh];
}

- (void)webViewEndFetchMore {
    [self.webView.scrollView footerEndRefresh];
}

- (void)showOtherView {
    if (self.toolBarView.alpha == 0.0f) {
        [UIView animateWithDuration:1.0 animations:^{
            if (kIsFree && _bannner) {
                self.bannner.alpha = 1.0f;
            }
            self.toolBarView.alpha = 1.0f;
            self.pagePickerView.alpha = 1.0f;
        }];
    }
}

#pragma mark - Private Methods

- (void)configureView {
    [self addSubview:self.webView];
    if (kIsFree) {
        if ((arc4random() % 100) < kAdMobThreadDetailBannerProbability) {
            [self addSubview:self.bannner];
        }
    }
    [self addSubview:self.pagePickerView];
    [self addSubview:self.toolBarView];
}

#pragma mark - Event Responses

- (void)beginRefresh {
    if (self.webViewRefreshBlock) {
        self.webViewRefreshBlock();
    }
}

- (void)beginFetchMore {
    if (self.webViewFetchMoreBlock) {
        self.webViewFetchMoreBlock();
    }
}

#pragma mark - Getters

- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64 - 44)];
        _webView.dataDetectorTypes = UIDataDetectorTypeLink;
        _webView.opaque = NO;
        _webView.backgroundColor = [UIColor clearColor];
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
        _webView.scrollView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight);
        @weakify(self);
        _webView.scrollView.headerRefreshBlock = ^{
            @strongify(self);
            [self beginRefresh];
        };
    }
    return _webView;
}

- (GCThreadDetailToolBarView *)toolBarView {
    if (!_toolBarView) {
        _toolBarView = [[GCThreadDetailToolBarView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 40, ScreenWidth, 40)];
        _toolBarView.alpha = 0.0f;
        @weakify(self);
        _toolBarView.pageActionBlock = ^{
            @strongify(self);
            if ([self.toolBarView.pageButton.titleLabel.text isEqualToString:@"1 / 1"]) {
                return;
            }
            if (self.pagePickerView.isShow) {
                [self.pagePickerView dismiss];
            } else {
                [self.pagePickerView show];
            }
        };
        _toolBarView.previousPageActionBlock = ^{
            @strongify(self);
            if (self.previousPageActionBlock) {
                self.previousPageActionBlock();
            }
            [self.pagePickerView dismiss];
        };
        _toolBarView.nextPageActionBlock = ^{
            @strongify(self);
            if (self.nextPageActionBlock) {
                self.nextPageActionBlock();
            }
            [self.pagePickerView dismiss];
        };
        _toolBarView.replyActionBlock = ^{
            @strongify(self);
            if (self.replyActionBlock) {
                self.replyActionBlock();
            }
            [self.pagePickerView dismiss];
        };
    }
    return _toolBarView;
}

- (GCThreadDetailPagePickerView *)pagePickerView {
    if (!_pagePickerView) {
        _pagePickerView = [[GCThreadDetailPagePickerView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - self.toolBarView.frame.size.height, ScreenWidth, self.frame.size.height - self.toolBarView.frame.size.height)];
        _pagePickerView.alpha = 0.0f;
        @weakify(self);
        _pagePickerView.goActionBlock = ^(NSInteger page) {
            @strongify(self);
            self.goActionBlock(page);
            [self.pagePickerView dismiss];
        };
    }
    return _pagePickerView;
}

- (GCAdBannerView *)bannner {
    if (!_bannner) {
        _bannner = [[GCAdBannerView alloc] initWithRootViewController:APP.window.rootViewController countDown:15];
        _bannner.alpha = 0.0f;
        _bannner.frame = CGRectMake(0, self.toolBarView.frame.origin.y - 50, ScreenWidth, 50);
    }
    return _bannner;
}

@end
