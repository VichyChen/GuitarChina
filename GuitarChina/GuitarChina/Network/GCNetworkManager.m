//
//  GCNetworkManager.m
//  GuitarChina
//
//  Created by 陈大捷 on 15/8/19.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCNetworkManager.h"
#import "GCNetworkAPI.h"

typedef NS_ENUM(NSInteger, GCRequestType) {
    GCRequestJsonGet    = 1,
    GCRequestHTTPPOST   = 2,
    GCRequestHTTPGET    = 3,
};

@implementation GCNetworkManager

+ (instancetype)manager {
    static GCNetworkManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[GCNetworkManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (AFHTTPRequestOperation *)requestCommonMethod:(GCRequestType)type
                                            url:(NSString *)url
                                     parameters:(NSDictionary *)parameters
                                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure  {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    void (^responseHandleBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        success(operation, responseObject);
    };
    
    AFHTTPRequestOperation *manager = nil;
    if (type == GCRequestJsonGet) {
        manager = [[AFHTTPRequestOperationManager manager] GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            responseHandleBlock(operation, responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failure(operation, error);
        }];
    }
    else if (type == GCRequestHTTPGET) {
        manager = [[AFHTTPRequestOperationManager manager] GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            responseHandleBlock(operation, responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failure(operation, error);
        }];
    }
    else if (type == GCRequestHTTPPOST) {
        
    }
    
    return manager;
}

#pragma mark - Public Methods

- (AFHTTPRequestOperation *)getHotThreadSuccess:(void (^)(GCHotThreadArray *hotThread))success
                                        failure:(void (^)(NSError *error))failure {
    return [self requestCommonMethod:GCRequestJsonGet url:GCNETWORKAPI_GET_HOTTHREAD parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", operation.responseString);
        GCHotThreadArray *model = [[GCHotThreadArray alloc] init];
        success(model);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

- (AFHTTPRequestOperation *)getForumIndexSuccess:(void (^)(GCHotThreadArray *hotThread))success
                                         failure:(void (^)(NSError *error))failure {
    return [self requestCommonMethod:GCRequestJsonGet url:GCNETWORKAPI_GET_FORUMINDEX parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", operation.responseString);
        GCHotThreadArray *model = [[GCHotThreadArray alloc] init];
        success(model);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

- (AFHTTPRequestOperation *)getForumDisplayWithForumID:(NSString *)forumID
                                             pageIndex:(NSInteger)pageIndex
                                              pageSize:(NSInteger)pageSize
                                               Success:(void (^)(GCHotThreadArray *hotThread))success
                                               failure:(void (^)(NSError *error))failure {
    return [self requestCommonMethod:GCRequestJsonGet url:GCNETWORKAPI_GET_FORUMDISPLAY(forumID, pageIndex, pageSize) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", operation.responseString);
        GCHotThreadArray *model = [[GCHotThreadArray alloc] init];
        success(model);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

- (AFHTTPRequestOperation *)getViewThreadWithThreadID:(NSString *)threadID
                                            pageIndex:(NSInteger)pageIndex
                                             pageSize:(NSInteger)pageSize
                                              Success:(void (^)(GCHotThreadArray *hotThread))success
                                              failure:(void (^)(NSError *error))failure {
    return [self requestCommonMethod:GCRequestJsonGet url:GCNETWORKAPI_GET_VIEWTHREAD(threadID, pageIndex, pageSize) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", operation.responseString);
        GCHotThreadArray *model = [[GCHotThreadArray alloc] init];
        success(model);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

@end
