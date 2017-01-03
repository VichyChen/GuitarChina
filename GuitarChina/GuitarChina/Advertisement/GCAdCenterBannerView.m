//
//  GCAdCenterBannerView.m
//  GuitarChina
//
//  Created by mac on 17/1/3.
//  Copyright © 2017年 陈大捷. All rights reserved.
//

#import "GCAdCenterBannerView.h"
#import <GoogleMobileAds/GADBannerView.h>

@interface GCAdCenterBannerView()

@property (nonatomic, strong) GADBannerView *bannerView;
@property (nonatomic, strong) UIButton *closeButton;

@end

@implementation GCAdCenterBannerView

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        [self configureBannerView];
    }
    return self;
}

- (void)configureBannerView {
    if (self.bannerView.superview) {
        [self.bannerView removeFromSuperview];
    }
    self.bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeMediumRectangle];
    self.bannerView.adUnitID = kAdMobIDDiscovery;
    self.bannerView.rootViewController = APP.window.rootViewController;
    [self.bannerView loadRequest:[GADRequest request]];
    [self insertSubview:self.bannerView atIndex:0];
}

- (void)show {
    if (self.superview) {
        [self removeFromSuperview];
    }
    self.frame = self.bannerView.bounds;
    self.center = APP.window.center;
    self.bannerView.frame = self.bounds;
    self.closeButton.frame = CGRectMake(self.frame.size.width - 40, 0, 40, 30);
    [APP.window addSubview:self];
}

- (void)showAfterSecond:(CGFloat)second {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, second * NSEC_PER_SEC);
    @weakify(self);
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        @strongify(self);
        [self show];
    });
}

- (void)closeAction {
    if (self.superview) {
        [self removeFromSuperview];
        [self configureBannerView];
    }
}

#pragma mark - Getters

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_closeButton setTitle:NSLocalizedString(@"Close", nil) forState:UIControlStateNormal];
        _closeButton.backgroundColor = [UIColor blackColor];
        [_closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_closeButton];
    }
    return _closeButton;
}

@end
