//
//  GCForumDisplayArray.m
//  GuitarChina
//
//  Created by 陈大捷 on 15/8/23.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCForumDisplayArray.h"

@implementation GCForumDisplayNoticeModel

@end

@implementation GCForumThreadModel

@end

@implementation GCForumDisplayArray

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
        self.tpp              = [dictionary objectForKey:@"tpp"];
        self.page             = [dictionary objectForKey:@"page"];
        
        NSDictionary *notice = [dictionary objectForKey:@"notice"];
        GCForumDisplayNoticeModel *noticeModel = [[GCForumDisplayNoticeModel alloc] init];
        noticeModel.newpush   = [notice objectForKey:@"newpush"];
        noticeModel.newpm     = [notice objectForKey:@"newpm"];
        noticeModel.newprompt = [notice objectForKey:@"newprompt"];
        noticeModel.newmypost = [notice objectForKey:@"newmypost"];
        self.notice = noticeModel;

        NSArray *threads = [dictionary objectForKey:@"forum_threadlist"];
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (NSDictionary *item in threads) {
            GCForumThreadModel *threadModel = [[GCForumThreadModel alloc] init];
            threadModel.tid        = [item objectForKey:@"tid"];
            threadModel.readperm   = [item objectForKey:@"readperm"];
            threadModel.author     = [item objectForKey:@"author"];
            threadModel.authorid   = [item objectForKey:@"authorid"];
            threadModel.subject    = [item objectForKey:@"subject"];
            threadModel.dateline   = [item objectForKey:@"dateline"];
            threadModel.lastpost   = [item objectForKey:@"lastpost"];
            threadModel.lastposter = [item objectForKey:@"lastposter"];
            threadModel.views      = [item objectForKey:@"views"];
            threadModel.replies    = [item objectForKey:@"replies"];
            threadModel.digest     = [item objectForKey:@"digest"];
            threadModel.attachment = [item objectForKey:@"attachment"];
            threadModel.dbdateline = [item objectForKey:@"dbdateline"];
            threadModel.dblastpost = [item objectForKey:@"dblastpost"];
            [array addObject:threadModel];
        }
        self.data = array;
    }
    
    return self;
}

@end
