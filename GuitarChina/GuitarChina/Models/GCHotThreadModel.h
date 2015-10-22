//
//  GCHotThreadModel.h
//  GuitarChina
//
//  Created by 陈大捷 on 15/9/5.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCBaseModel.h"

@interface GCHotThreadModel : NSObject

@property (nonatomic, copy) NSString *tid;
@property (nonatomic, copy) NSString *fid;
@property (nonatomic, copy) NSString *posttableid;
@property (nonatomic, copy) NSString *typeidfield;   //typeid
@property (nonatomic, copy) NSString *sortid;
@property (nonatomic, copy) NSString *readperm;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *author;   //发帖者
@property (nonatomic, copy) NSString *authorid; //发帖id
@property (nonatomic, copy) NSString *subject;  //标题
@property (nonatomic, copy) NSString *dateline; //发布时间
@property (nonatomic, copy) NSString *lastpost; //最后回复
@property (nonatomic, copy) NSString *lastposter; //最后回复id
@property (nonatomic, copy) NSString *views;    //浏览数
@property (nonatomic, copy) NSString *replies;  //回复数
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
@property (nonatomic, copy) NSString *pages;
@property (nonatomic, copy) NSString *recommendicon;
@property (nonatomic, copy) NSString *newfield;  //new
@property (nonatomic, copy) NSString *heatlevel;
@property (nonatomic, copy) NSString *moved;
@property (nonatomic, copy) NSString *icontid;
@property (nonatomic, copy) NSString *folder;
@property (nonatomic, copy) NSString *weeknew;
@property (nonatomic, copy) NSString *istoday;
@property (nonatomic, copy) NSString *dbdateline;
@property (nonatomic, copy) NSString *dblastpost;
@property (nonatomic, copy) NSString *idfield;   //id
@property (nonatomic, copy) NSString *rushreply;
@property (nonatomic, copy) NSString *avatar;

@property (nonatomic, copy) NSMutableAttributedString *lastPosterDetailString;
@property (nonatomic, copy) NSMutableAttributedString *replyAndViewDetailString;
@property (nonatomic, copy) NSMutableAttributedString *subjectString;

@end

@interface GCHotThreadArray : GCBaseModel

@property (nonatomic, copy) NSString *perpage;

@property (nonatomic, strong) NSMutableArray *data;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
