//
//  Util.h
//  GuitarChina
//
//  Created by 陈大捷 on 15/9/26.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Util : NSObject

//获取当前语言
+ (NSString *)getCurrentLanguage;

//判断当前语言是不是简体中文或者繁体中文
+ (BOOL)getCurrentLanguageIsChinese;

//打开链接
+ (void)openUrlInSafari:(NSString *)url;

//获取本地html文件字符串
+ (NSString *)stringByLocalHtmlString:(NSString *)html;

//获取bundle路径字符串
+ (NSString *)bundleBasePathString;

//获取bundleURL
+ (NSURL *)bundleBasePathURL;

//时间戳转NSDate
+ (NSDate *)getNSDateWithTimeStamp:(NSString *)stamp;

//时间戳转字符串
+ (NSString *)getDateStringWithTimeStamp:(NSString *)stamp format:(NSString *)format;

//NSDate转字符串
+ (NSString *)getDateStringWithNSDate:(NSDate *)date format:(NSString *)format;

@end
