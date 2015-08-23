//
//  GCForumDisplayArray.h
//  GuitarChina
//
//  Created by 陈大捷 on 15/8/23.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCBaseModel.h"

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


@interface GCForumDisplayArray : GCBaseModel

@property (nonatomic, copy) NSString *tpp;
@property (nonatomic, copy) NSString *page;

@property (nonatomic, strong) NSArray *data;    //forum_threadlist

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
