//
//  GCGuideThreadModel.m
//  GuitarChina
//
//  Created by 陈大捷 on 16/3/27.
//  Copyright © 2016年 陈大捷. All rights reserved.
//

#import "GCGuideThreadModel.h"

@implementation GCGuideThreadModel

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


@implementation GCGuideThreadArray

@end
