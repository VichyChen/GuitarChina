//
//  GCForumIndexArray.m
//  GuitarChina
//
//  Created by 陈大捷 on 15/8/22.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCForumIndexArray.h"

@implementation GCForumIndexNoticeModel

@end


@implementation GCForumIndexGroupModel

@end

@implementation GCForumGroupModel

@end

@implementation GCForumModel

@end

@implementation GCForumIndexArray

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        self.cookiepre        = [dictionary objectForKey:@"cookiepre"];
        self.auth             = [dictionary objectForKey:@"auth"];
        self.saltkey          = [dictionary objectForKey:@"saltkey"];
        self.member_uid       = [dictionary objectForKey:@"member_uid"];
        self.member_username  = [dictionary objectForKey:@"member_username"];
        self.member_avatar    = [dictionary objectForKey:@"member_avatar"];
        self.groupid          = [dictionary objectForKey:@"groupid"];
        self.formhash         = [dictionary objectForKey:@"formhash"];
        self.ismoderator      = [dictionary objectForKey:@"ismoderator"];
        self.readaccess       = [dictionary objectForKey:@"readaccess"];
        self.member_email     = [dictionary objectForKey:@"member_email"];
        self.member_credits   = [dictionary objectForKey:@"member_credits"];
        self.setting_bbclosed = [dictionary objectForKey:@"setting_bbclosed"];

        NSDictionary *notice = [dictionary objectForKey:@"notice"];
        GCForumIndexNoticeModel *noticeModel = [[GCForumIndexNoticeModel alloc] init];
        noticeModel.newpush   = [notice objectForKey:@"newpush"];
        noticeModel.newpm     = [notice objectForKey:@"newpm"];
        noticeModel.newprompt = [notice objectForKey:@"newprompt"];
        noticeModel.newmypost = [notice objectForKey:@"newmypost"];
        self.notice = noticeModel;
        
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
