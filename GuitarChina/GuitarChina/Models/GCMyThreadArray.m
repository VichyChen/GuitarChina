//
//  GCMyThreadArray.m
//  GuitarChina
//
//  Created by 陈大捷 on 15/8/23.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCMyThreadArray.h"

@implementation GCMyThreadModel

@end

@implementation GCMyThreadArray

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super initWithDictionary:dictionary]) {
        self.perpage = [dictionary objectForKey:@"perpage"];
        
        NSArray *data = [dictionary objectForKey:@"data"];
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (NSDictionary *item in data) {
            GCMyThreadModel *model = [[GCMyThreadModel alloc] init];
//            model.favid            = [item objectForKey:@"favid"];
            [array addObject:model];
        }
        self.data = array;
    }
    
    return self;
}

@end
