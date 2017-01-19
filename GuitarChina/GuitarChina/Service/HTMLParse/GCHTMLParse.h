//
//  GCHTMLParse.h
//  GuitarChina
//
//  Created by 陈大捷 on 16/5/14.
//  Copyright © 2016年 陈大捷. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCSearchModel.h"
#import "GCGuideThreadModel.h"
#import "GCMyPromptModel.h"

@interface GCHTMLParse : NSObject

+ (void)parseLoginWeb:(NSData *)htmlData
               result:(void (^)(NSString *seccode, NSString *formhash, NSString *postURL, NSArray *questionArray))result;

+ (NSString *)parseLoginWebUID:(NSString *)html;

+ (NSString *)parseSeccodeVerifyImage:(NSData *)htmlData;

+ (GCGuideThreadArray *)parseGuideThread:(NSData *)htmlData;

+ (NSString *)parseSearchOvertime:(NSData *)htmlData;

+ (GCSearchArray *)parseSearch:(NSData *)htmlData;

+ (NSString *)parseWebReply:(NSData *)htmlData;

+ (void)parseWebNewThread:(NSData *)htmlData
                   result:(void (^)(NSString *hash, NSArray *typeArray))result;

+ (GCMyPromptArray *)parseMyPrompt:(NSData *)htmlData;

@end
