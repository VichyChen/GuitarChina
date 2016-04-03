//
//  GCParseHTML.h
//  GuitarChina
//
//  Created by mac on 16/4/3.
//  Copyright © 2016年 陈大捷. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCParseHTML : NSObject

+ (void)parseLoginWeb:(NSData *)htmlData
               result:(void (^)(NSString *seccode, NSString *formhash, NSString *postURL, NSArray *questionArray))result;

+ (NSString *)parseSeccodeVerifyImage:(NSData *)htmlData;

+ (GCGuideThreadArray *)parseGuideThread:(NSData *)htmlData;

@end
