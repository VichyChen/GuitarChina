//
//  GCNetworkManager.h
//  GuitarChina
//
//  Created by 陈大捷 on 15/8/19.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCNetworkAPI.h"
#import "GCNetworkBase.h"

#import "GCForumIndexModel.h"
#import "GCForumDisplayModel.h"
#import "GCThreadDetailModel.h"
#import "GCMyFavThreadModel.h"
#import "GCMyThreadModel.h"
#import "GCSendReplyModel.h"
#import "GCNewThreadModel.h"
#import "GCGuideThreadModel.h"

@interface GCNetworkManager : NSObject

//获取论坛模块列表
+ (void)getForumIndexSuccess:(void (^)(GCForumIndexArray *array))success
                     failure:(void (^)(NSError *error))failure;

//根据论坛模块id获取帖子列表
+ (void)getForumDisplayWithForumID:(NSString *)forumID
                         pageIndex:(NSInteger)pageIndex
                          pageSize:(NSInteger)pageSize
                           success:(void (^)(GCForumDisplayArray *array))success
                           failure:(void (^)(NSError *error))failure;

//获取帖子详情
+ (void)getViewThreadWithThreadID:(NSString *)threadID
                        pageIndex:(NSInteger)pageIndex
                         pageSize:(NSInteger)pageSize
                          success:(void (^)(GCThreadDetailModel *model))success
                          failure:(void (^)(NSError *error))failure;

//我的收藏
+ (void)getMyFavThreadSuccess:(void (^)(GCMyFavThreadArray *array))success
                      failure:(void (^)(NSError *error))failure;

//我的主题
+ (void)getMyThreadSuccess:(void (^)(GCMyThreadArray *array))success
                   failure:(void (^)(NSError *error))failure;

//我的提醒
+ (void)getMyPromptSuccess:(void (^)(NSData *htmlData))success
                   failure:(void (^)(NSError *error))failure;

//回复帖子
+ (void)postReplyWithTid:(NSString *)tid
                 message:(NSString *)message
                formhash:(NSString *)formhash
                 success:(void (^)(GCSendReplyModel *model))success
                 failure:(void (^)(NSError *error))failure;

//发布主题
+ (void)postNewThreadWithFid:(NSString *)fid
                     subject:(NSString *)subject
                     message:(NSString *)message
                        type:(NSString *)type
                    formhash:(NSString *)formhash
                     success:(void (^)(GCNewThreadModel *model))success
                     failure:(void (^)(NSError *error))failure;

//WEB上传图片
+ (void)postWebReplyImageWithFid:(NSString *)fid
                           image:(UIImage *)image
                        formhash:(NSString *)formhash
                         success:(void (^)(NSString *string))success
                         failure:(void (^)(NSError *error))failure;

//WEB回复页面获取
+ (void)getWebReplyWithFid:(NSString *)fid
                       tid:(NSString *)tid
                      page:(NSString *)page
                  repquote:(NSString *)repquote
                   success:(void (^)(NSData *htmlData))success
                   failure:(void (^)(NSError *error))failure;

//WEB回复
+ (void)postWebReplyWithTid:(NSString *)tid
                        fid:(NSString *)fid
                    message:(NSString *)message
                attachArray:(NSArray *)attachArray
                   formhash:(NSString *)formhash
               noticeauthor:(NSString *)noticeauthor
              noticetrimstr:(NSString *)noticetrimstr
            noticeauthormsg:(NSString *)noticeauthormsg
                     reppid:(NSString *)reppid
                    reppost:(NSString *)reppost
                    success:(void (^)(void))success
                    failure:(void (^)(NSError *error))failure;

//WEB发布主题页面获取
+ (void)getWebNewThreadWithFid:(NSString *)fid
                        sortid:(NSString *)sordid
                       success:(void (^)(NSData *htmlData))success
                       failure:(void (^)(NSError *error))failure;

//WEB发布主题
+ (void)postWebNewThreadWithFid:(NSString *)fid
                         typeid:(NSString *)type
                        subject:(NSString *)subject
                        message:(NSString *)message
                    attachArray:(NSArray *)attachArray
                tableDictionary:(NSDictionary *)tableDictionary
                       posttime:(NSString *)posttime
                       formhash:(NSString *)formhash
                        success:(void (^)(void))success
                        failure:(void (^)(NSError *error))failure;


//举报
+ (void)postReportWithTid:(NSString *)tid
                     text:(NSString *)text
                  success:(void (^)(void))success
                  failure:(void (^)(NSError *error))failure;

//收藏帖子
+ (void)getCollectionWithTid:(NSString *)tid
                    formhash:(NSString *)formhash
                     success:(void (^)(NSString *string))success
                     failure:(void (^)(NSError *error))failure;

//获取web登录信息
+ (void)getLoginWebSuccess:(void (^)(NSData *htmlData))success
                   failure:(void (^)(NSError *error))failure;

//获取验证码
+ (void)getSeccodeVerifyImage:(NSString *)idhash
                      success:(void (^)(NSData *htmlData))success
                      failure:(void (^)(NSError *error))failure;

//下载验证码图片
+ (void)downloadSeccodeVerifyImageWithURL:(NSString *)url
                                  success:(void (^)(UIImage *image))success
                                  failure:(void (^)(NSError *error))failure;

//模拟web网页登录
+ (void)postLoginWithUsername:(NSString *)username
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

//导读－最新热门
+ (void)getGuideHotWithPageIndex:(NSInteger)pageIndex
                         success:(void (^)(NSData *htmlData))success
                         failure:(void (^)(NSError *error))failure;

//导读－最新精华
+ (void)getGuideDigestWithPageIndex:(NSInteger)pageIndex
                            success:(void (^)(NSData *htmlData))success
                            failure:(void (^)(NSError *error))failure;

//导读－最新回复
+ (void)getGuideNewWithPageIndex:(NSInteger)pageIndex
                         success:(void (^)(NSData *htmlData))success
                         failure:(void (^)(NSError *error))failure;

//导读－最新发表
+ (void)getGuideNewThreadWithPageIndex:(NSInteger)pageIndex
                               success:(void (^)(NSData *htmlData))success
                               failure:(void (^)(NSError *error))failure;

//导读－抢沙发
+ (void)getGuideSofaWithPageIndex:(NSInteger)pageIndex
                          success:(void (^)(NSData *htmlData))success
                          failure:(void (^)(NSError *error))failure;

//个人资料
+ (void)getProfileWithUID:(NSString *)uid
                  success:(void (^)(NSData *htmlData))success
                  failure:(void (^)(NSError *error))failure;

+ (void)getSearchWithKeyWord:(NSString *)keyWord
                   pageIndex:(NSInteger)pageIndex
                     Success:(void (^)(NSData *htmlData))success
                     failure:(void (^)(NSError *error))failure;

@end
