//
//  GCNetworkCache.m
//  GuitarChina
//
//  Created by mac on 16/12/16.
//  Copyright © 2016年 陈大捷. All rights reserved.
//

#import "GCNetworkCache.h"

@implementation GCNetworkCache

+ (void)getForumIndex:(void (^)(GCForumIndexArray *array))success {
    NSString *string = [NSUD objectForKey:kForumIndexCache];
    if (string) {
        GCForumIndexArray *array = [[GCForumIndexArray alloc] initWithDictionary:[[JsonTool jsonToDictionary:string] objectForKey:@"Variables"]];
        //清空今日帖子数
//        for (GCForumGroupModel *tempForumGroupModel in array.data) {
//            for (GCForumModel *tempForumModel in tempForumGroupModel.forums) {
//                tempForumModel.todayposts = @"0";
//            }
//        }
        success(array);
    }
}

@end
