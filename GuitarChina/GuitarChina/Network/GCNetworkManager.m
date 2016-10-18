//
//  GCNetworkManager.m
//  GuitarChina
//
//  Created by 陈大捷 on 15/8/19.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCNetworkManager.h"
#import "JsonTool.h"
#import "TFHpple.h"

@implementation GCNetworkManager

+ (void)getHotThreadSuccess:(void (^)(GCHotThreadArray *array))success
                    failure:(void (^)(NSError *error))failure {
    [[GCNetworkBase sharedInstance] get:GCNETWORKAPI_GET_HOTTHREAD parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        GCHotThreadArray *array = [[GCHotThreadArray alloc] initWithDictionary:[responseObject objectForKey:@"Variables"]];
        success(array);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

+ (void)getForumIndexSuccess:(void (^)(GCForumIndexArray *array))success
                     failure:(void (^)(NSError *error))failure {
    [[GCNetworkBase sharedInstance] get:GCNETWORKAPI_GET_FORUMINDEX parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        GCForumIndexArray *array = [[GCForumIndexArray alloc] initWithDictionary:[responseObject objectForKey:@"Variables"]];
        success(array);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

+ (void)getForumDisplayWithForumID:(NSString *)forumID
                         pageIndex:(NSInteger)pageIndex
                          pageSize:(NSInteger)pageSize
                           success:(void (^)(GCForumDisplayArray *array))success
                           failure:(void (^)(NSError *error))failure {
    [[GCNetworkBase sharedInstance] get:GCNETWORKAPI_GET_FORUMDISPLAY(forumID, pageIndex, pageSize) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        GCForumDisplayArray *array = [[GCForumDisplayArray alloc] initWithDictionary:[responseObject objectForKey:@"Variables"]];
        success(array);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

+ (void)getViewThreadWithThreadID:(NSString *)threadID
                        pageIndex:(NSInteger)pageIndex
                         pageSize:(NSInteger)pageSize
                          success:(void (^)(GCThreadDetailModel *model))success
                          failure:(void (^)(NSError *error))failure {
    NSLog(@"threadID=%@", threadID);
    [[GCNetworkBase sharedInstance] get:GCNETWORKAPI_GET_VIEWTHREAD(threadID, pageIndex, pageSize) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        GCThreadDetailModel *model = [[GCThreadDetailModel alloc] initWithDictionary:[responseObject objectForKey:@"Variables"]];
        success(model);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

+ (void)getMyFavThreadSuccess:(void (^)(GCMyFavThreadArray *array))success
                      failure:(void (^)(NSError *error))failure {
    [[GCNetworkBase sharedInstance] get:GCNETWORKAPI_GET_MYFAVTHREAD parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        GCMyFavThreadArray *array = [[GCMyFavThreadArray alloc] initWithDictionary:[responseObject objectForKey:@"Variables"]];
        success(array);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

+ (void)getMyThreadSuccess:(void (^)(GCMyThreadArray *array))success
                   failure:(void (^)(NSError *error))failure {
    [[GCNetworkBase sharedInstance] get:GCNETWORKAPI_GET_MYTHREAD parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        GCMyThreadArray *array = [[GCMyThreadArray alloc] initWithDictionary:[responseObject objectForKey:@"Variables"]];
        success(array);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

+ (void)postReplyWithTid:(NSString *)tid
                 message:(NSString *)message
                formhash:(NSString *)formhash
                 success:(void (^)(GCSendReplyModel *model))success
                 failure:(void (^)(NSError *error))failure {
    [[GCNetworkBase sharedInstance] get:GCNETWORKAPI_GET_POSTSECURE parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *parameters = @{ @"message" : message, @"noticetrimstr" : @"", @"mobiletype" : @"1", @"formhash" : formhash };
        [[GCNetworkBase sharedInstance] post:GCNETWORKAPI_POST_SENDREPLY(tid) parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
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

+ (void)postNewThreadWithFid:(NSString *)fid
                     subject:(NSString *)subject
                     message:(NSString *)message
                        type:(NSString *)type
                    formhash:(NSString *)formhash
                     success:(void (^)(GCNewThreadModel *model))success
                     failure:(void (^)(NSError *error))failure {
    [[GCNetworkBase sharedInstance] get:GCNETWORKAPI_GET_POSTSECURE parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *parameters = @{ @"allownoticeauthor" : @"1", @"message" : message, @"subject" : subject, @"mobiletype" : @"1", @"formhash" : formhash, @"typeid" : type };
        [[GCNetworkBase sharedInstance] post:GCNETWORKAPI_POST_NEWTHREAD(fid) parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
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

+ (void)postReportWithTid:(NSString *)tid
                     text:(NSString *)text
                  success:(void (^)(void))success
                  failure:(void (^)(NSError *error))failure {
    NSDictionary *parameters = @{ @"text" : text};
    [[GCNetworkBase sharedInstance] postWap:GCNETWORKAPI_POST_REPORT(tid) parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

//先调用getViewThreadWithThreadID，再调用此方法，结果都是返回failure，根据operation.responseString判断结果吧
+ (void)getCollectionWithTid:(NSString *)tid
                    formhash:(NSString *)formhash
                     success:(void (^)(NSString *string))success
                     failure:(void (^)(NSError *error))failure {
    [[GCNetworkBase sharedInstance] get:GCNETWORKAPI_GET_COLLECTION(tid, formhash) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
}

+ (void)getProfileSuccess:(void (^)(GCHotThreadArray *array))success
                  failure:(void (^)(NSError *error))failure {
    [[GCNetworkBase sharedInstance] getWeb:@"http://bbs.guitarchina.com/home.php?mod=space&uid=1627015&do=profile" parameters:nil
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       //                        TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:responseObject];
                                       //                        NSArray *elements  = [xpathParser searchWithXPathQuery:@"//*[@id='pbbs']/li"];                                            NSLog(@"%ld", elements.count);
                                       //                        TFHppleElement *element = [elements objectAtIndex:0];
                                       //                        NSString *elementContent = [element content];
                                       //                        NSLog(@"result = %@",elementContent);
                                   } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                   }];
}

+ (void)getLoginWebSuccess:(void (^)(NSData *htmlData))success
                   failure:(void (^)(NSError *error))failure {
    [[GCNetworkBase sharedInstance] getWeb:GCNETWORKAPI_URL_LOGIN
                                parameters:nil
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       success(responseObject);
                                   }
                                   failure:^(NSURLSessionDataTask *task, NSError *error) {
                                       failure(error);
                                   }];
}

+ (void)getSeccodeVerifyImage:(NSString *)idhash
                      success:(void (^)(NSData *htmlData))success
                      failure:(void (^)(NSError *error))failure {
    [[GCNetworkBase sharedInstance] getWeb:GCSECCODE(idhash) parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
}

+ (void)downloadSeccodeVerifyImageWithURL:(NSString *)url
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
                      failure:(void (^)(NSError *error))failure {
    NSDictionary *parameters = @{@"formhash" : formhash,
                                 @"seccodehash" : seccodehash,
                                 @"fastloginfield" : fastloginfield,
                                 @"username" : username,
                                 @"password" : password,
                                 @"seccodeverify" : seccodeverify,
                                 @"questionid" : questionid,
                                 @"answer" : answer,
                                 @"submit" : @"登陆",
                                 @"cookietime" : @"2592000"};
    [[GCNetworkBase sharedInstance] postWap:postURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation.responseString);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

+ (void)getGuideHotSuccessWithPageIndex:(NSInteger)pageIndex
                                success:(void (^)(NSData *htmlData))success
                                failure:(void (^)(NSError *error))failure {
    [[GCNetworkBase sharedInstance] getWeb:GCNETWORKAPI_GET_GUIDEHOT(pageIndex)
                                parameters:nil
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       success(responseObject);
                                   } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                       failure(error);
                                   }];
}

+ (void)getGuideDigestSuccessWithPageIndex:(NSInteger)pageIndex
                                   success:(void (^)(NSData *htmlData))success
                                   failure:(void (^)(NSError *error))failure {
    [[GCNetworkBase sharedInstance] getWeb:GCNETWORKAPI_GET_GUIDEDIGEST(pageIndex)
                                parameters:nil
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       success(responseObject);
                                   } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                       failure(error);
                                   }];
}

+ (void)getGuideNewSuccessWithPageIndex:(NSInteger)pageIndex
                                success:(void (^)(NSData *htmlData))success
                                failure:(void (^)(NSError *error))failure {
    [[GCNetworkBase sharedInstance] getWeb:GCNETWORKAPI_GET_GUIDENEW(pageIndex)
                                parameters:nil
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       success(responseObject);
                                   } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                       failure(error);
                                   }];
}

+ (void)getGuideNewThreadSuccessWithPageIndex:(NSInteger)pageIndex
                                      success:(void (^)(NSData *htmlData))success
                                      failure:(void (^)(NSError *error))failure {
    [[GCNetworkBase sharedInstance] getWeb:GCNETWORKAPI_GET_GUIDENEWTHREAD(pageIndex)
                                parameters:nil
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       success(responseObject);
                                   } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                       failure(error);
                                   }];
}

+ (void)getGuideSofaSuccessWithPageIndex:(NSInteger)pageIndex
                                 success:(void (^)(NSData *htmlData))success
                                 failure:(void (^)(NSError *error))failure {
    [[GCNetworkBase sharedInstance] getWeb:GCNETWORKAPI_GET_GUIDESOFA(pageIndex)
                                parameters:nil
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       success(responseObject);
                                   } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                       failure(error);
                                   }];
}

+ (void)getSearchWithKeyWord:(NSString *)keyWord
                   pageIndex:(NSInteger)pageIndex
                     Success:(void (^)(NSData *htmlData))success
                     failure:(void (^)(NSError *error))failure {
    if (pageIndex == 1) {
        [NSUD setObject:@"" forKey:kGCSearchURL];
        [NSUD synchronize];
        [[GCNetworkBase sharedInstance] getWeb:@"http://bbs.guitarchina.com/search.php"
                                    parameters:nil
                                       success:^(NSURLSessionDataTask *task, id responseObject) {
                                           TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:responseObject];
                                           TFHppleElement *imgElement = [[xpathParser searchWithXPathQuery:@"//input[@name='formhash']"] objectAtIndex:0];
                                           NSString *value = [imgElement.attributes objectForKey:@"value"];
                                           
                                           NSDictionary *parameters = @{@"formhash" : value,
                                                                        @"srchtxt" : keyWord,
                                                                        @"searchsubmit" : @"yes"};
                                           
                                           [[GCNetworkBase sharedInstance] postWeb:@"http://bbs.guitarchina.com/search.php?mod=forum" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

                                               [NSUD setObject:operation.response.URL.absoluteString forKey:kGCSearchURL];
                                               [NSUD synchronize];
                                               
                                               NSLog(@"%@", operation.responseString);
                                               NSData* htmlData = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
                                               success(htmlData);
                                               
                                           } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                               failure(error);
                                           }];

                                       } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                           failure(error);
                                       }];
    }
    else {
        NSString *url = [[NSUD objectForKey:kGCSearchURL] stringByAppendingFormat:@"&page=%ld", pageIndex];
        [[GCNetworkBase sharedInstance] getWeb:url
                                    parameters:nil
                                       success:^(NSURLSessionDataTask *task, id responseObject) {
                                           
                                           NSLog(@"HTML: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
                                           success(responseObject);
                                           
                                       } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                           
                                       }];
    }
}

@end
