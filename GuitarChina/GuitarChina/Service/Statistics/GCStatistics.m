//
//  GCStatistics.m
//  GuitarChina
//
//  Created by mac on 17/1/6.
//  Copyright © 2017年 陈大捷. All rights reserved.
//

#import "GCStatistics.h"
#import <UMengAnalytics/UMMobClick/MobClick.h>

@implementation GCStatistics

+ (void)event:(GCStatisticsEvent)event extra:(NSDictionary *)extra {
    NSString *name = [NSUD stringForKey:kGCLoginName] ? [NSUD stringForKey:kGCLoginName] : @"游客";
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    [attributes addEntriesFromDictionary:@{@"name" : name}];
    if (extra) {
        [attributes addEntriesFromDictionary:extra];
    }
    NSArray *array = @[@"GDTBannerShow", @"GDTBannerClick", @"AdMobBannerShow", @"AdMobBannerClick", @"AdMobCenterBannerShow", @"AdMobCenterBannerClick", @"AdMobInterstitialShow", @"AdMobInterstitialClick", @"Discovery", @"ThreadDetail", @"NewsDetail", @"Login", @"ForumIndex", @"ForumDisplay", @"PostThread", @"ReplyThread", @"Search", @"DiscoveryGoToAppStore", @"DiscoveryClose", @"GDTSplashShowSuccess", @"GDTSplashShowFailure", @"GDTSplashClick"];

    [MobClick event:array[event] attributes:attributes];
}

@end
