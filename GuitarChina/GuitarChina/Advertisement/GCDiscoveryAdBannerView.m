//
//  GCDiscoveryAdBannerView.m
//  GuitarChina
//
//  Created by mac on 16/12/27.
//  Copyright © 2016年 陈大捷. All rights reserved.
//

#import "GCDiscoveryAdBannerView.h"
#import <GoogleMobileAds/GADBannerView.h>

@implementation GCDiscoveryAdBannerView

- (instancetype)initWithRootViewController:(UIViewController *)viewController {
    if (self = [super init]) {
        GADBannerView *bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
        bannerView.adUnitID = kAdMobIDDiscovery;
        bannerView.rootViewController = viewController;
        [bannerView loadRequest:[GADRequest request]];
        [self addSubview:bannerView];

        [self setupCountDown];
    }
    return self;
}

- (void)setupCountDown {
    double delayInSeconds = 100.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    @weakify(self);
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        @strongify(self);
        [self removeFromSuperview];
    });
}

@end
