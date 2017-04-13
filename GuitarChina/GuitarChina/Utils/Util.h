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

//复制文本
+ (void)copyToPasteboard:(NSString *)string;

//获取本地html文件字符串
+ (NSString *)getBundleHTMLString:(NSString *)html;

//获取本地txt文件字符串
+ (NSString *)getBundleTXTString:(NSString *)fileName;

//获取bundleURL字符串
+ (NSString *)getBundlePathURLString;

//获取bundleURL
+ (NSURL *)getBundlePathURL;

#pragma mark - Date

+ (NSDate *)getDate;

//时间戳转NSDate
+ (NSDate *)getNSDateWithTimeStamp:(NSString *)stamp;

//时间戳转字符串
+ (NSString *)getDateStringWithTimeStamp:(NSString *)stamp format:(NSString *)format;

//NSDate转字符串
+ (NSString *)getDateStringWithNSDate:(NSDate *)date format:(NSString *)format;

//字符串转NSDate
+ (NSDate *)getNSDateWithDateString:(NSString *)dateString format:(NSString *)format;

//url query转字典
+ (NSDictionary *)parseURLQueryStringToDictionary:(NSURL *)url;

#pragma mark - Cookie

//清除cookie
+ (void)clearCookie;

#pragma mark - App Store

//打开AppStore评论页面
+ (void)openScorePageInAppStore:(NSString *)appleID;

+ (void)openAppInAppStore:(NSString *)appleID;

#pragma mark - Business

//用户ID转换为头像URL的一部分
+ (NSString *)getAvatorImageURL:(NSString *)url;

@end
