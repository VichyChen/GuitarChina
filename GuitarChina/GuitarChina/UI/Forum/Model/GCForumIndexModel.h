//
//  GCForumIndexModel.h
//  GuitarChina
//
//  Created by 陈大捷 on 15/9/12.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "GCBaseModel.h"

@interface GCForumIndexGroupModel : NSObject

@end

@interface GCForumGroupModel : NSObject

@property (nonatomic, copy) NSString *fid;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSMutableArray *forums;  //GCForumModel

@end

@interface GCForumModel : NSObject <NSCopying>

@property (nonatomic, copy) NSString *fid;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *threads;
@property (nonatomic, copy) NSString *posts;
@property (nonatomic, copy) NSString *todayposts;
@property (nonatomic, copy) NSMutableString *descript;

@property (nonatomic, copy) NSMutableAttributedString *nameString;
@property (nonatomic, copy) NSMutableAttributedString *forumDetailString;

@end

@interface GCForumIndexArray : GCBaseModel

@property (nonatomic, copy) NSString *member_email;
@property (nonatomic, copy) NSString *member_credits;
@property (nonatomic, copy) NSString *setting_bbclosed;

@property (nonatomic, strong) GCForumIndexGroupModel *group;
@property (nonatomic, strong) NSMutableArray *data;    //GCForumGroupModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
