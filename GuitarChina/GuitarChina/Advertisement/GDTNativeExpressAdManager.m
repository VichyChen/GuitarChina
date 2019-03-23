//
//  GDTNativeExpressAdManager.m
//  SMTH
//
//  Created by 陈大捷 on 2018/11/30.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "GDTNativeExpressAdManager.h"

#define kAdCount 6

@interface GDTNativeExpressAdManager() <GDTNativeExpressAdDelegete>

@end

@implementation GDTNativeExpressAdManager

- (instancetype)initWithAppId:(NSString *)appId placementId:(NSString *)placementId adSize:(CGSize)size {
  if (self = [super init]) {
    self.nativeExpressAd = [[GDTNativeExpressAd alloc] initWithAppId:appId placementId:placementId adSize:size];
    self.nativeExpressAd.delegate = self;
    self.expressAdViews = [NSMutableArray array];
  }
  return self;
}

- (void)loadAd {
  [self.nativeExpressAd loadAd:8];
}

- (void)loadMoreAd {
  NSInteger count = 0;
  for (GDTNativeExpressAdView *view in self.expressAdViews) {
    if (view.tag == 0) {
      count++;
    }
  }
  if (count < kAdCount) {
    [self.nativeExpressAd loadAd:kAdCount];
  }
}

- (GDTNativeExpressAdView *)getAd:(NSInteger)adTag {
  for (GDTNativeExpressAdView *view in self.expressAdViews) {
    if (view.tag == adTag) {
      return view;
    }
  }
  for (GDTNativeExpressAdView *view in self.expressAdViews) {
    if (view.tag == 0) {
      view.tag = adTag;
      //判断是否需要加载广告
      [self loadMoreAd];
      return view;
    }
  }
  return nil;
}

- (void)removeAds:(NSArray *)array {
  for (int i = 0; i < array.count; i++) {
    for (NSInteger j = self.expressAdViews.count - 1; j >= 0; j--) {
      if ((self.expressAdViews[j]).tag == ((NSNumber *)array[i]).integerValue) {
        [self.expressAdViews removeObjectAtIndex:j];
        break;
      }
    }
  }
}

- (void)remove:(NSArray *)adTags {
  for (GDTNativeExpressAdManager *manager in APP.nativeExpressAdManagerArray) {
    [manager removeAds:adTags];
  }
}

#pragma mark - GDTNativeExpressAdDelegete

- (void)nativeExpressAdSuccessToLoad:(GDTNativeExpressAd *)nativeExpressAd views:(NSArray<__kindof GDTNativeExpressAdView *> *)views {
  [self.expressAdViews addObjectsFromArray:views];;
  if (views.count > 0) {
    [views enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
      GDTNativeExpressAdView *expressView = (GDTNativeExpressAdView *)obj;
      expressView.controller = APP.window.rootViewController;
      [expressView render];
    }];
  }
}

- (void)nativeExpressAdFailToLoad:(GDTNativeExpressAd *)nativeExpressAd error:(NSError *)error {
  
}

- (void)nativeExpressAdViewRenderSuccess:(GDTNativeExpressAdView *)nativeExpressAdView {
  [[NSNotificationCenter defaultCenter] postNotificationName:@"GDTNativeExpressViewRenderSuccessNotification" object:@(nativeExpressAdView.tag)];
}


@end
