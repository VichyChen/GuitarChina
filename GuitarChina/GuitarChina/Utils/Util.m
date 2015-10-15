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

+ (NSString *)stringByLocalHtmlString:(NSString *)html {
    NSString *path = [[NSBundle mainBundle] pathForResource:html ofType:@"html"];
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

@end
