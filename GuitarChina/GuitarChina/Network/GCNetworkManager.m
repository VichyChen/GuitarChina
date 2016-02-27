//
//  GCNetworkManager.m
//  GuitarChina
//
//  Created by 陈大捷 on 15/8/19.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCNetworkManager.h"
#import "TFHpple.h"
#import "JsonTool.h"

typedef NS_ENUM(NSInteger, GCRequestType) {
    GCRequestJsonGet    = 1,
    GCRequestPost       = 2,
    GCRequestHttpPost   = 3,
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

- (AFHTTPRequestOperationManager *)requestCommonMethod:(GCRequestType)type
                                            url:(NSString *)url
                                     parameters:(NSDictionary *)parameters
                                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure  {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    void (^responseSuccessBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSLog(@"Success!!!!!!~~~~~~");
        NSLog(@"%@", operation.responseString);
        success(operation, responseObject);
    };
    void (^responseFailureBlock)(AFHTTPRequestOperation *operation, NSError *error) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSLog(@"Failure!!!!!!~~~~~~");
        NSLog(@"%@", operation.responseString);
        failure(operation, error);
    };
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //    [manager.requestSerializer setValue:@"Mozilla/5.0 (iPhone; CPU iPhone OS 5_0 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9A334 Safari/7534.48.3" forHTTPHeaderField:@"User-Agent"];
    //    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    //    [manager.requestSerializer setValue:@"Mozilla/5.0 (iPhone; CPU iPhone OS 5_0 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9A334 Safari/7534.48.3" forHTTPHeaderField:@"User-Agent"];
    
    if (type == GCRequestJsonGet) {
        [[AFHTTPRequestOperationManager manager] GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            responseSuccessBlock(operation, responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failure(operation, error);
            responseFailureBlock(operation, error);
        }];
    }
    else if (type == GCRequestPost) {
        [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            responseSuccessBlock(operation, responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            responseFailureBlock(operation, error);
        }];
    }
    else if (type == GCRequestHttpPost) {
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            responseSuccessBlock(operation, responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            responseFailureBlock(operation, error);
        }];
    }
    
    return manager;
}

- (AFHTTPSessionManager *)requestWebWithURL:(NSString *)url
                                 parameters:(NSDictionary *)parameters
                                    success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                    failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure  {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    void (^responseSuccessBlock)(NSURLSessionDataTask *task, id responseObject) = ^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"Success!!!!!!~~~~~~");
        NSLog(@"HTML: %@", [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding]);
        success(task, responseObject);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    };
    void (^responseFailureBlock)(NSURLSessionDataTask *task, NSError *error) = ^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Failure!!!!!!~~~~~~");
        failure(task, error);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    };
    
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    //    [manager.requestSerializer setValue:@"Mozilla/5.0 (iPhone; CPU iPhone OS 5_0 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9A334 Safari/7534.48.3" forHTTPHeaderField:@"User-Agent"];
    [manager.requestSerializer setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36" forHTTPHeaderField:@"User-Agent"];
    
    [manager GET:url parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        responseSuccessBlock(task, responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        responseFailureBlock(task, error);
    }];
    
    return manager;
}

#pragma mark - Public Methods

- (void)getHotThreadSuccess:(void (^)(GCHotThreadArray *array))success
                    failure:(void (^)(NSError *error))failure {
    [self requestCommonMethod:GCRequestJsonGet url:GCNETWORKAPI_GET_HOTTHREAD parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        GCHotThreadArray *array = [[GCHotThreadArray alloc] initWithDictionary:[responseObject objectForKey:@"Variables"]];
        success(array);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

- (void)getForumIndexSuccess:(void (^)(GCForumIndexArray *array))success
                     failure:(void (^)(NSError *error))failure {
    [self requestCommonMethod:GCRequestJsonGet url:GCNETWORKAPI_GET_FORUMINDEX parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
        GCForumDisplayArray *array = [[GCForumDisplayArray alloc] initWithDictionary:[responseObject objectForKey:@"Variables"]];
        success(array);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

- (void)getViewThreadWithThreadID:(NSString *)threadID
                        pageIndex:(NSInteger)pageIndex
                         pageSize:(NSInteger)pageSize
                          Success:(void (^)(GCThreadDetailModel *model))success
                          failure:(void (^)(NSError *error))failure {
    NSLog(@"%@", threadID);
    [self requestCommonMethod:GCRequestJsonGet url:GCNETWORKAPI_GET_VIEWTHREAD(threadID, pageIndex, pageSize) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        GCThreadDetailModel *model = [[GCThreadDetailModel alloc] initWithDictionary:[responseObject objectForKey:@"Variables"]];
        success(model);
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
        [self requestCommonMethod:GCRequestHttpPost url:GCNETWORKAPI_POST_LOGIN parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            GCLoginModel *model = [[GCLoginModel alloc] initWithDictionary:responseObject];
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
        [self requestCommonMethod:GCRequestPost url:GCNETWORKAPI_POST_SENDREPLY(tid) parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary *dictionary = [JsonTool jsonToDictionary:operation.responseString];
            GCSendReplyModel *model = [[GCSendReplyModel alloc] initWithDictionary:dictionary];
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
        [self requestCommonMethod:GCRequestPost url:GCNETWORKAPI_POST_NEWTHREAD(fid) parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *dictionary = [JsonTool jsonToDictionary:operation.responseString];
            GCNewThreadModel *model = [[GCNewThreadModel alloc] initWithDictionary:dictionary];
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
    [self requestCommonMethod:GCRequestHttpPost url:GCNETWORKAPI_POST_REPORT(tid) parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

//先调用getViewThreadWithThreadID，再调用此方法，结果都是返回failure，根据operation.responseString判断结果吧
- (void)getCollectionWithTid:(NSString *)tid
                    formhash:(NSString *)formhash
                     Success:(void (^)(NSString *string))success
                     failure:(void (^)(NSError *error))failure {
    [self requestCommonMethod:GCRequestJsonGet url:GCNETWORKAPI_GET_COLLECTION(tid, formhash) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(@"");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ([operation.responseString containString:@"信息收藏成功"]) {
            success(NSLocalizedString(@"Collect Success", nil));
        } else if ([operation.responseString containString:@"请勿重复收藏"]) {
            success(NSLocalizedString(@"Collect Repeat", nil));
        } else {
            failure(error);
        }
    }];
    
    //    return [self requestWebWithURL:GC_NETWORKAPI_GET_COLLECTION(tid, formhash) parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
    //        NSLog(@"HTML: %@", [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding]);
    //        success();
    //    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    //        failure(error);
    //    }];
}

- (void)getProfileSuccess:(void (^)(GCHotThreadArray *array))success
                  failure:(void (^)(NSError *error))failure {
    [self requestWebWithURL:@"http://bbs.guitarchina.com/home.php?mod=space&uid=1627015&do=profile" parameters:nil
                    success:^(NSURLSessionDataTask *task, id responseObject) {
                        TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:responseObject];
                        NSArray *elements  = [xpathParser searchWithXPathQuery:@"//*[@id='pbbs']/li"];                                            NSLog(@"%ld", elements.count);
                        TFHppleElement *element = [elements objectAtIndex:0];
                        NSString *elementContent = [element content];
                        NSLog(@"result = %@",elementContent);
                        
                    } failure:^(NSURLSessionDataTask *task, NSError *error) {
                        
                    }];
}

- (void)getLoginWebSuccess:(void (^)(NSString *seccode, NSString *formhash, NSString *postURL, NSArray *questionArray))success
                   failure:(void (^)(NSError *error))failure {
    
    [self requestWebWithURL:GCNETWORKAPI_URL_LOGIN
                 parameters:nil
                    success:^(NSURLSessionDataTask *task, id responseObject) {
                        
                        TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:responseObject];
                        
                        //seccode
                        TFHppleElement *seccodeElement = [[xpathParser searchWithXPathQuery:@"//span"] objectAtIndex:4];
                        NSString *seccode = [[[seccodeElement.attributes objectForKey:@"id"] split:@"_"] objectAtIndex:1];
                        NSLog(@"seccode = %@", seccode);
                        
                        //formhash
                        TFHppleElement *formhashElement = [[xpathParser searchWithXPathQuery:@"//input[@name='formhash']"] objectAtIndex:0];
                        NSString *formhash = [formhashElement objectForKey:@"value"];
                        NSLog(@"formhash = %@", formhash);
                        
                        //postURL
                        TFHppleElement *formElement = [[xpathParser searchWithXPathQuery:@"//form[@name='login']"] objectAtIndex:0];
                        NSString *postURL = [NSString stringWithFormat:@"%@%@", GCHOST,[formElement objectForKey:@"action"]];
                        NSLog(@"postURL = %@", postURL);
                        
                        TFHppleElement *questionElement = [[xpathParser searchWithXPathQuery:@"//select[@name='questionid']"] objectAtIndex:0];
                        NSArray *optionArray = questionElement.children;
                        NSMutableArray *questionArray = [NSMutableArray array];
                        for (TFHppleElement *element in optionArray) {
                            if ([element objectForKey:@"value"]) {
                                NSLog(@"%@", element.text);
                                [questionArray addObject:element.text];
                            }
                        }
                        
                        success(seccode, formhash, postURL, questionArray);
                        
                    } failure:^(NSURLSessionDataTask *task, NSError *error) {
                        failure(error);
                    }];
}

- (void)getSeccodeVerifyImage:(NSString *)idhash
                      success:(void (^)(NSString *image))success
                      failure:(void (^)(NSError *error))failure {
    [self requestWebWithURL:GCSECCODE(idhash) parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:responseObject];
        TFHppleElement *imgElement = [[xpathParser searchWithXPathQuery:@"//img"] objectAtIndex:2];
        NSString *image = [NSString stringWithFormat:@"%@%@", GCHOST,[imgElement.attributes objectForKey:@"src"]];
        
        success(image);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
}

- (void)downloadSeccodeVerifyImageWithURL:(NSString *)url
                                  success:(void (^)(UIImage *image))success
                                  failure:(void (^)(NSError *error))failure {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request addValue:@"bbs.guitarchina.com" forHTTPHeaderField:@"Host"];
    [request addValue:GCNETWORKAPI_URL_LOGIN forHTTPHeaderField:@"Referer"];
    
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
    requestOperation.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"image/png"];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[UIImage class]]) {
            UIImage *image = responseObject;
            success(image);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
    [requestOperation start];
}

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
                      failure:(void (^)(NSError *error))failure {
    
    NSDictionary *parameters = @{@"formhash" : formhash,
                                 @"seccodehash" : seccodehash,
                                 //@"fastloginfield" : @"username",
                                 @"fastloginfield" : fastloginfield,
                                 @"username" : username,
                                 @"password" : password,
                                 @"seccodeverify" : seccodeverify,
                                 @"questionid" : questionid,
                                 @"answer" : answer,
                                 @"submit" : @"登陆",
                                 @"cookietime" : @"2592000"};
    [self requestCommonMethod:GCRequestHttpPost url:postURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", operation.responseString);
        success(operation.responseString);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

@end
