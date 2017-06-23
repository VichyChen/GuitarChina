//
//  GCAdBannerView.m
//  GuitarChina
//
//  Created by mac on 16/12/28.
//  Copyright © 2016年 陈大捷. All rights reserved.
//

#import "GCAdBannerView.h"
#import <GoogleMobileAds/GADBannerView.h>

@interface GCAdBannerView() <GADBannerViewDelegate>

@property (nonatomic, strong) GADBannerView *bannerView;

@end

@implementation GCAdBannerView

- (instancetype)initWithRootViewController:(UIViewController *)viewController {
    if (self = [super init]) {
        self.clipsToBounds = YES;
        [self configureView:viewController];
    }
    return self;
}

- (instancetype)initWithRootViewController:(UIViewController *)viewController countDown:(CGFloat)countDown {
    if (self = [super init]) {
        self.clipsToBounds = YES;
        [self configureView:viewController];
        [self setupCountDown:countDown];
    }
    return self;
}

- (void)dealloc {
    NSLog(@"GCAdBannerView dealloc");
}

- (void)configureView:(UIViewController *)viewController {
    self.bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
    self.bannerView.delegate = self;
    self.bannerView.adUnitID = kAdMobIDDetailBottom;
    self.bannerView.rootViewController = viewController;
    [self.bannerView loadRequest:[GADRequest request]];
    [self addSubview:self.bannerView];
}

- (void)setupCountDown:(CGFloat)countDown {
    CGFloat delayInSeconds = countDown;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    @weakify(self);
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        @strongify(self);
        if (self.beginRemoveFromSuperviewBlock) {
            self.beginRemoveFromSuperviewBlock();
        }
        [UIView animateWithDuration:0.5 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
            if (self.endRemoveFromSuperviewBlock) {
                self.endRemoveFromSuperviewBlock();
            }
        }];
    });
}

#pragma mark - GADBannerViewDelegate

- (void)adViewDidReceiveAd:(GADBannerView *)bannerView {
    [GCStatistics event:GCStatisticsEventAdMobBannerShow extra:nil];
    if (self.loadRequestCompleteBlock) {
        self.loadRequestCompleteBlock();
    }
}

- (void)adViewWillPresentScreen:(GADBannerView *)bannerView {
    
}

- (void)adViewWillDismissScreen:(GADBannerView *)bannerView {
    
}

- (void)adViewDidDismissScreen:(GADBannerView *)bannerView {
    
}

- (void)adViewWillLeaveApplication:(GADBannerView *)bannerView {
    [GCStatistics event:GCStatisticsEventAdMobBannerClick extra:nil];
}

@end
