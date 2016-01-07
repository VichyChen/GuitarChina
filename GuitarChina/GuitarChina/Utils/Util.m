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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
    NSString *currentLanguage = [languages objectAtIndex:0];
    
    return currentLanguage;
}

+ (BOOL)getCurrentLanguageIsChinese {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
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

+ (void)copyStringToPasteboard:(NSString *)string {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = string;
}

+ (NSString *)stringByBundleHtmlString:(NSString *)html {
    NSString *path = [[NSBundle mainBundle] pathForResource:html ofType:@"html"];
    NSString *string = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    return string;
}

+ (NSString *)stringByBundleTxtString:(NSString *)fileName {
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"txt"];
    NSString *string = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    return string;
}


+ (NSString *)bundleBasePathString {
    NSString *path = [[NSBundle mainBundle] bundlePath];
    
    return path;
}

+ (NSURL *)bundleBasePathURL {
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *url = [NSURL fileURLWithPath:path];
    
    return url;
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
    [dateFormat setDateFormat:format];
    NSString *dateString = [dateFormat stringFromDate:date];
    
    return dateString;
}

+ (NSString *)getDateStringWithNSDate:(NSDate *)date format:(NSString *)format {
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:format];
    NSString *dateString = [dateFormat stringFromDate:date];
    
    return dateString;
}

+ (NSDate *)getDateWithDateString:(NSString *)dateString format:(NSString *)format {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:format];
    NSDate *date = [dateFormat dateFromString:dateString];
    
    return date;
}

+ (void)clearCookie {
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *_tmpArray = [NSArray arrayWithArray:[cookieJar cookies]];
    for (id obj in _tmpArray) {
        [cookieJar deleteCookie:obj];
    }
}

@end
