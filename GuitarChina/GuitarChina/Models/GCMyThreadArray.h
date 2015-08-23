//
//  GCMyThreadArray.h
//  GuitarChina
//
//  Created by 陈大捷 on 15/8/23.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCBaseModel.h"

@interface GCMyThreadModel : GCBaseModel

@end

@interface GCMyThreadArray : GCBaseModel

@property (nonatomic, copy) NSString *perpage;

@property (nonatomic, strong) NSArray *data;    //GCMyThreadModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
