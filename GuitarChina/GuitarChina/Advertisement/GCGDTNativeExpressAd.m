//
//  GCGDTNativeExpressAd.m
//  GuitarChina
//
//  Created by mac on 2017/11/9.
//  Copyright © 2017年 陈大捷. All rights reserved.
//

#import "GCGDTNativeExpressAd.h"

@interface GCGDTNativeExpressAd() <GDTNativeExpressAdDelegete>

// 用于请求原生模板广告，注意：不要在广告打开期间释放！
@property (nonatomic, strong) GDTNativeExpressAd *nativeExpressAd;

@end

@implementation GCGDTNativeExpressAd

- (instancetype)initWithSize:(CGSize)size count:(int)count {
    if (self = [super init]) {
        self.nativeExpressAd = [[GDTNativeExpressAd alloc] initWithAppkey:kGDTAppKey placementId:kGDTNativeExpressPlacementID adSize:size];
        self.nativeExpressAd.delegate = self;
        [self.nativeExpressAd loadAd:count];
    }
    return self;
}

#pragma mark - GDTNativeExpressAdDelegete

/**
 * 拉取原生模板广告成功
 */
- (void)nativeExpressAdSuccessToLoad:(GDTNativeExpressAd *)nativeExpressAd views:(NSArray<__kindof GDTNativeExpressAdView *> *)views {
    [self.expressAdViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        GDTNativeExpressAdView *adView = (GDTNativeExpressAdView *)obj;
        [adView removeFromSuperview];
    }];
    self.expressAdViews = [NSArray arrayWithArray:views];
    
    [self.expressAdViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        GDTNativeExpressAdView *adView = (GDTNativeExpressAdView *)obj;
        adView.controller = APP.window.rootViewController;
        [adView render];
    }];
    
    if (self.loadSuccessBlock) {
        self.loadSuccessBlock(self.expressAdViews);
    }
}

/**
 * 拉取原生模板广告失败
 */
- (void)nativeExpressAdFailToLoad:(GDTNativeExpressAd *)nativeExpressAd error:(NSError *)error {
    
}

/**
 * 原生模板广告渲染成功
 */
- (void) nativeExpressAdViewRenderSuccess:(GDTNativeExpressAdView *)nativeExpressAdView {

}

/**
 * 原生模板广告渲染失败
 */
- (void) nativeExpressAdViewRenderFail:(GDTNativeExpressAdView *)nativeExpressAdView {
    
}

/**
 * 原生模板广告曝光回调
 */
- (void)nativeExpressAdViewExposure:(GDTNativeExpressAdView *)nativeExpressAdView {
    
}

/**
 * 原生模板广告点击回调
 */
- (void)nativeExpressAdViewClicked:(GDTNativeExpressAdView *)nativeExpressAdView {
    
}

@end
