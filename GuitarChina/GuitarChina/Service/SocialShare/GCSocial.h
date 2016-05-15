//
//  GCSocial.h
//  GuitarChina
//
//  Created by mac on 15/11/7.
//  Copyright © 2015年 陈大捷. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMSocial.h"

@interface GCSocial : NSObject

//判断是否安装QQ
+ (BOOL)QQInstalled;

//判断是否安装微信
+ (BOOL)WXAppInstalled;

//分享到微信聊天
+ (void)ShareToWechatSession:(NSString *)url
                       title:(NSString *)title
                     content:(NSString *)content
                     Success:(void (^)(void))success
                     failure:(void (^)(void))failure;

//分享到微信朋友圈
+ (void)ShareToWechatTimeline:(NSString *)url
                        title:(NSString *)title
                      Success:(void (^)(void))success
                      failure:(void (^)(void))failure;

//分享到QQ
+ (void)ShareToQQ:(NSString *)url
            title:(NSString *)title
          content:(NSString *)content
          Success:(void (^)(void))success
          failure:(void (^)(void))failure;

//分享到QQ空间
+ (void)ShareToQQZone:(NSString *)url
            title:(NSString *)title
          content:(NSString *)content
          Success:(void (^)(void))success
          failure:(void (^)(void))failure;

@end
