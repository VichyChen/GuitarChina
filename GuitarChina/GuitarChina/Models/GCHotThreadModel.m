//
//  GCHotThreadModel.m
//  GuitarChina
//
//  Created by 陈大捷 on 15/9/5.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCHotThreadModel.h"

@implementation GCHotThreadModel

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
        repliesAttachment.image = [[UIImage imageNamed:@"icon_replycount"] imageWithTintColor:[UIColor LightFontColor]];
        repliesAttachment.bounds = CGRectMake(0, -2, 15, 15);
        NSAttributedString *repliesAttachmentString = [NSAttributedString attributedStringWithAttachment:repliesAttachment];
        [_replyAndViewDetailString insertAttributedString:repliesAttachmentString atIndex:_replies.length + 1];

        NSTextAttachment *viewsAttachment = [[NSTextAttachment alloc] initWithData:nil ofType:nil] ;
        viewsAttachment.image = [[UIImage imageNamed:@"icon_watch"] imageWithTintColor:[UIColor LightFontColor]];
        viewsAttachment.bounds = CGRectMake(0, -2, 15, 15);
        NSAttributedString *viewAttachmentString = [NSAttributedString attributedStringWithAttachment:viewsAttachment];
        [_replyAndViewDetailString insertAttributedString:viewAttachmentString atIndex:_replyAndViewDetailString.length];
    }
    return _replyAndViewDetailString;
}

@end

@implementation GCHotThreadArray

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super initWithDictionary:dictionary]) {
        self.perpage = [dictionary objectForKey:@"perpage"];
        
        NSArray *data = [dictionary objectForKey:@"data"];
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (NSDictionary *item in data) {
            GCHotThreadModel *model = [[GCHotThreadModel alloc] init];
            model.tid           = [item objectForKey:@"tid"];
            model.fid           = [item objectForKey:@"fid"];
            model.posttableid   = [item objectForKey:@"posttableid"];
            model.typeidfield   = [item objectForKey:@"typeid"];
            model.sortid        = [item objectForKey:@"sortid"];
            model.readperm      = [item objectForKey:@"readperm"];
            model.price         = [item objectForKey:@"price"];
            model.author        = [item objectForKey:@"author"];
            model.authorid      = [item objectForKey:@"authorid"];
            model.subject       = [item objectForKey:@"subject"];
            model.dateline      = [((NSString *)([item objectForKey:@"dateline"])) replace:@"&nbsp;" toNewString:@""];
            model.lastpost      = [((NSString *)([item objectForKey:@"lastpost"])) replace:@"&nbsp;" toNewString:@""];
            model.lastposter    = [item objectForKey:@"lastposter"];
            model.views         = [item objectForKey:@"views"];
            model.replies       = [item objectForKey:@"replies"];
            model.highlight     = [item objectForKey:@"highlight"];
            model.digest        = [item objectForKey:@"digest"];
            model.rate          = [item objectForKey:@"rate"];
            model.special       = [item objectForKey:@"special"];
            model.attachment    = [item objectForKey:@"attachment"];
            model.moderated     = [item objectForKey:@"moderated"];
            model.closed        = [item objectForKey:@"closed"];
            model.stickreply    = [item objectForKey:@"stickreply"];
            model.recommends    = [item objectForKey:@"recommends"];
            model.recommend_add = [item objectForKey:@"recommend_add"];
            model.recommend_sub = [item objectForKey:@"recommend_sub"];
            model.heats         = [item objectForKey:@"heats"];
            model.status        = [item objectForKey:@"status"];
            model.isgroup       = [item objectForKey:@"isgroup"];
            model.favtimes      = [item objectForKey:@"favtimes"];
            model.sharetimes    = [item objectForKey:@"sharetimes"];
            model.stamp         = [item objectForKey:@"stamp"];
            model.icon          = [item objectForKey:@"icon"];
            model.pushedaid     = [item objectForKey:@"pushedaid"];
            model.cover         = [item objectForKey:@"cover"];
            model.replycredit   = [item objectForKey:@"replycredit"];
            model.relatebytag   = [item objectForKey:@"relatebytag"];
            model.maxposition   = [item objectForKey:@"maxposition"];
            model.bgcolor       = [item objectForKey:@"bgcolor"];
            model.comments      = [item objectForKey:@"comments"];
            model.hidden        = [item objectForKey:@"hidden"];
            model.lastposterenc = [item objectForKey:@"lastposterenc"];
            model.multipage     = [item objectForKey:@"multipage"];
            model.pages         = [item objectForKey:@"pages"];
            model.newfield      = [item objectForKey:@"new"];
            model.heatlevel     = [item objectForKey:@"heatlevel"];
            model.moved         = [item objectForKey:@"moved"];
            model.icontid       = [item objectForKey:@"icontid"];
            model.folder        = [item objectForKey:@"folder"];
            model.weeknew       = [item objectForKey:@"weeknew"];
            model.istoday       = [item objectForKey:@"istoday"];
            model.dbdateline    = [item objectForKey:@"dbdateline"];
            model.dblastpost    = [item objectForKey:@"dblastpost"];
            model.idfield       = [item objectForKey:@"id"];
            model.rushreply     = [item objectForKey:@"rushreply"];
            model.avatar        = [item objectForKey:@"avatar"];
            [array addObject:model];
        }
        self.data = array;
    }
    
    return self;
}


@end
