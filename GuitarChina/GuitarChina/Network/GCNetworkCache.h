//
//  GCNetworkCache.h
//  GuitarChina
//
//  Created by mac on 16/12/16.
//  Copyright © 2016年 陈大捷. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCNetworkCache : NSObject

//获取论坛模块列表
+ (void)getForumIndex:(void (^)(GCForumIndexArray *array))success;

@end
