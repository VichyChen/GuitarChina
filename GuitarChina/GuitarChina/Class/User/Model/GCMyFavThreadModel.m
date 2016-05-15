//
//  GCMyFavThreadModel.m
//  GuitarChina
//
//  Created by mac on 15/10/28.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCMyFavThreadModel.h"

@implementation GCMyFavThreadModel

- (NSMutableAttributedString *)repliesString {
    if (!_repliesString) {
        _repliesString = [NSMutableAttributedString new];
        
        [_repliesString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@  ", _replies]]];
        
        NSTextAttachment *repliesAttachment = [[NSTextAttachment alloc] initWithData:nil ofType:nil] ;
        repliesAttachment.image = [[UIImage imageNamed:@"icon_replycount"] imageWithTintColor:[UIColor GCLightGrayFontColor]];
        repliesAttachment.bounds = CGRectMake(0, -2, 15, 15);
        NSAttributedString *repliesAttachmentString = [NSAttributedString attributedStringWithAttachment:repliesAttachment];
        [_repliesString insertAttributedString:repliesAttachmentString atIndex:_repliesString.length];
    }
    return _repliesString;
}

@end

@implementation GCMyFavThreadArray

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super initWithDictionary:dictionary]) {
        self.perpage = [dictionary objectForKey:@"perpage"];
        self.count = [dictionary objectForKey:@"count"];
        
        NSArray *data = [dictionary objectForKey:@"list"];
        NSMutableArray *array = [[NSMutableArray alloc] init];
        if ([data isKindOfClass:[NSArray class]]) {
            for (NSDictionary *item in data) {
                GCMyFavThreadModel *model = [[GCMyFavThreadModel alloc] init];
                model.favid            = [item objectForKey:@"favid"];
                model.uid              = [item objectForKey:@"uid"];
                model.idfield          = [item objectForKey:@"id"];
                model.idtype           = [item objectForKey:@"idtype"];
                model.spaceuid         = [item objectForKey:@"spaceuid"];
                model.title            = [item objectForKey:@"title"];
                model.descriptionfield = [item objectForKey:@"description"];
                model.dateline         = [item objectForKey:@"dateline"];
                model.icon             = [item objectForKey:@"icon"];
                model.url              = [item objectForKey:@"url"];
                model.replies          = [[item objectForKey:@"replies"] isKindOfClass:[NSNull class]] ? @"" : [item objectForKey:@"replies"];
                model.author           = [[item objectForKey:@"author"] isKindOfClass:[NSNull class]] ? @"" : [item objectForKey:@"author"];
                [array addObject:model];
            }
        }
        self.data = array;
    }
    
    return self;
}

@end
