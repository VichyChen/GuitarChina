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
        _interstitial = [self createAndLoadInterstitial];
    }
    return self;
}

- (void)presentFromRootViewController {
    if ([self.interstitial isReady]) {
        [self.interstitial presentFromRootViewController:APP.window.rootViewController];
    }
}

- (GADInterstitial *)createAndLoadInterstitial {
    GADInterstitial *interstitial = [[GADInterstitial alloc] initWithAdUnitID:kAdMobIDEnterForeground];
    interstitial.delegate = self;
    [interstitial loadRequest:[GADRequest request]];
    
    return interstitial;
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
    self.interstitial = [self createAndLoadInterstitial];
}

- (void)interstitialWillLeaveApplication:(GADInterstitial *)ad {

}

@end
