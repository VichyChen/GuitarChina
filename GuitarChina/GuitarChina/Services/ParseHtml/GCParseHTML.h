//
//  GCParseHTML.h
//  GuitarChina
//
//  Created by mac on 16/4/3.
//  Copyright © 2016年 陈大捷. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCParseHTML : NSObject

+ (void)parseGuideThread:(NSData *)htmlData;

+ (void)parseGuideHot:(NSData *)htmlData;

+ (void)parseGuideDigest:(NSData *)htmlData;

+ (void)parseGuideNew:(NSData *)htmlData;

+ (void)parseGuideNewThread:(NSData *)htmlData;

+ (void)parseGuideSofa:(NSData *)htmlData;

@end
