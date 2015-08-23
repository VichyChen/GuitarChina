//
//  GCMyFavThreadArray.m
//  GuitarChina
//
//  Created by 陈大捷 on 15/8/23.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCMyFavThreadArray.h"

@implementation GCMyFavThreadModel

@end

@implementation GCMyFavThreadArray

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super initWithDictionary:dictionary]) {
        self.perpage = [dictionary objectForKey:@"perpage"];
        self.count = [dictionary objectForKey:@"count"];
        
        NSArray *data = [dictionary objectForKey:@"list"];
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (NSDictionary *item in data) {
            GCMyFavThreadModel *model = [[GCMyFavThreadModel alloc] init];
            model.favid            = [item objectForKey:@"favid"];
            model.uid              = [item objectForKey:@"uid"];
            model.idfield          = [item objectForKey:@"id"];
            model.idtype           = [item objectForKey:@"idtype"];
            model.spaceuid         = [item objectForKey:@"spaceuid"];
            model.title            = [item objectForKey:@"title"];
            model.descriptionfield = [item objectForKey:@"description"];
            model.icon             = [item objectForKey:@"icon"];
            model.url              = [item objectForKey:@"url"];
            model.replies          = [item objectForKey:@"replies"];
            model.author           = [item objectForKey:@"author"];
            [array addObject:model];
        }
        self.data = array;
    }
    
    return self;
}

@end
