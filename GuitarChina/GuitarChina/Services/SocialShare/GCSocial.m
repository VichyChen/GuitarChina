//
//  GCSocial.m
//  GuitarChina
//
//  Created by mac on 15/11/7.
//  Copyright © 2015年 陈大捷. All rights reserved.
//

#import "GCSocial.h"

#define IMAGEURL @"logo_big.jpg"

@implementation GCSocial

+ (void)ShareToWechatSession:(NSString *)url
                       title:(NSString *)title
                     content:(NSString *)content
                     Success:(void (^)(void))success
                     failure:(void (^)(void))failure {
    [UMSocialData defaultData].extConfig.wechatSessionData.url = url;
    [UMSocialData defaultData].extConfig.wechatSessionData.title = title;
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:content image:[UIImage imageNamed:IMAGEURL] location:nil urlResource:nil presentedController:nil completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            success();
        } else {
            failure();
        }
    }];
}

+ (void)ShareToWechatTimeline:(NSString *)url
                        title:(NSString *)title
                      Success:(void (^)(void))success
                      failure:(void (^)(void))failure {
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = url;
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = title;
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:nil image:[UIImage imageNamed:IMAGEURL] location:nil urlResource:nil presentedController:nil completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            success();
        } else {
            failure();
        }
    }];
}

+ (void)ShareToQQ:(NSString *)url
            title:(NSString *)title
          content:(NSString *)content
          Success:(void (^)(void))success
          failure:(void (^)(void))failure {
    [UMSocialData defaultData].extConfig.qqData.url = url;
    [UMSocialData defaultData].extConfig.qqData.title = title;
    [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeDefault;
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:content image:[UIImage imageNamed:IMAGEURL] location:nil urlResource:nil presentedController:nil completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            success();
        } else {
            failure();
        }
    }];
}

+ (void)ShareToQQZone:(NSString *)url
                title:(NSString *)title
              content:(NSString *)content
              Success:(void (^)(void))success
              failure:(void (^)(void))failure {
    [UMSocialData defaultData].extConfig.qzoneData.url = url;
    [UMSocialData defaultData].extConfig.qzoneData.title = title;
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:content image:[UIImage imageNamed:IMAGEURL] location:nil urlResource:nil presentedController:nil completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            success();
        } else {
            failure();
        }
    }];
}

@end
