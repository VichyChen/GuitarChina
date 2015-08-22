//
//  GCForumDisplayArray.h
//  GuitarChina
//
//  Created by 陈大捷 on 15/8/23.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCForumDisplayNoticeModel : NSObject

@property (nonatomic, copy) NSString *newpush;
@property (nonatomic, copy) NSString *newpm;
@property (nonatomic, copy) NSString *newprompt;
@property (nonatomic, copy) NSString *newmypost;

@end

@interface GCForumThreadModel : NSObject

@property (nonatomic, copy) NSString *tid;
@property (nonatomic, copy) NSString *readperm;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *authorid;
@property (nonatomic, copy) NSString *subject;
@property (nonatomic, copy) NSString *dateline;
@property (nonatomic, copy) NSString *lastpost;
@property (nonatomic, copy) NSString *lastposter;
@property (nonatomic, copy) NSString *views;
@property (nonatomic, copy) NSString *replies;
@property (nonatomic, copy) NSString *digest;
@property (nonatomic, copy) NSString *attachment;
@property (nonatomic, copy) NSString *dbdateline;
@property (nonatomic, copy) NSString *dblastpost;

@end


@interface GCForumDisplayArray : NSObject

@property (nonatomic, copy) NSString *cookiepre;
@property (nonatomic, copy) NSString *auth;
@property (nonatomic, copy) NSString *saltkey;
@property (nonatomic, copy) NSString *member_uid;
@property (nonatomic, copy) NSString *member_username;
@property (nonatomic, copy) NSString *member_avatar;
@property (nonatomic, copy) NSString *groupid;
@property (nonatomic, copy) NSString *formhash;
@property (nonatomic, copy) NSString *ismoderator;
@property (nonatomic, copy) NSString *readaccess;
@property (nonatomic, copy) NSString *tpp;
@property (nonatomic, copy) NSString *page;

@property (nonatomic, strong) GCForumDisplayNoticeModel *notice;
@property (nonatomic, strong) NSArray *data;    //forum_threadlist

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
