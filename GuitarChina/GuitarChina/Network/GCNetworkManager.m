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
        
        //        AFHTTPRequestOperationManager *a = [AFHTTPRequestOperationManager manager];
        //        [a.requestSerializer setValue:@"Guitarchina/724 CFNetwork/711.3.18 Darwin/14.0.0" forHTTPHeaderField:@"User-Agent"];
        //        manager = [a GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //            responseHandleBlock(operation, responseObject);
        //        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //            failure(operation, error);
        //        }];
        
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
        manager = [[AFHTTPRequestOperationManager manager] POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            responseHandleBlock(operation, responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failure(operation, error);
        }];
        
    }
    
    return manager;
}

#pragma mark - Public Methods

- (AFHTTPRequestOperation *)getHotThreadSuccess:(void (^)(GCHotThreadArray *array))success
                                        failure:(void (^)(NSError *error))failure {
    return [self requestCommonMethod:GCRequestJsonGet url:GCNETWORKAPI_GET_HOTTHREAD parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", operation.responseString);
        
        GCHotThreadArray *array = [[GCHotThreadArray alloc] initWithDictionary:[responseObject objectForKey:@"Variables"]];
        success(array);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

- (AFHTTPRequestOperation *)getForumIndexSuccess:(void (^)(GCForumIndexArray *array))success
                                         failure:(void (^)(NSError *error))failure {
    return [self requestCommonMethod:GCRequestJsonGet url:GCNETWORKAPI_GET_FORUMINDEX parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", operation.responseString);
        GCForumIndexArray *array = [[GCForumIndexArray alloc] initWithDictionary:[responseObject objectForKey:@"Variables"]];
        success(array);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

- (AFHTTPRequestOperation *)getForumDisplayWithForumID:(NSString *)forumID
                                             pageIndex:(NSInteger)pageIndex
                                              pageSize:(NSInteger)pageSize
                                               Success:(void (^)(GCForumDisplayArray *array))success
                                               failure:(void (^)(NSError *error))failure {
    return [self requestCommonMethod:GCRequestJsonGet url:GCNETWORKAPI_GET_FORUMDISPLAY(forumID, pageIndex, pageSize) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        GCForumDisplayArray *array = [[GCForumDisplayArray alloc] initWithDictionary:[responseObject objectForKey:@"Variables"]];        success(array);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

- (AFHTTPRequestOperation *)getViewThreadWithThreadID:(NSString *)threadID
                                            pageIndex:(NSInteger)pageIndex
                                             pageSize:(NSInteger)pageSize
                                              Success:(void (^)(GCThreadDetailModel *model))success
                                              failure:(void (^)(NSError *error))failure {
    return [self requestCommonMethod:GCRequestJsonGet url:GCNETWORKAPI_GET_VIEWTHREAD(threadID, pageIndex, pageSize) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", operation.responseString);

        GCThreadDetailModel *model = [[GCThreadDetailModel alloc] initWithDictionary:[responseObject objectForKey:@"Variables"]];        success(model);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

- (AFHTTPRequestOperation *)postLoginWithUsername:(NSString *)username
                                         password:(NSString *)password
                                          Success:(void (^)(GCLoginModel *model))success
                                          failure:(void (^)(NSError *error))failure {
    return [self requestCommonMethod:GCRequestJsonGet url:GCNETWORKAPI_GET_LGOINSECURE parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *parameters = @{ @"username" : username, @"password" : password };
        [self requestCommonMethod:GCRequestHTTPPOST url:GCNETWORKAPI_POST_LOGIN parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            GCLoginModel *model = [[GCLoginModel alloc] initWithDictionary:responseObject];
            success(model);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failure(error);
        }];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

- (AFHTTPRequestOperation *)getMyFavThreadSuccess:(void (^)(GCMyFavThreadArray *array))success
                                          failure:(void (^)(NSError *error))failure {
    return [self requestCommonMethod:GCRequestJsonGet url:GCNETWORKAPI_GET_MYFAVTHREAD parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        GCMyFavThreadArray *array = [[GCMyFavThreadArray alloc] initWithDictionary:[responseObject objectForKey:@"Variables"]];
        success(array);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

- (AFHTTPRequestOperation *)getMyThreadSuccess:(void (^)(GCMyThreadArray *array))success
                                       failure:(void (^)(NSError *error))failure {
    return [self requestCommonMethod:GCRequestJsonGet url:GCNETWORKAPI_GET_MYTHREAD parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        GCMyThreadArray *array = [[GCMyThreadArray alloc] initWithDictionary:[responseObject objectForKey:@"Variables"]];
        success(array);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

- (AFHTTPRequestOperation *)postReplyWithTid:(NSString *)tid
                                     message:(NSString *)message
                                    formhash:(NSString *)formhash
                                     Success:(void (^)(GCSendReplyModel *model))success
                                     failure:(void (^)(NSError *error))failure {
    return [self requestCommonMethod:GCRequestJsonGet url:GCNETWORKAPI_GET_POSTSECURE parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *parameters = @{ @"message" : message, @"noticetrimstr" : @"", @"mobiletype" : @"1", @"formhash" : formhash };
        [self requestCommonMethod:GCRequestHTTPPOST url:GCNETWORKAPI_POST_SENDREPLY(tid) parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            GCSendReplyModel *model = [[GCSendReplyModel alloc] initWithDictionary:responseObject];
            success(model);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failure(error);
        }];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

- (AFHTTPRequestOperation *)postNewThreadWithFid:(NSString *)fid
                                         subject:(NSString *)subject
                                         message:(NSString *)message
                                            type:(NSString *)type
                                        formhash:(NSString *)formhash
                                         Success:(void (^)(GCNewThreadModel *model))success
                                         failure:(void (^)(NSError *error))failure {
    return [self requestCommonMethod:GCRequestJsonGet url:GCNETWORKAPI_GET_POSTSECURE parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *parameters = @{ @"allownoticeauthor" : @"1", @"message" : message, @"subject" : subject, @"mobiletype" : @"1", @"formhash" : formhash, @"typeid" : type };
        [self requestCommonMethod:GCRequestHTTPPOST url:GCNETWORKAPI_POST_NEWTHREAD(fid) parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@", operation.responseString);
            GCNewThreadModel *model = [[GCNewThreadModel alloc] initWithDictionary:responseObject];
            success(model);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failure(error);
        }];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

- (AFHTTPRequestOperation *)postReportWithTid:(NSString *)tid
                                         text:(NSString *)text
                                      Success:(void (^)(void))success
                                      failure:(void (^)(NSError *error))failure {
    NSDictionary *parameters = @{ @"text" : text};
    return  [self requestCommonMethod:GCRequestHTTPPOST url:GC_NETWORKAPI_REPORT(tid) parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", operation.responseString);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

//先调用getViewThreadWithThreadID，再调用此方法，结果都是返回failure，根据operation.responseString判断结果吧
- (AFHTTPRequestOperation *)getCollectionWithTid:(NSString *)tid
                                            formhash:(NSString *)formhash
                                              Success:(void (^)(void))success
                                              failure:(void (^)(NSError *error))failure {
    return [self requestCommonMethod:GCRequestJsonGet url:GC_NETWORKAPI_GET_COLLECTION(tid, formhash) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",operation.responseString);
        success();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",operation.responseString);
        failure(error);
    }];
}

@end
