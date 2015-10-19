//
//  GCThreadDetailModel.h
//  GuitarChina
//
//  Created by 陈大捷 on 15/8/23.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCBaseModel.h"

@interface GCThreadDetailOptionModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *unit;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *optionid;

@end

@interface GCThreadDetailPostModel : NSObject

@property (nonatomic, copy) NSString *pid;
@property (nonatomic, copy) NSString *tid;
@property (nonatomic, copy) NSString *first;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *authorid;
@property (nonatomic, copy) NSString *dateline;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *anonymous;
@property (nonatomic, copy) NSString *attachment;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *adminid;
@property (nonatomic, copy) NSString *groupidfield;
@property (nonatomic, copy) NSString *memberstatus;
@property (nonatomic, copy) NSString *number;
@property (nonatomic, copy) NSString *dbdateline;

@property (nonatomic, strong) NSMutableDictionary *attachmentsList;    //GCThreadDetailPostAttachmentsModel

@end

@interface GCThreadDetailPostAttachmentsModel : NSObject

@property (nonatomic, copy) NSString *aid;
@property (nonatomic, copy) NSString *tid;
@property (nonatomic, copy) NSString *pid;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *dateline;
@property (nonatomic, copy) NSString *filename;
@property (nonatomic, copy) NSString *filesize;
@property (nonatomic, copy) NSString *attachment;
@property (nonatomic, copy) NSString *remote;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSString *readperm;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *isimage;
@property (nonatomic, copy) NSString *width;
@property (nonatomic, copy) NSString *thumb;
@property (nonatomic, copy) NSString *picid;
@property (nonatomic, copy) NSString *sha1;
@property (nonatomic, copy) NSString *ext;
@property (nonatomic, copy) NSString *imgalt;
@property (nonatomic, copy) NSString *attachicon;
@property (nonatomic, copy) NSString *attachsize;
@property (nonatomic, copy) NSString *attachimg;
@property (nonatomic, copy) NSString *payed;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *dbdateline;
@property (nonatomic, copy) NSString *downloads;

@end

@interface GCThreadDetailModel : GCBaseModel

@property (nonatomic, copy) NSString *tid;
@property (nonatomic, copy) NSString *fid;
@property (nonatomic, copy) NSString *posttableid;
@property (nonatomic, copy) NSString *typeidfield;
@property (nonatomic, copy) NSString *sortid;
@property (nonatomic, copy) NSString *readperm;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *authorid;
@property (nonatomic, copy) NSString *subject;
@property (nonatomic, copy) NSString *dateline;
@property (nonatomic, copy) NSString *lastpost;
@property (nonatomic, copy) NSString *lastposter;
@property (nonatomic, copy) NSString *views;
@property (nonatomic, copy) NSString *replies;
@property (nonatomic, copy) NSString *displayorder;
@property (nonatomic, copy) NSString *highlight;
@property (nonatomic, copy) NSString *digest;
@property (nonatomic, copy) NSString *rate;
@property (nonatomic, copy) NSString *special;
@property (nonatomic, copy) NSString *attachment;
@property (nonatomic, copy) NSString *moderated;
@property (nonatomic, copy) NSString *closed;
@property (nonatomic, copy) NSString *stickreply;
@property (nonatomic, copy) NSString *recommends;
@property (nonatomic, copy) NSString *recommend_add;
@property (nonatomic, copy) NSString *recommend_sub;
@property (nonatomic, copy) NSString *heats;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *isgroup;
@property (nonatomic, copy) NSString *favtimes;
@property (nonatomic, copy) NSString *sharetimes;
@property (nonatomic, copy) NSString *stamp;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *pushedaid;
@property (nonatomic, copy) NSString *cover;
@property (nonatomic, copy) NSString *replycredit;
@property (nonatomic, copy) NSString *relatebytag;
@property (nonatomic, copy) NSString *maxposition;
@property (nonatomic, copy) NSString *bgcolor;
@property (nonatomic, copy) NSString *comments;
@property (nonatomic, copy) NSString *hidden;
@property (nonatomic, copy) NSString *threadtable;
@property (nonatomic, copy) NSString *threadtableid;
@property (nonatomic, copy) NSString *posttable;
@property (nonatomic, copy) NSString *addviews;
@property (nonatomic, copy) NSString *allreplies;
@property (nonatomic, copy) NSString *is_archived;
@property (nonatomic, copy) NSString *archiveid;
@property (nonatomic, copy) NSString *subjectenc;
@property (nonatomic, copy) NSString *short_subject;
@property (nonatomic, copy) NSString *recommendlevel;
@property (nonatomic, copy) NSString *heatlevel;
@property (nonatomic, copy) NSString *relay;

@property (nonatomic, strong) NSMutableArray *imagelist;    //NSString
@property (nonatomic, strong) NSMutableArray *optionlist;    //GCThreadDetailOptionModel

@property (nonatomic, strong) NSMutableArray *postlist;    //GCThreadDetailPostModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (NSString *)getGCThreadDetailModelHtml;

@end
