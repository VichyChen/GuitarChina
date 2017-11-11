//
//  GCStatistics.h
//  GuitarChina
//
//  Created by mac on 17/1/6.
//  Copyright © 2017年 陈大捷. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, GCStatisticsEvent) {
    GCStatisticsEventGDTBannerShow,
    GCStatisticsEventGDTBannerClick,
    GCStatisticsEventAdMobBannerShow,
    GCStatisticsEventAdMobBannerClick,
    GCStatisticsEventAdMobCenterBannerShow,
    GCStatisticsEventAdMobCenterBannerClick,
    GCStatisticsEventAdMobInterstitialShow,
    GCStatisticsEventAdMobInterstitialClick,
    GCStatisticsEventDiscovery,
    GCStatisticsEventThreadDetail,
    GCStatisticsEventNewsDetail,
    GCStatisticsEventLogin,
    GCStatisticsEventForumIndex,
    GCStatisticsEventForumDisplay,
    GCStatisticsEventPostThread,
    GCStatisticsEventReplyThread,
    GCStatisticsEventSearch,
    GCStatisticsEventDiscoveryGoToAppStore,
    GCStatisticsEventDiscoveryClose,
    GCStatisticsEventGDTSplashShowSuccess,
    GCStatisticsEventGDTSplashShowFailure,
    GCStatisticsEventGDTSplashClick,
};

@interface GCStatistics : NSObject

+ (void)event:(GCStatisticsEvent)event extra:(NSDictionary *)extra;

@end
