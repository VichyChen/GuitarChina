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

+ (void)getForumIndexSuccess:(void (^)(GCForumIndexArray *array))success
                     failure:(void (^)(NSError *error))failure {
    [[GCNetworkBase sharedInstance] get:GCNetworkAPI_Get_ForumIndex parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [NSUD setObject:operation.responseString forKey:kForumIndexCache];
        [NSUD synchronize];
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
    [[GCNetworkBase sharedInstance] get:GCNetworkAPI_Get_ForumDisplay(forumID, pageIndex, pageSize) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
    NSLog(@"%@", GCNetworkAPI_Get_ViewThread(threadID, pageIndex, pageSize));
    [[GCNetworkBase sharedInstance] get:GCNetworkAPI_Get_ViewThread(threadID, pageIndex, pageSize) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        GCThreadDetailModel *model = [[GCThreadDetailModel alloc] initWithDictionary:[responseObject objectForKey:@"Variables"]];
        success(model);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

+ (void)getMyFavThreadSuccess:(void (^)(GCMyFavThreadArray *array))success
                      failure:(void (^)(NSError *error))failure {
    [[GCNetworkBase sharedInstance] get:GCNetworkAPI_Get_MyFavThread parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        GCMyFavThreadArray *array = [[GCMyFavThreadArray alloc] initWithDictionary:[responseObject objectForKey:@"Variables"]];
        success(array);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

+ (void)getMyThreadSuccess:(void (^)(GCMyThreadArray *array))success
                   failure:(void (^)(NSError *error))failure {
    [[GCNetworkBase sharedInstance] get:GCNetworkAPI_Get_MyThread parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        GCMyThreadArray *array = [[GCMyThreadArray alloc] initWithDictionary:[responseObject objectForKey:@"Variables"]];
        success(array);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

+ (void)getMyPromptSuccess:(void (^)(NSData *htmlData))success
                   failure:(void (^)(NSError *error))failure {
    [[GCNetworkBase sharedInstance] getWeb:GCNetworkAPI_Get_MyPrompt
                                parameters:nil
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       success(responseObject);
                                   } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                       failure(error);
                                   }];
}

+ (void)postReplyWithTid:(NSString *)tid
                 message:(NSString *)message
                formhash:(NSString *)formhash
                 success:(void (^)(GCSendReplyModel *model))success
                 failure:(void (^)(NSError *error))failure {
    [[GCNetworkBase sharedInstance] get:GCNetworkAPI_Get_PostSecure parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *parameters = @{ @"message" : message, @"noticetrimstr" : @"", @"mobiletype" : @"1", @"formhash" : formhash };
        [[GCNetworkBase sharedInstance] post:GCNetworkAPI_Post_SendReply(tid) parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
    [[GCNetworkBase sharedInstance] get:GCNetworkAPI_Get_PostSecure parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *parameters = @{ @"allownoticeauthor" : @"1", @"message" : message, @"subject" : subject, @"mobiletype" : @"1", @"formhash" : formhash, @"typeid" : type };
        [[GCNetworkBase sharedInstance] post:GCNetworkAPI_Post_NewThread(fid) parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
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

+ (void)postWebReplyImageWithFid:(NSString *)fid
                           image:(UIImage *)image
                        formhash:(NSString *)formhash
                         success:(void (^)(NSString *string))success
                         failure:(void (^)(NSError *error))failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [manager.requestSerializer setValue:@"*/*" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager.requestSerializer setValue:@"Shockwave Flash" forHTTPHeaderField:@"User-Agent"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:GCNetworkAPI_Post_WebUploadImage(fid) parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        [formData appendPartWithFormData:[@"test1.jpg" dataUsingEncoding:NSUTF8StringEncoding] name:@"Filename"];
        [formData appendPartWithFormData:[formhash dataUsingEncoding:NSUTF8StringEncoding] name:@"hash"];
        [formData appendPartWithFormData:[@"image" dataUsingEncoding:NSUTF8StringEncoding] name:@"type"];
        [formData appendPartWithFormData:[@".jpg" dataUsingEncoding:NSUTF8StringEncoding] name:@"filetype"];
        [formData appendPartWithFormData:[[NSUD stringForKey:kGCLoginID] dataUsingEncoding:NSUTF8StringEncoding] name:@"uid"];
        [formData appendPartWithFormData:[@"Submit Query" dataUsingEncoding:NSUTF8StringEncoding] name:@"Upload"];
        
        [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 1) name:@"Filedata" fileName:@"test1.jpg" mimeType:@"application/octet-stream"];
        
        
    }success:^(AFHTTPRequestOperation *operation,id responseObject) {
        NSLog(@"%@", responseObject);
        
        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        success(string);
    }failure:^(AFHTTPRequestOperation *operation,NSError *error) {
        NSLog(@"#######upload error%@", error);
        NSLog(@"%@", operation.responseString);
    }];
}

+ (void)getWebReplyWithFid:(NSString *)fid
                       tid:(NSString *)tid
                   success:(void (^)(NSData *htmlData))success
                   failure:(void (^)(NSError *error))failure {
    [[GCNetworkBase sharedInstance] getWeb:GCNetworkAPI_Get_WebReply(fid, tid)
                                parameters:nil
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       success(responseObject);
                                   }
                                   failure:^(NSURLSessionDataTask *task, NSError *error) {
                                       failure(error);
                                   }];
}

+ (void)postWebReplyWithTid:(NSString *)tid
                        fid:(NSString *)fid
                    message:(NSString *)message
                attachArray:(NSArray *)attachArray
                   formhash:(NSString *)formhash
                    success:(void (^)(void))success
                    failure:(void (^)(NSError *error))failure {
    [[GCNetworkBase sharedInstance] getWeb:GCNetworkAPI_Get_WebReplySecure parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:@{ @"noticetrimstr" : @"", @"mobiletype" : @"1", @"formhash" : formhash, @"posttime" : @"", @"wysiwyg" : @"0", @"noticeauthor" : @"", @"noticetrimstr" : @"", @"noticeauthormsg" : @"", @"subject" : @"", @"checkbox" : @"0", @"message" : message, @"usesig" : @"1", @"save" : @""}];
        if (attachArray) {
            for (NSString *attach in attachArray) {
                [parameters setObject:@"" forKey:[NSString stringWithFormat:@"attachnew[%@][description]", attach]];
            }
        }
        
        [[GCNetworkBase sharedInstance] postWeb:GCNetworkAPI_Post_WebReply(fid, tid) parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            success();
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failure(error);
        }];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
}

+ (void)getWebNewThreadWithFid:(NSString *)fid
                        sortid:(NSString *)sordid
                       success:(void (^)(NSData *htmlData))success
                       failure:(void (^)(NSError *error))failure {
    [[GCNetworkBase sharedInstance] getWeb:GCNetworkAPI_Get_WebPostThread(fid, (sordid.length > 0 ? sordid : @""))
                                parameters:nil
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       success(responseObject);
                                   }
                                   failure:^(NSURLSessionDataTask *task, NSError *error) {
                                       failure(error);
                                   }];
}

+ (void)postWebNewThreadWithFid:(NSString *)fid
                         typeid:(NSString *)type
                        subject:(NSString *)subject
                        message:(NSString *)message
                    attachArray:(NSArray *)attachArray
                tableDictionary:(NSDictionary *)tableDictionary
                       posttime:(NSString *)posttime
                       formhash:(NSString *)formhash
                        success:(void (^)(void))success
                        failure:(void (^)(NSError *error))failure {
    [[GCNetworkBase sharedInstance] getWeb:GCNetworkAPI_Get_WebPostThreadSecure parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *dictionary = @{@"formhash" : formhash,
                                     @"posttime" : posttime,
                                     @"subject" : subject,
                                     @"message" : message,
                                     @"wysiwyg" : @"1",//???
                                     @"replycredit_extcredits" : @"0",
                                     @"replycredit_times" : @"1",
                                     @"replycredit_membertimes" : @"1",
                                     @"replycredit_random" : @"100",
                                     @"allownoticeauthor" : @"1",
                                     @"usesig" : @"1",
                                     @"save" : @"", };
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:dictionary];
        if (type.length > 0) {
            [parameters setObject:type forKey:@"typeid"];
        }
        if (tableDictionary.allKeys.count > 0) {
            [parameters addEntriesFromDictionary:tableDictionary];
        }
        if (attachArray) {
            for (NSString *attach in attachArray) {
                [parameters setObject:@"" forKey:[NSString stringWithFormat:@"attachnew[%@][description]", attach]];
            }
        }
        
        [[GCNetworkBase sharedInstance] postWeb:GCNetworkAPI_Post_WebPostThread(fid) parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            success();
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failure(error);
        }];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
}



+ (void)postReportWithTid:(NSString *)tid
                     text:(NSString *)text
                  success:(void (^)(void))success
                  failure:(void (^)(NSError *error))failure {
    NSDictionary *parameters = @{ @"text" : text};
    [[GCNetworkBase sharedInstance] postWap:GCNetworkAPI_Post_Report(tid) parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
    [[GCNetworkBase sharedInstance] get:GCNetworkAPI_Get_Collection(tid, formhash) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
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

+ (void)getLoginWebSuccess:(void (^)(NSData *htmlData))success
                   failure:(void (^)(NSError *error))failure {
    [[GCNetworkBase sharedInstance] getWeb:GCNetworkAPI_URL_Login
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
    [[GCNetworkBase sharedInstance] getWeb:GCSeccode(idhash) parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
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
    [request addValue:GCNetworkAPI_URL_Login forHTTPHeaderField:@"Referer"];
    
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
                                 @"loginfield" : fastloginfield,
                                 @"username" : username,
                                 @"password" : password,
                                 @"questionid" : questionid,
                                 @"answer" : answer,
                                 @"seccodehash" : seccodehash,
                                 @"seccodemodid" : @"member::logging",
                                 @"seccodeverify" : seccodeverify,
                                 @"cookietime" : @"2592000"};
    [[GCNetworkBase sharedInstance] postWap:[Util parseURLToHTTPS:postURL] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation.responseString);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

+ (void)getGuideHotWithPageIndex:(NSInteger)pageIndex
                         success:(void (^)(NSData *htmlData))success
                         failure:(void (^)(NSError *error))failure {
    [[GCNetworkBase sharedInstance] getWeb:GCNetworkAPI_Get_GuideHot(pageIndex)
                                parameters:nil
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       success(responseObject);
                                   } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                       failure(error);
                                   }];
}

+ (void)getGuideDigestWithPageIndex:(NSInteger)pageIndex
                            success:(void (^)(NSData *htmlData))success
                            failure:(void (^)(NSError *error))failure {
    [[GCNetworkBase sharedInstance] getWeb:GCNetworkAPI_Get_GuideDigest(pageIndex)
                                parameters:nil
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       success(responseObject);
                                   } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                       failure(error);
                                   }];
}

+ (void)getGuideNewWithPageIndex:(NSInteger)pageIndex
                         success:(void (^)(NSData *htmlData))success
                         failure:(void (^)(NSError *error))failure {
    [[GCNetworkBase sharedInstance] getWeb:GCNetworkAPI_Get_GuideNew(pageIndex)
                                parameters:nil
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       success(responseObject);
                                   } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                       failure(error);
                                   }];
}

+ (void)getGuideNewThreadWithPageIndex:(NSInteger)pageIndex
                               success:(void (^)(NSData *htmlData))success
                               failure:(void (^)(NSError *error))failure {
    [[GCNetworkBase sharedInstance] getWeb:GCNetworkAPI_Get_GuideNewThread(pageIndex)
                                parameters:nil
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       success(responseObject);
                                   } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                       failure(error);
                                   }];
}

+ (void)getGuideSofaWithPageIndex:(NSInteger)pageIndex
                          success:(void (^)(NSData *htmlData))success
                          failure:(void (^)(NSError *error))failure {
    [[GCNetworkBase sharedInstance] getWeb:GCNetworkAPI_Get_GuideSofa(pageIndex)
                                parameters:nil
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       success(responseObject);
                                   } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                       failure(error);
                                   }];
}

//个人资料
+ (void)getProfileWithUID:(NSString *)uid
                  success:(void (^)(NSData *htmlData))success
                  failure:(void (^)(NSError *error))failure {
    [[GCNetworkBase sharedInstance] getWeb:GCNetworkAPI_Get_Profile(uid)
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
                                           
                                           [[GCNetworkBase sharedInstance] postWeb:@"https://bbs.guitarchina.com/search.php?mod=forum" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                               
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
