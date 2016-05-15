//
//  GCNewThreadModel.h
//  GuitarChina
//
//  Created by 陈大捷 on 15/8/24.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCBaseModel.h"

@interface GCNewThreadMessageModel : NSObject

@property (nonatomic, copy) NSString *messageval;
@property (nonatomic, copy) NSString *messagestr;

@end

@interface GCNewThreadModel : GCBaseModel

@property (nonatomic, copy) NSString *tid;
@property (nonatomic, copy) NSString *pid;

@property (nonatomic, strong) GCNewThreadMessageModel *message;

- (instancetype)initWithDictionary:(id)dictionary;

@end
