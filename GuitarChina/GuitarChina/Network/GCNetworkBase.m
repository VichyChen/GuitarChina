//
//  GCNetworkBase.m
//  GuitarChina
//
//  Created by 陈大捷 on 16/5/14.
//  Copyright © 2016年 陈大捷. All rights reserved.
//

#import "GCNetworkBase.h"

@implementation GCNetworkBase

+ (instancetype)sharedInstance {
    static GCNetworkBase *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[GCNetworkBase alloc] init];
    });
    return instance;
}

//get
- (AFHTTPRequestOperationManager *)get:(NSString *)url
                            parameters:(NSDictionary *)parameters
                               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
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
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        responseSuccessBlock(operation, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
        responseFailureBlock(operation, error);
    }];
    
    return manager;
}

//post
- (AFHTTPRequestOperationManager *)post:(NSString *)url
                             parameters:(NSDictionary *)parameters
                                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
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
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        responseSuccessBlock(operation, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        responseFailureBlock(operation, error);
    }];
    
    return manager;
}

//web
- (AFHTTPSessionManager *)getWeb:(NSString *)url
                      parameters:(NSDictionary *)parameters
                         success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                         failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    void (^responseSuccessBlock)(NSURLSessionDataTask *task, id responseObject) = ^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"Success!!!!!!~~~~~~");
        NSLog(@"HTML: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
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
    [manager.requestSerializer setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36" forHTTPHeaderField:@"User-Agent"];
    
    [manager GET:url parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        responseSuccessBlock(task, responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        responseFailureBlock(task, error);
    }];
    
    return manager;
}

//wap
- (AFHTTPSessionManager *)getWap:(NSString *)url
                      parameters:(NSDictionary *)parameters
                         success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                         failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    void (^responseSuccessBlock)(NSURLSessionDataTask *task, id responseObject) = ^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"Success!!!!!!~~~~~~");
        NSLog(@"HTML: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
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
    [manager.requestSerializer setValue:@"Mozilla/5.0 (iPhone; CPU iPhone OS 5_0 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9A334 Safari/7534.48.3" forHTTPHeaderField:@"User-Agent"];
    
    [manager GET:url parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        responseSuccessBlock(task, responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        responseFailureBlock(task, error);
    }];
    
    return manager;
}

//post web
- (AFHTTPRequestOperationManager *)postWeb:(NSString *)url
                                parameters:(NSDictionary *)parameters
                                   success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
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
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager.requestSerializer setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36" forHTTPHeaderField:@"User-Agent"];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        responseSuccessBlock(operation, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        responseFailureBlock(operation, error);
    }];
    
    return manager;
}

//post wap
- (AFHTTPRequestOperationManager *)postWap:(NSString *)url
                                parameters:(NSDictionary *)parameters
                                   success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
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
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager.requestSerializer setValue:@"Mozilla/5.0 (iPhone; CPU iPhone OS 5_0 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9A334 Safari/7534.48.3" forHTTPHeaderField:@"User-Agent"];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        responseSuccessBlock(operation, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        responseFailureBlock(operation, error);
    }];
    
    return manager;
}

@end
