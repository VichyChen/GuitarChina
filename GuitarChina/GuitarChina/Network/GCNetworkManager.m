//
//  GCNetworkManager.m
//  GuitarChina
//
//  Created by 陈大捷 on 15/8/19.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCNetworkManager.h"
#import "TFHpple.h"

typedef NS_ENUM(NSInteger, GCRequestType) {
    GCRequestJsonGet    = 1,
    GCRequestHTTPPOST   = 2,
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
    else if (type == GCRequestHTTPPOST) {
        manager = [[AFHTTPRequestOperationManager manager] POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            responseHandleBlock(operation, responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failure(operation, error);
        }];
    }
    
    return manager;
}

- (AFHTTPSessionManager *)requestHTMLCommonMethodWithURL:(NSString *)url
                                              parameters:(NSDictionary *)parameters
                                                 success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                                 failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure  {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    void (^responseHandleBlock)(NSURLSessionDataTask *task, id responseObject) = ^(NSURLSessionDataTask *task, id responseObject) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        success(task, responseObject);
    };
    
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager.requestSerializer setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.71 Safari/537.36" forHTTPHeaderField:@"User-Agent"];
    
    [manager GET:url parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        responseHandleBlock(task, responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(task, error);
    }];
    
    return manager;
}

#pragma mark - Public Methods

- (void)getHotThreadSuccess:(void (^)(GCHotThreadArray *array))success
                    failure:(void (^)(NSError *error))failure {
    [self requestCommonMethod:GCRequestJsonGet url:GCNETWORKAPI_GET_HOTTHREAD parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", operation.responseString);
        
        GCHotThreadArray *array = [[GCHotThreadArray alloc] initWithDictionary:[responseObject objectForKey:@"Variables"]];
        success(array);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

- (void)getForumIndexSuccess:(void (^)(GCForumIndexArray *array))success
                     failure:(void (^)(NSError *error))failure {
    [self requestCommonMethod:GCRequestJsonGet url:GCNETWORKAPI_GET_FORUMINDEX parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", operation.responseString);
        GCForumIndexArray *array = [[GCForumIndexArray alloc] initWithDictionary:[responseObject objectForKey:@"Variables"]];
        success(array);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

- (void)getForumDisplayWithForumID:(NSString *)forumID
                         pageIndex:(NSInteger)pageIndex
                          pageSize:(NSInteger)pageSize
                           Success:(void (^)(GCForumDisplayArray *array))success
                           failure:(void (^)(NSError *error))failure {
    [self requestCommonMethod:GCRequestJsonGet url:GCNETWORKAPI_GET_FORUMDISPLAY(forumID, pageIndex, pageSize) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        GCForumDisplayArray *array = [[GCForumDisplayArray alloc] initWithDictionary:[responseObject objectForKey:@"Variables"]];        success(array);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

- (void)getViewThreadWithThreadID:(NSString *)threadID
                        pageIndex:(NSInteger)pageIndex
                         pageSize:(NSInteger)pageSize
                          Success:(void (^)(GCThreadDetailModel *model))success
                          failure:(void (^)(NSError *error))failure {
    [self requestCommonMethod:GCRequestJsonGet url:GCNETWORKAPI_GET_VIEWTHREAD(threadID, pageIndex, pageSize) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", operation.responseString);
        
        GCThreadDetailModel *model = [[GCThreadDetailModel alloc] initWithDictionary:[responseObject objectForKey:@"Variables"]];        success(model);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

- (void)postLoginWithUsername:(NSString *)username
                     password:(NSString *)password
                      Success:(void (^)(GCLoginModel *model))success
                      failure:(void (^)(NSError *error))failure {
    [self requestCommonMethod:GCRequestJsonGet url:GCNETWORKAPI_GET_LGOINSECURE parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *parameters = @{ @"username" : username, @"password" : password };
        [self requestCommonMethod:GCRequestHTTPPOST url:GCNETWORKAPI_POST_LOGIN parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            GCLoginModel *model = [[GCLoginModel alloc] initWithDictionary:responseObject];
            NSLog(@"%@", operation.responseString);

            success(model);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failure(error);
        }];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

- (void)getMyFavThreadSuccess:(void (^)(GCMyFavThreadArray *array))success
                      failure:(void (^)(NSError *error))failure {
    [self requestCommonMethod:GCRequestJsonGet url:GCNETWORKAPI_GET_MYFAVTHREAD parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        GCMyFavThreadArray *array = [[GCMyFavThreadArray alloc] initWithDictionary:[responseObject objectForKey:@"Variables"]];
        NSLog(@"%@", operation.responseString);

        success(array);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

- (void)getMyThreadSuccess:(void (^)(GCMyThreadArray *array))success
                   failure:(void (^)(NSError *error))failure {
    [self requestCommonMethod:GCRequestJsonGet url:GCNETWORKAPI_GET_MYTHREAD parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        GCMyThreadArray *array = [[GCMyThreadArray alloc] initWithDictionary:[responseObject objectForKey:@"Variables"]];
        success(array);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

- (void)postReplyWithTid:(NSString *)tid
                 message:(NSString *)message
                formhash:(NSString *)formhash
                 Success:(void (^)(GCSendReplyModel *model))success
                 failure:(void (^)(NSError *error))failure {
    [self requestCommonMethod:GCRequestJsonGet url:GCNETWORKAPI_GET_POSTSECURE parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
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

- (void)postNewThreadWithFid:(NSString *)fid
                     subject:(NSString *)subject
                     message:(NSString *)message
                        type:(NSString *)type
                    formhash:(NSString *)formhash
                     Success:(void (^)(GCNewThreadModel *model))success
                     failure:(void (^)(NSError *error))failure {
    [self requestCommonMethod:GCRequestJsonGet url:GCNETWORKAPI_GET_POSTSECURE parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
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

- (void)postReportWithTid:(NSString *)tid
                     text:(NSString *)text
                  Success:(void (^)(void))success
                  failure:(void (^)(NSError *error))failure {
    NSDictionary *parameters = @{ @"text" : text};
    [self requestCommonMethod:GCRequestHTTPPOST url:GC_NETWORKAPI_REPORT(tid) parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", operation.responseString);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

//先调用getViewThreadWithThreadID，再调用此方法，结果都是返回failure，根据operation.responseString判断结果吧
- (void)getCollectionWithTid:(NSString *)tid
                    formhash:(NSString *)formhash
                     Success:(void (^)(void))success
                     failure:(void (^)(NSError *error))failure {
    [self requestCommonMethod:GCRequestJsonGet url:GC_NETWORKAPI_GET_COLLECTION(tid, formhash) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",operation.responseString);
        success();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",operation.responseString);
        failure(error);
    }];
    
    //    return [self requestHTMLCommonMethodWithURL:GC_NETWORKAPI_GET_COLLECTION(tid, formhash) parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
    //        NSLog(@"HTML: %@", [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding]);
    //        success();
    //    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    //        failure(error);
    //    }];
}

- (void)getProfileSuccess:(void (^)(GCHotThreadArray *array))success
                  failure:(void (^)(NSError *error))failure {
    [self requestHTMLCommonMethodWithURL:@"http://bbs.guitarchina.com/home.php?mod=space&uid=1627015&do=profile" parameters:nil
                                 success:^(NSURLSessionDataTask *task, id responseObject) {
                                     NSLog(@"HTML: %@", [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding]);
                                     
                                     TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:responseObject];
                                     NSArray *elements  = [xpathParser searchWithXPathQuery:@"//*[@id='pbbs']/li"];                                            NSLog(@"%ld", elements.count);
                                     TFHppleElement *element = [elements objectAtIndex:0];
                                     NSString *elementContent = [element content];
                                     NSLog(@"result = %@",elementContent);
                                     
                                 } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                     
                                 }];
}


@end
