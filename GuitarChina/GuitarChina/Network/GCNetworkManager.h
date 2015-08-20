//
//  GCNetworkManager.h
//  GuitarChina
//
//  Created by 陈大捷 on 15/8/19.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GCHotThread.h"

@interface GCNetworkManager : NSObject

+ (instancetype)manager;

//获取热帖
- (AFHTTPRequestOperation *)getHotThreadSuccess:(void (^)(GCHotThread *hotThread))success
                                        failure:(void (^)(NSError *error))failure;

//获取论坛模块列表
- (AFHTTPRequestOperation *)getForumIndexSuccess:(void (^)(GCHotThread *hotThread))success
                                         failure:(void (^)(NSError *error))failure;

//根据论坛模块id获取帖子列表
- (AFHTTPRequestOperation *)getForumDisplayWithForumID:(NSString *)forumID
                                             pageIndex:(NSInteger)pageIndex
                                              pageSize:(NSInteger)pageSize
                                               Success:(void (^)(GCHotThread *hotThread))success
                                               failure:(void (^)(NSError *error))failure;

//获取帖子详情
- (AFHTTPRequestOperation *)getViewThreadWithThreadID:(NSString *)threadID
                                            pageIndex:(NSInteger)pageIndex
                                             pageSize:(NSInteger)pageSize
                                              Success:(void (^)(GCHotThread *hotThread))success
                                              failure:(void (^)(NSError *error))failure;

@end
