//
//  GCSendReplyModel.h
//  GuitarChina
//
//  Created by 陈大捷 on 15/8/23.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//


@end
#import <Foundation/Foundation.h>
#import "GCBaseModel.h"

@interface GCSendReplyMessageModel :NSObject

@property (nonatomic, copy) NSString *messageval;
@property (nonatomic, copy) NSString *messagestr;

@end

@interface GCSendReplyModel : GCBaseModel

@property (nonatomic, copy) NSString *tid;
@property (nonatomic, copy) NSString *pid;

@property (nonatomic, strong) GCSendReplyMessageModel *message;

- (instancetype)initWithDictionary:(id)dictionary;

@end
