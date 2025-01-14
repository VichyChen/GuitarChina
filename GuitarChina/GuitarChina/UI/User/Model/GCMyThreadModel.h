//
//  GCMyThreadModel.h
//  GuitarChina
//
//  Created by mac on 15/10/28.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCBaseModel.h"

@interface GCMyThreadModel : GCBaseModel

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
@property (nonatomic, copy) NSString *lastposterenc;
@property (nonatomic, copy) NSString *multipage;
@property (nonatomic, copy) NSString *newfield;
@property (nonatomic, copy) NSString *heatlevel;
@property (nonatomic, copy) NSString *moved;
@property (nonatomic, copy) NSString *icontid;
@property (nonatomic, copy) NSString *folder;
@property (nonatomic, copy) NSString *weeknew;
@property (nonatomic, copy) NSString *istoday;
@property (nonatomic, copy) NSString *dbdateline;
@property (nonatomic, copy) NSString *dblastpost;
@property (nonatomic, copy) NSString *idfield;
@property (nonatomic, copy) NSString *rushreply;

@property (nonatomic, copy) NSMutableAttributedString *replyAndViewDetailString;

@end

@interface GCMyThreadArray : GCBaseModel

@property (nonatomic, copy) NSString *perpage;

@property (nonatomic, strong) NSMutableArray *data;    //GCMyThreadModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
