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
#import "GCProfileModel.h"

@interface GCHTMLParse : NSObject

+ (void)parseLoginWeb:(NSData *)htmlData
               result:(void (^)(NSString *seccode, NSString *formhash, NSString *postURL, NSArray *questionArray))result;

+ (NSString *)parseLoginWebUID:(NSString *)html;

+ (NSString *)parseSeccodeVerifyImage:(NSData *)htmlData;

+ (GCGuideThreadArray *)parseGuideThread:(NSData *)htmlData;

+ (NSString *)parseSearchOvertime:(NSData *)htmlData;

+ (GCSearchArray *)parseSearch:(NSData *)htmlData;

+ (void)parseWebReply:(NSData *)htmlData
               result:(void (^)(NSString *formhash,
                                NSString *noticeauthor,
                                NSString *noticetrimstr,
                                NSString *noticeauthormsg,
                                NSString *reppid,
                                NSString *reppost))result;

+ (void)parseWebNewThread:(NSData *)htmlData
                   result:(void (^)(NSString *formhash, NSString *posttime))result;

+ (GCMyPromptArray *)parseMyPrompt:(NSData *)htmlData;

+ (GCProfileModel *)parseProfile:(NSData *)htmlData;

@end
