//
//  GCForumIndexModel.m
//  GuitarChina
//
//  Created by 陈大捷 on 15/9/12.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCForumIndexModel.h"

@implementation GCForumIndexGroupModel

@end

@implementation GCForumGroupModel

@end

@implementation GCForumModel

@end

@implementation GCForumIndexArray

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super initWithDictionary:dictionary]) {
        self.member_email     = [dictionary objectForKey:@"member_email"];
        self.member_credits   = [dictionary objectForKey:@"member_credits"];
        self.setting_bbclosed = [dictionary objectForKey:@"setting_bbclosed"];
        
        NSArray *forums = [dictionary objectForKey:@"forumlist"];
        NSMutableDictionary *forumsDictionary = [NSMutableDictionary dictionary];
        for (NSDictionary *item in forums) {
            GCForumModel *forumModel = [[GCForumModel alloc] init];
            forumModel.fid        = [item objectForKey:@"fid"];
            forumModel.name       = [item objectForKey:@"name"];
            forumModel.threads    = [item objectForKey:@"threads"];
            forumModel.posts      = [item objectForKey:@"posts"];
            forumModel.todayposts = [item objectForKey:@"todayposts"];
            forumModel.descript   = [item objectForKey:@"descript"];
            [forumsDictionary setObject:forumModel forKey:[item objectForKey:@"fid"]];
        }
        
        NSArray *forumGroups = [dictionary objectForKey:@"catlist"];
        NSMutableArray *array = [[NSMutableArray alloc] init];
        NSArray *forumsTemp;
        for (NSDictionary *item in forumGroups) {
            GCForumGroupModel *forumGroupModel = [[GCForumGroupModel alloc] init];
            forumGroupModel.fid = [item objectForKey:@"fid"];
            forumGroupModel.name = [item objectForKey:@"name"];
            forumGroupModel.forums = [NSMutableArray array];
            forumsTemp = [item objectForKey:@"forums"];
            for (NSString *str in forumsTemp) {
                [forumGroupModel.forums addObject:[forumsDictionary objectForKey:str]];
            }
            [array addObject:forumGroupModel];
        }
        self.data = array;
    }
    
    return self;
}

@end
