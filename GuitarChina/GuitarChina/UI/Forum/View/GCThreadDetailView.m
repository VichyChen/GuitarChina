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
        [self configureFrame];
#if FREEVERSION
        [self insertSubview:self.bannner aboveSubview:self.webView];
#endif
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
#if FREEVERSION
            self.bannner.alpha = 1.0f;
#endif
            self.toolBarView.alpha = 1.0f;
        } completion:^(BOOL finished) {
            self.pagePickerView.alpha = 1.0f;
        }];
    }
}

#pragma mark - Private Methods

- (void)configureView {
    [self addSubview:self.webView];
    [self addSubview:self.pagePickerView];
    [self addSubview:self.toolBarView];
}

- (void)configureFrame {
    self.webView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigatioinBarHeight - 40);
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
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigatioinBarHeight - 40)];
        _webView.dataDetectorTypes = UIDataDetectorTypeLink;
        _webView.opaque = NO;
        _webView.backgroundColor = [UIColor clearColor];
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
        _webView.scrollView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight);
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
        _toolBarView = [[GCThreadDetailToolBarView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 40 - kSAVE_ARE_BOTTOM, kScreenWidth, 40 + kSAVE_ARE_BOTTOM)];
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
        _pagePickerView = [[GCThreadDetailPagePickerView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - self.toolBarView.frame.size.height, kScreenWidth, self.frame.size.height - self.toolBarView.frame.size.height)];
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
        _bannner = [[GCAdBannerView alloc] initWithRootViewController:APP.window.rootViewController];
        _bannner.alpha = 0.0f;
        @weakify(self);
        _bannner.loadRequestCompleteBlock = ^{
            @strongify(self);
            self.bannner.frame = CGRectMake(0, self.toolBarView.frame.origin.y, kScreenWidth, 50);
            [UIView animateWithDuration:0.5 animations:^{
                self.bannner.frame = CGRectMake(0, self.toolBarView.frame.origin.y - 50, kScreenWidth, 50);
                self.webView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigatioinBarHeight - 40 - 50 - kSAVE_ARE_BOTTOM);
            }];
        };
        _bannner.beginRemoveFromSuperviewBlock = ^{
            @strongify(self);
            [UIView animateWithDuration:0.5 animations:^{
                self.bannner.frame = CGRectMake(0, self.toolBarView.frame.origin.y, kScreenWidth, 50);
                self.webView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigatioinBarHeight - 40);
            }];
        };
    }
    return _bannner;
}

@end
