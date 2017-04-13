//
//  Util.m
//  GuitarChina
//
//  Created by 陈大捷 on 15/9/26.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "Util.h"

@implementation Util

+ (NSString *)getCurrentLanguage {
    NSArray *languages = [NSUD objectForKey:@"AppleLanguages"];
    NSString *currentLanguage = [languages objectAtIndex:0];
    
    return currentLanguage;
}

+ (BOOL)getCurrentLanguageIsChinese {
    NSArray *languages = [NSUD objectForKey:@"AppleLanguages"];
    NSString *currentLanguage = [languages objectAtIndex:0];
    if ([currentLanguage compare:@"zh-Hans" options:NSCaseInsensitiveSearch] == NSOrderedSame || [currentLanguage compare:@"zh-Hant" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        return YES;
    } else {
        return NO;
    }
}

+ (void)openUrlInSafari:(NSString *)url {
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:url]];
}

+ (void)copyToPasteboard:(NSString *)string {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = string;
}

+ (NSString *)getBundleHTMLString:(NSString *)html {
    NSString *path = [[NSBundle mainBundle] pathForResource:html ofType:@"html"];
    NSString *string = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    return string;
}

+ (NSString *)getBundleTXTString:(NSString *)fileName {
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"txt"];
    NSString *string = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    return string;
}


+ (NSString *)getBundlePathURLString {
    NSString *path = [[NSBundle mainBundle] bundlePath];
    
    return path;
}

+ (NSURL *)getBundlePathURL {
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *url = [NSURL fileURLWithPath:path];
    
    return url;
}

#pragma mark - Date

+ (NSDate *)getDate {
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    NSDate *localDate = [date dateByAddingTimeInterval:interval];
    return localDate;
}

+ (NSDate *)getNSDateWithTimeStamp:(NSString *)stamp {
    NSTimeInterval time = [stamp doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    
    return date;
}

+ (NSString *)getDateStringWithTimeStamp:(NSString *)stamp format:(NSString *)format {
    NSTimeInterval time = [stamp intValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormat setDateFormat:format];
    NSString *dateString = [dateFormat stringFromDate:date];
    
    return dateString;
}

+ (NSString *)getDateStringWithNSDate:(NSDate *)date format:(NSString *)format {
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormat setDateFormat:format];
    NSString *dateString = [dateFormat stringFromDate:date];
    
    return dateString;
}

+ (NSDate *)getNSDateWithDateString:(NSString *)dateString format:(NSString *)format {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormat setDateFormat:format];
    NSDate *date = [dateFormat dateFromString:dateString];
    
    return date;
}

+ (NSDictionary *)parseURLQueryStringToDictionary:(NSURL *)url {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    NSArray *array = [url.query componentsSeparatedByString:@"&"];
    for (NSString *item in array) {
        if (item.length > 0) {
            NSArray *parameter = [item componentsSeparatedByString:@"="];
            if (parameter.count == 2) {
                [dictionary setObject:parameter[1] forKey:parameter[0]];
            }
        }
    }

    return dictionary;
}

#pragma mark - Cookie

+ (void)clearCookie {
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *_tmpArray = [NSArray arrayWithArray:[cookieJar cookies]];
    for (id obj in _tmpArray) {
        [cookieJar deleteCookie:obj];
    }
}

#pragma mark - App Store

+ (void)openScorePageInAppStore:(NSString *)appleID {
    NSString *urlString = [NSString stringWithFormat:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%@&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8", appleID];
    NSURL *url = [NSURL URLWithString:urlString];
    [[UIApplication sharedApplication] openURL:url];
}

+ (void)openAppInAppStore:(NSString *)appleID {
    NSString *urlString = [NSString stringWithFormat:@"https://itunes.apple.com/cn/app/ji-ta-zhong-guo-hua-yu-di/id%@", appleID];
    NSURL *url = [NSURL URLWithString:urlString];
    [[UIApplication sharedApplication] openURL:url];
}

#pragma mark - Business

+ (NSString *)getAvatorImageURL:(NSString *)url {
    if (url.length > 0) {
        NSMutableArray *array = [NSMutableArray array];
        [url enumerateSubstringsInRange:NSMakeRange(0, url.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
            [array addObject:substring];
        }];
        while (array.count < 9) {
            [array insertObject:@"0" atIndex:0];
        }
        [array insertObject:@"/" atIndex:3];
        [array insertObject:@"/" atIndex:6];
        [array insertObject:@"/" atIndex:9];

        return [array componentsJoinedByString:@""];
    }
    return @"";
}

@end
