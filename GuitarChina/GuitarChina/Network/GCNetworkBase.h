//
//  GCNetworkBase.h
//  GuitarChina
//
//  Created by 陈大捷 on 16/5/14.
//  Copyright © 2016年 陈大捷. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCNetworkBase : NSObject

+ (instancetype)sharedInstance;

//get
- (AFHTTPRequestOperationManager *)get:(NSString *)url
                            parameters:(NSDictionary *)parameters
                               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//post
- (AFHTTPRequestOperationManager *)post:(NSString *)url
                             parameters:(NSDictionary *)parameters
                                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//get web
- (AFHTTPSessionManager *)getWeb:(NSString *)url
                      parameters:(NSDictionary *)parameters
                         success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                         failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

//get wap
- (AFHTTPSessionManager *)getWap:(NSString *)url
                      parameters:(NSDictionary *)parameters
                         success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                         failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

//post web
- (AFHTTPRequestOperationManager *)postWeb:(NSString *)url
                                parameters:(NSDictionary *)parameters
                                   success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//post wap
- (AFHTTPRequestOperationManager *)postWap:(NSString *)url
                                parameters:(NSDictionary *)parameters
                                   success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
