//
//  GCSendReplyModel.m
//  GuitarChina
//
//  Created by 陈大捷 on 15/8/23.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCSendReplyModel.h"

@implementation GCSendReplyMessageModel

@end

@implementation GCSendReplyModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super initWithDictionary:[dictionary objectForKey:@"Variables"]]) {
        self.tid = [[dictionary objectForKey:@"Variables"] objectForKey:@"tid"];
        self.pid = [[dictionary objectForKey:@"Variables"] objectForKey:@"pid"];
        
        NSDictionary *messageDictionary = [dictionary objectForKey:@"Message"];
        GCSendReplyMessageModel *message = [[GCSendReplyMessageModel alloc] init];
        message.messageval = [messageDictionary objectForKey:@"messageval"];
        message.messagestr = [messageDictionary objectForKey:@"messagestr"];
        self.message = message;
    }
    
    return self;
}

@end
