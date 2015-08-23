//
//  GCBaseModel.h
//  GuitarChina
//
//  Created by 陈大捷 on 15/8/23.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCBaseNoticeModel.h"

@interface GCBaseModel : NSObject

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

@property (nonatomic, strong) GCBaseNoticeModel *notice;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
