//
//  GCForumDisplayModel.m
//  GuitarChina
//
//  Created by 陈大捷 on 15/9/13.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCForumDisplayModel.h"

@implementation GCForumThreadModel

- (NSMutableAttributedString *)lastPosterDetailString {
    if (!_lastPosterDetailString) {
        _lastPosterDetailString = [NSMutableAttributedString new];
        
        [_lastPosterDetailString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ • 最后回复 • %@", _lastpost, _lastposter]]];
    }
    return _lastPosterDetailString;
}

- (NSMutableAttributedString *)replyAndViewDetailString {
    if (!_replyAndViewDetailString) {
        _replyAndViewDetailString = [NSMutableAttributedString new];
        
        [_replyAndViewDetailString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@    %@ ", _replies, _views]]];
        
        NSTextAttachment *repliesAttachment = [[NSTextAttachment alloc] initWithData:nil ofType:nil] ;
        repliesAttachment.image = [[UIImage imageNamed:@"icon_replycount"] imageWithTintColor:[GCColor grayColor3]];
        repliesAttachment.bounds = CGRectMake(0, -2, 15, 15);
        NSAttributedString *repliesAttachmentString = [NSAttributedString attributedStringWithAttachment:repliesAttachment];
        [_replyAndViewDetailString insertAttributedString:repliesAttachmentString atIndex:_replies.length + 1];
        
        NSTextAttachment *viewsAttachment = [[NSTextAttachment alloc] initWithData:nil ofType:nil] ;
        viewsAttachment.image = [[UIImage imageNamed:@"icon_watch"] imageWithTintColor:[GCColor grayColor3]];
        viewsAttachment.bounds = CGRectMake(0, -2, 15, 15);
        NSAttributedString *viewAttachmentString = [NSAttributedString attributedStringWithAttachment:viewsAttachment];
        [_replyAndViewDetailString insertAttributedString:viewAttachmentString atIndex:_replyAndViewDetailString.length];
    }
    return _replyAndViewDetailString;
}

@end

@implementation GCForumDisplayArray

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super initWithDictionary:dictionary]) {
        self.tpp              = [dictionary objectForKey:@"tpp"];
        self.page             = [dictionary objectForKey:@"page"];
        
        self.threadTypes = [[dictionary objectForKey:@"threadtypes"] objectForKey:@"types"];
//        if (!self.threadTypes || self.threadTypes.count == 0) {
//            self.threadTypes = [[dictionary objectForKey:@"threadsorts"] objectForKey:@"types"];
//        }
        
        NSArray *threads = [dictionary objectForKey:@"forum_threadlist"];
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (NSDictionary *item in threads) {
            GCForumThreadModel *threadModel = [[GCForumThreadModel alloc] init];
            threadModel.tid        = [item objectForKey:@"tid"];
            threadModel.readperm   = [item objectForKey:@"readperm"];
            threadModel.author     = [item objectForKey:@"author"];
            threadModel.authorid   = [item objectForKey:@"authorid"];
            threadModel.subject    = [item objectForKey:@"subject"];
            threadModel.dateline      = [((NSString *)([item objectForKey:@"dateline"])) replace:@"&nbsp;" toNewString:@""];
            threadModel.lastpost      = [((NSString *)([item objectForKey:@"lastpost"])) replace:@"&nbsp;" toNewString:@""];
            threadModel.lastposter = [item objectForKey:@"lastposter"];
            threadModel.views      = [item objectForKey:@"views"];
            threadModel.replies    = [item objectForKey:@"replies"];
            threadModel.digest     = [item objectForKey:@"digest"];
            threadModel.attachment = [item objectForKey:@"attachment"];
            threadModel.dbdateline = [item objectForKey:@"dbdateline"];
            threadModel.dblastpost = [item objectForKey:@"dblastpost"];
            [array addObject:threadModel];
        }
        self.data = array;
    }
    
    return self;
}

@end
