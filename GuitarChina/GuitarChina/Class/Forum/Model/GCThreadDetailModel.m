//
//  GCThreadDetailModel.m
//  GuitarChina
//
//  Created by 陈大捷 on 15/8/23.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCThreadDetailModel.h"

@implementation GCThreadDetailOptionModel

@end

@implementation GCThreadDetailPostModel

@end

@implementation GCThreadDetailModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super initWithDictionary:dictionary]) {
        
        NSDictionary *thread = [dictionary objectForKey:@"thread"];
        self.tid            = [thread objectForKey:@"tid"];
        self.fid            = [thread objectForKey:@"fid"];
        self.posttableid    = [thread objectForKey:@"posttableid"];
        self.typeidfield    = [thread objectForKey:@"typeid"];
        self.sortid         = [thread objectForKey:@"sortid"];
        self.readperm       = [thread objectForKey:@"readperm"];
        self.price          = [thread objectForKey:@"price"];
        self.author         = [thread objectForKey:@"author"];
        self.authorid       = [thread objectForKey:@"authorid"];
        self.subject        = [thread objectForKey:@"subject"];
        self.dateline       = [thread objectForKey:@"dateline"];
        self.lastpost       = [thread objectForKey:@"lastpost"];
        self.lastposter     = [thread objectForKey:@"lastposter"];
        self.views          = [thread objectForKey:@"views"];
        self.replies        = [thread objectForKey:@"replies"];
        self.displayorder   = [thread objectForKey:@"displayorder"];
        self.highlight      = [thread objectForKey:@"highlight"];
        self.digest         = [thread objectForKey:@"digest"];
        self.rate           = [thread objectForKey:@"rate"];
        self.special        = [thread objectForKey:@"special"];
        self.attachment     = [thread objectForKey:@"attachment"];
        self.moderated      = [thread objectForKey:@"moderated"];
        self.closed         = [thread objectForKey:@"closed"];
        self.stickreply     = [thread objectForKey:@"stickreply"];
        self.recommends     = [thread objectForKey:@"recommends"];
        self.recommend_add  = [thread objectForKey:@"recommend_add"];
        self.recommend_sub  = [thread objectForKey:@"recommend_sub"];
        self.heats          = [thread objectForKey:@"heats"];
        self.status         = [thread objectForKey:@"status"];
        self.isgroup        = [thread objectForKey:@"isgroup"];
        self.favtimes       = [thread objectForKey:@"favtimes"];
        self.sharetimes     = [thread objectForKey:@"sharetimes"];
        self.stamp          = [thread objectForKey:@"stamp"];
        self.icon           = [thread objectForKey:@"icon"];
        self.pushedaid      = [thread objectForKey:@"pushedaid"];
        self.cover          = [thread objectForKey:@"cover"];
        self.replycredit    = [thread objectForKey:@"replycredit"];
        self.relatebytag    = [thread objectForKey:@"relatebytag"];
        self.maxposition    = [thread objectForKey:@"maxposition"];
        self.bgcolor        = [thread objectForKey:@"bgcolor"];
        self.comments       = [thread objectForKey:@"comments"];
        self.hidden         = [thread objectForKey:@"hidden"];
        self.threadtable    = [thread objectForKey:@"threadtable"];
        self.threadtableid  = [thread objectForKey:@"threadtableid"];
        self.posttable      = [thread objectForKey:@"posttable"];
        self.addviews       = [thread objectForKey:@"addviews"];
        self.allreplies     = [thread objectForKey:@"allreplies"];
        self.is_archived    = [thread objectForKey:@"is_archived"];
        self.archiveid      = [thread objectForKey:@"archiveid"];
        self.subjectenc     = [thread objectForKey:@"subjectenc"];
        self.short_subject  = [thread objectForKey:@"short_subject"];
        self.recommendlevel = [thread objectForKey:@"recommendlevel"];
        self.heatlevel      = [thread objectForKey:@"heatlevel"];
        self.relay          = [thread objectForKey:@"relay"];
        
        NSArray *imagelist = [dictionary objectForKey:@"imagelist"];
        NSMutableArray *imageArray = [[NSMutableArray alloc] init];
        for (NSString *item in imagelist) {
            [imageArray addObject:item];
        }
        self.imagelist = imageArray;
        
        NSDictionary *threadsortshow = [dictionary objectForKey:@"threadsortshow"];
        NSArray *optionlist = [threadsortshow objectForKey:@"optionlist"];
        NSMutableArray *optionArray = [[NSMutableArray alloc] init];
        for (NSDictionary *item in optionlist) {
            GCThreadDetailOptionModel *model = [[GCThreadDetailOptionModel alloc] init];
            model.title    = [item objectForKey:@"title"];
            model.unit     = [item objectForKey:@"unit"];
            model.type     = [item objectForKey:@"type"];
            model.value    = [item objectForKey:@"value"];
            model.optionid = [item objectForKey:@"optionid"];
            [optionArray addObject:model];
        }
        self.optionlist = optionArray;
        self.optionsortname = [threadsortshow objectForKey:@"threadsortname"];
        
        NSArray *postlist = [dictionary objectForKey:@"postlist"];
        NSMutableArray *postArray = [[NSMutableArray alloc] init];
        for (NSDictionary *item in postlist) {
            GCThreadDetailPostModel *model = [[GCThreadDetailPostModel alloc] init];
            
            NSString *string = [item objectForKey:@"message"];
            string = [string replace:@"src=\"static/image/smiley/gc/em" toNewString:@"src=\"http://bbs.guitarchina.com/static/image/smiley/gc/em"];
            model.message = string ? string : @"";
            model.message = [model.message replace:@"[media]" toNewString:@""];
            model.message = [model.message replace:@"[/media]" toNewString:@""];
            
            //处理附件图片，替换<attach>成<img>
            model.attachmentsList = [item objectForKey:@"attachments"];
            NSEnumerator * enumeratorKey = [model.attachmentsList keyEnumerator];
            for (NSString *attachmentKey in enumeratorKey) {
                if ([model.message containString:[NSString stringWithFormat:@"[attach]%@[/attach]", attachmentKey]]) {
                    model.message = [model.message replace:[NSString stringWithFormat:@"[attach]%@[/attach]", attachmentKey] toNewString:[NSString stringWithFormat:@"<img class=\"image\" width=\"%.f\" src=\"http://bbs.guitarchina.com/%@%@\">", ScreenWidth - 30, [[model.attachmentsList objectForKey:attachmentKey] objectForKey:@"url"], [[model.attachmentsList objectForKey:attachmentKey] objectForKey:@"attachment"]]];
                } else {
                    model.message = [NSString stringWithFormat:@"%@%@", model.message, [NSString stringWithFormat:@"<img class=\"image\" width=\"%.f\" src=\"http://bbs.guitarchina.com/%@%@\">", ScreenWidth - 30, [[model.attachmentsList objectForKey:attachmentKey] objectForKey:@"url"], [[model.attachmentsList objectForKey:attachmentKey] objectForKey:@"attachment"]]];
                }
            }
            
            model.pid          = [item objectForKey:@"pid"];
            model.tid          = [item objectForKey:@"tid"];
            model.first        = [item objectForKey:@"first"];
            model.author       = [item objectForKey:@"author"];
            model.authorid     = [item objectForKey:@"authorid"];
            model.dateline     = [item objectForKey:@"dateline"];
            model.anonymous    = [item objectForKey:@"anonymous"];
            model.attachment   = [item objectForKey:@"attachment"];
            model.status       = [item objectForKey:@"status"];
            model.username     = [item objectForKey:@"username"];
            model.adminid      = [item objectForKey:@"adminid"];
            model.groupidfield = [item objectForKey:@"groupidfield"];
            model.memberstatus = [item objectForKey:@"memberstatus"];
            model.number       = [item objectForKey:@"number"];
            [postArray addObject:model];
        }
        self.postlist = postArray;
    }
    
    return self;
}

- (NSString *)getGCThreadDetailModelHtml {
    NSMutableString *html = [[NSMutableString alloc] init];
    NSMutableString *htmlCellString = [[NSMutableString alloc] init];
    NSString *htmlCell = [Util getBundleHTMLString:@"GCThreadWebViewHtmlCell"];
    for (GCThreadDetailPostModel *item in self.postlist) {
        if ([item.number isEqualToString:@"1"] && self.optionlist.count > 0) {
            NSMutableString *tableString = [[NSMutableString alloc] init];
            NSString *tableHtml = [Util getBundleHTMLString:@"GCThreadWebViewTableHtml"];
            NSMutableString *tableRow = [[NSMutableString alloc] init];
            for (GCThreadDetailOptionModel *option in self.optionlist) {
                [tableRow appendFormat:@"<tr><td>%@</td><td>%@</td></tr>", option.title, option.value];
            }
            [tableString appendFormat:tableHtml, self.optionsortname, tableRow];
            [htmlCellString appendFormat:htmlCell, GCNETWORKAPI_URL_SMALLAVTARIMAGE(item.authorid),item.author, item.dateline, [item.number isEqualToString:@"1"] ? @"楼主" : [NSString stringWithFormat:@"%@楼", item.number], tableString, item.message];
        } else {
            [htmlCellString appendFormat:htmlCell, GCNETWORKAPI_URL_SMALLAVTARIMAGE(item.authorid), item.author, item.dateline, [item.number isEqualToString:@"1"] ? @"楼主" : [NSString stringWithFormat:@"%@楼", item.number], @"", item.message];
        }
    }
    NSString *htmlPage = [Util getBundleHTMLString:@"GCThreadWebViewHtml"];
    [html appendFormat:htmlPage, ScreenWidth - 30, self.subject, [Util getDateStringWithTimeStamp:self.dateline format:@"yyyy-MM-dd HH:mm"], [NSString stringWithFormat:@"%@，%@回复 %@浏览", [APP.forumDictionary objectForKey: self.fid], self.replies, self.views], htmlCellString];
    
    return html;
}

@end

