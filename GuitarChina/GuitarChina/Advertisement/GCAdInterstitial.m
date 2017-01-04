//
//  GCAdInterstitial.m
//  GuitarChina
//
//  Created by mac on 16/12/27.
//  Copyright © 2016年 陈大捷. All rights reserved.
//

#import "GCAdInterstitial.h"
#import <GoogleMobileAds/GADInterstitial.h>
#import <GoogleMobileAds/GADInterstitialDelegate.h>

@interface GCAdInterstitial() <GADInterstitialDelegate>

@property (nonatomic, strong) GADInterstitial *interstitial;

@end

@implementation GCAdInterstitial

- (instancetype)init {
    if (self = [super init]) {
        [self createAndLoadInterstitial];
    }
    return self;
}

- (void)presentFromViewController:(UIViewController *)viewController {
    if ([self.interstitial isReady]) {
        [APP.adCenterBannerView close];
        [self.interstitial presentFromRootViewController:viewController];
    }
}

- (void)presentFromRootViewController {
    if ([self.interstitial isReady]) {
        [APP.adCenterBannerView close];
        [self.interstitial presentFromRootViewController:APP.window.rootViewController];
    }
}

- (void)createAndLoadInterstitial {
    self.interstitial = [[GADInterstitial alloc] initWithAdUnitID:kAdMobIDEnterForeground];
    self.interstitial.delegate = self;
    [self.interstitial loadRequest:[GADRequest request]];
}

#pragma mark - GADInterstitialDelegate

#pragma mark Ad Request Lifecycle Notifications

- (void)interstitialDidReceiveAd:(GADInterstitial *)ad {
}

- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error {
    
}

#pragma mark Display-Time Lifecycle Notifications

- (void)interstitialWillPresentScreen:(GADInterstitial *)ad {
    
}

- (void)interstitialWillDismissScreen:(GADInterstitial *)ad {
    
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)ad {
    [self createAndLoadInterstitial];
    if (self.dismissScreenBlock) {
        self.dismissScreenBlock();
        self.dismissScreenBlock = nil;
    }
}

- (void)interstitialWillLeaveApplication:(GADInterstitial *)ad {

}

@end
