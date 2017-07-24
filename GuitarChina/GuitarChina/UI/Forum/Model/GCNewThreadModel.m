//
//  GCNewThreadModel.m
//  GuitarChina
//
//  Created by 陈大捷 on 15/8/24.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCNewThreadModel.h"

@implementation GCNewThreadMessageModel 

@end

@implementation GCNewThreadModel

- (instancetype)initWithDictionary:(id)dictionary {
    if (self = [super initWithDictionary:[dictionary objectForKey:@"Variables"]]) {
        self.tid = [[dictionary objectForKey:@"Variables"] objectForKey:@"tid"];
        self.pid = [[dictionary objectForKey:@"Variables"] objectForKey:@"pid"];

        NSDictionary *messageDictionary = [dictionary objectForKey:@"Message"];
        GCNewThreadMessageModel *message = [[GCNewThreadMessageModel alloc] init];
        message.messageval = [messageDictionary objectForKey:@"messageval"];
        message.messagestr = [messageDictionary objectForKey:@"messagestr"];
        self.message = message;
    }
    
    return self;
}


@end
