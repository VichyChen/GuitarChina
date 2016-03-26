//
//  GCNetworkManager.h
//  GuitarChina
//
//  Created by 陈大捷 on 15/8/19.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCNetworkAPI.h"

#import "GCHotThreadModel.h"
#import "GCForumIndexModel.h"
#import "GCForumDisplayModel.h"
#import "GCThreadDetailModel.h"
#import "GCLoginModel.h"
#import "GCMyFavThreadModel.h"
#import "GCMyThreadModel.h"
#import "GCSendReplyModel.h"
#import "GCNewThreadModel.h"
#import "GCGuideThreadModel.h"

@interface GCNetworkManager : NSObject

+ (instancetype)manager;

//获取热帖
- (void)getHotThreadSuccess:(void (^)(GCHotThreadArray *array))success
                    failure:(void (^)(NSError *error))failure;

//获取论坛模块列表
- (void)getForumIndexSuccess:(void (^)(GCForumIndexArray *array))success
                     failure:(void (^)(NSError *error))failure;

//根据论坛模块id获取帖子列表
- (void)getForumDisplayWithForumID:(NSString *)forumID
                         pageIndex:(NSInteger)pageIndex
                          pageSize:(NSInteger)pageSize
                           Success:(void (^)(GCForumDisplayArray *array))success
                           failure:(void (^)(NSError *error))failure;

//获取帖子详情
- (void)getViewThreadWithThreadID:(NSString *)threadID
                        pageIndex:(NSInteger)pageIndex
                         pageSize:(NSInteger)pageSize
                          Success:(void (^)(GCThreadDetailModel *model))success
                          failure:(void (^)(NSError *error))failure;

//登陆
- (void)postLoginWithUsername:(NSString *)username
                     password:(NSString *)password
                      Success:(void (^)(GCLoginModel *model))success
                      failure:(void (^)(NSError *error))failure;

//我的收藏
- (void)getMyFavThreadSuccess:(void (^)(GCMyFavThreadArray *array))success
                      failure:(void (^)(NSError *error))failure;

//我的主题
- (void)getMyThreadSuccess:(void (^)(GCMyThreadArray *array))success
                   failure:(void (^)(NSError *error))failure;

//回复帖子
- (void)postReplyWithTid:(NSString *)tid
                 message:(NSString *)message
                formhash:(NSString *)formhash
                 Success:(void (^)(GCSendReplyModel *model))success
                 failure:(void (^)(NSError *error))failure;

//发布主题
- (void)postNewThreadWithFid:(NSString *)fid
                     subject:(NSString *)subject
                     message:(NSString *)message
                        type:(NSString *)type
                    formhash:(NSString *)formhash
                     Success:(void (^)(GCNewThreadModel *model))success
                     failure:(void (^)(NSError *error))failure;

//举报
- (void)postReportWithTid:(NSString *)tid
                     text:(NSString *)text
                  Success:(void (^)(void))success
                  failure:(void (^)(NSError *error))failure;

//收藏帖子
- (void)getCollectionWithTid:(NSString *)tid
                    formhash:(NSString *)formhash
                     Success:(void (^)(NSString *string))success
                     failure:(void (^)(NSError *error))failure;


- (void)getProfileSuccess:(void (^)(GCHotThreadArray *array))success
                  failure:(void (^)(NSError *error))failure;

//获取web登录信息
- (void)getLoginWebSuccess:(void (^)(NSString *seccode, NSString *formhash, NSString *postURL, NSArray *questionArray))success
                   failure:(void (^)(NSError *error))failure;

//获取验证码
- (void)getSeccodeVerifyImage:(NSString *)idhash
                      success:(void (^)(NSString *image))success
                      failure:(void (^)(NSError *error))failure;

//下载验证码图片
- (void)downloadSeccodeVerifyImageWithURL:(NSString *)url
                                  success:(void (^)(UIImage *image))success
                                  failure:(void (^)(NSError *error))failure;

//模拟web网页登录
- (void)postLoginWithUsername:(NSString *)username
                     password:(NSString *)password
               fastloginfield:(NSString *)fastloginfield
                seccodeverify:(NSString *)seccodeverify
                   questionid:(NSString *)questionid
                       answer:(NSString *)answer
                  seccodehash:(NSString *)seccodehash
                     formhash:(NSString *)formhash
                      postURL:(NSString *)postURL
                      success:(void (^)(NSString *html))success
                      failure:(void (^)(NSError *error))failure;

- (void)getGuideHotSuccess:(void (^)(GCGuideThreadArray *array))success
                   failure:(void (^)(NSError *error))failure
                 pageIndex:(NSInteger)pageIndex;

@end
