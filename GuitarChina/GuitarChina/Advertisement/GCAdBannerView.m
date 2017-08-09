//
//  GCAdBannerView.m
//  GuitarChina
//
//  Created by mac on 16/12/28.
//  Copyright © 2016年 陈大捷. All rights reserved.
//

#import "GCAdBannerView.h"
#import <GoogleMobileAds/GADBannerView.h>
#import "GDTMobBannerView.h"
#import <InMobiSDK/InMobiSDK.h>

@interface GCAdBannerView() <GADBannerViewDelegate, GDTMobBannerViewDelegate, IMBannerDelegate>

@property (nonatomic, strong) GADBannerView *bannerView;

@property (nonatomic, strong) GDTMobBannerView *gdtBannerView;
@property (nonatomic, strong) IMBanner *imBannerView;

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
    /*
    self.bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
    self.bannerView.delegate = self;
    self.bannerView.adUnitID = kAdMobIDDetailBottom;
    self.bannerView.rootViewController = viewController;
    [self.bannerView loadRequest:[GADRequest request]];
    [self addSubview:self.bannerView];
     */
    self.gdtBannerView = [[GDTMobBannerView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, GDTMOB_AD_SUGGEST_SIZE_320x50.height) appkey:kGDTAppKey placementId:kGDTBanner];
    self.gdtBannerView.delegate = self;
    self.gdtBannerView.interval = 30;
    self.gdtBannerView.currentViewController = viewController;
    self.gdtBannerView.showCloseBtn = NO;
    [self addSubview:self.gdtBannerView];
    [self.gdtBannerView loadAdAndShow];
    
//    self.imBannerView = [[IMBanner alloc] init];
//    self.imBannerView.frame = CGRectMake(0, 0, ([UIScreen mainScreen].bounds.size.width), 50);
//    self.imBannerView.placementId = 1501225532268;
//    self.imBannerView.delegate = self;
//    [self.imBannerView load];
//    [self addSubview:self.imBannerView];
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

#pragma mark - GDTMobBannerViewDelegate

- (void)bannerViewDidReceived {
    if (self.loadRequestCompleteBlock) {
        self.loadRequestCompleteBlock();
    }
}

- (void)bannerViewFailToReceived:(NSError *)error {

}

- (void)bannerViewClicked {

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

#pragma mark - IMBannerDelegate

-(void)bannerDidFinishLoading:(IMBanner*)banner {
    
}

-(void)banner:(IMBanner*)banner didFailToLoadWithError:(IMRequestStatus*)error {
    
}

-(void)banner:(IMBanner*)banner didInteractWithParams:(NSDictionary*)params {
    
}

-(void)userWillLeaveApplicationFromBanner:(IMBanner*)banner {
    
}

-(void)bannerWillPresentScreen:(IMBanner*)banner {
    
}

-(void)bannerDidPresentScreen:(IMBanner*)banner {
    
}

-(void)bannerWillDismissScreen:(IMBanner*)banner {
    
}

-(void)bannerDidDismissScreen:(IMBanner*)banner {
    
}

-(void)banner:(IMBanner*)banner rewardActionCompletedWithRewards:(NSDictionary*)rewards {
    
}

@end
