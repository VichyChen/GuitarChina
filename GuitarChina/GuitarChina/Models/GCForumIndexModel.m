//
//  GCForumIndexModel.m
//  GuitarChina
//
//  Created by 陈大捷 on 15/9/12.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCForumIndexModel.h"

@implementation GCForumIndexGroupModel

@end

@implementation GCForumGroupModel

@end

@implementation GCForumModel

- (NSMutableAttributedString *)nameString {
    if (!_nameString) {
        
        _nameString = [[NSMutableAttributedString alloc] initWithData:[@"" dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
//        [_nameString addAttribute:NSFontAttributeName
//                            value:[UIFont systemFontOfSize:17.0]
//                            range:NSMakeRange(0, _nameString.length)];
        [_nameString appendAttributedString:[[NSAttributedString alloc] initWithString:_name]];

        if (![_todayposts isEqualToString:@"0"]) {
            [_nameString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" (%@)", _todayposts]]];
        }
    }
    return _nameString;
}

- (NSMutableAttributedString *)forumDetailString {
    if (!_forumDetailString) {
        _forumDetailString = [NSMutableAttributedString new];
        
        [_forumDetailString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@帖子/%@回复", _threads, _posts]]];
    }
    return _forumDetailString;
}

@end

@implementation GCForumIndexArray

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super initWithDictionary:dictionary]) {
        self.member_email     = [dictionary objectForKey:@"member_email"];
        self.member_credits   = [dictionary objectForKey:@"member_credits"];
        self.setting_bbclosed = [dictionary objectForKey:@"setting_bbclosed"];
        
        NSArray *forums = [dictionary objectForKey:@"forumlist"];
        NSMutableDictionary *forumsDictionary = [NSMutableDictionary dictionary];
        for (NSDictionary *item in forums) {
            GCForumModel *forumModel = [[GCForumModel alloc] init];
            forumModel.fid        = [item objectForKey:@"fid"];
            forumModel.name       = [item objectForKey:@"name"];
            forumModel.threads    = [item objectForKey:@"threads"];
            forumModel.posts      = [item objectForKey:@"posts"];
            forumModel.todayposts = [item objectForKey:@"todayposts"];
            
            NSMutableString *string  = [[NSMutableString alloc ] initWithString :[item objectForKey:@"description"]];
            NSRange range = [string rangeOfString:@"<a href="];
            if (range.length != 0) {
                //                [string insertString:@"<br>" atIndex:range.location];
                string = [string substringFrom:0 toIndex:range.location];
            }
            forumModel.descript = string;
            
            [forumsDictionary setObject:forumModel forKey:[item objectForKey:@"fid"]];
        }
        
        NSArray *forumGroups = [dictionary objectForKey:@"catlist"];
        NSMutableArray *array = [[NSMutableArray alloc] init];
        NSArray *forumsTemp;
        for (NSDictionary *item in forumGroups) {
            GCForumGroupModel *forumGroupModel = [[GCForumGroupModel alloc] init];
            forumGroupModel.fid = [item objectForKey:@"fid"];
            forumGroupModel.name = [item objectForKey:@"name"];
            forumGroupModel.forums = [NSMutableArray array];
            forumsTemp = [item objectForKey:@"forums"];
            for (NSString *str in forumsTemp) {
                [forumGroupModel.forums addObject:[forumsDictionary objectForKey:str]];
            }
            [array addObject:forumGroupModel];
        }
        self.data = array;
    }
    
    return self;
}

@end
