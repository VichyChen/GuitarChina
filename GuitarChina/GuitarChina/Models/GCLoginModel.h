//
//  GCLoginModel.h
//  GuitarChina
//
//  Created by 陈大捷 on 15/8/23.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCBaseModel.h"

@interface GCLoginMessageModel :NSObject

@property (nonatomic, copy) NSString *messageval;
@property (nonatomic, copy) NSString *messagestr;

@end

@interface GCLoginModel : GCBaseModel

@property (nonatomic, copy) NSString *member_level;

@property (nonatomic, strong) GCLoginMessageModel *message;

- (instancetype)initWithDictionary:(id)dictionary;

@end
