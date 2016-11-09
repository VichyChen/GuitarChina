//
//  GCHTMLParse.m
//  GuitarChina
//
//  Created by 陈大捷 on 16/5/14.
//  Copyright © 2016年 陈大捷. All rights reserved.
//

#import "GCHTMLParse.h"
#import "TFHpple.h"
#import "GCGuideThreadModel.h"

@implementation GCHTMLParse

+ (void)parseLoginWeb:(NSData *)htmlData
               result:(void (^)(NSString *seccode, NSString *formhash, NSString *postURL, NSArray *questionArray))result {
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:htmlData];
    //seccode
    TFHppleElement *seccodeElement = [[xpathParser searchWithXPathQuery:@"//span"] objectAtIndex:4];
    NSString *seccode = [[[seccodeElement.attributes objectForKey:@"id"] split:@"_"] objectAtIndex:1];
    NSLog(@"seccode = %@", seccode);
    //formhash
    TFHppleElement *formhashElement = [[xpathParser searchWithXPathQuery:@"//input[@name='formhash']"] objectAtIndex:0];
    NSString *formhash = [formhashElement objectForKey:@"value"];
    NSLog(@"formhash = %@", formhash);
    //postURL
    TFHppleElement *formElement = [[xpathParser searchWithXPathQuery:@"//form[@name='login']"] objectAtIndex:0];
    NSString *postURL = [NSString stringWithFormat:@"%@%@", GCHOST,[formElement objectForKey:@"action"]];
    NSLog(@"postURL = %@", postURL);
    //question
    TFHppleElement *questionElement = [[xpathParser searchWithXPathQuery:@"//select[@name='questionid']"] objectAtIndex:0];
    NSArray *optionArray = questionElement.children;
    NSMutableArray *questionArray = [NSMutableArray array];
    for (TFHppleElement *element in optionArray) {
        if ([element objectForKey:@"value"]) {
            NSLog(@"%@", element.text);
            [questionArray addObject:element.text];
        }
    }
    
    result(seccode, formhash, postURL, questionArray);
}

+ (NSString *)parseSeccodeVerifyImage:(NSData *)htmlData {
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:htmlData];
    TFHppleElement *imgElement = [[xpathParser searchWithXPathQuery:@"//img"] objectAtIndex:2];
    NSString *image = [NSString stringWithFormat:@"%@%@", GCHOST,[imgElement.attributes objectForKey:@"src"]];
    
    return image;
}

+ (GCGuideThreadArray *)parseGuideThread:(NSData *)htmlData {
    NSLog(@"HTML: %@", [[NSString alloc]initWithData:htmlData encoding:NSUTF8StringEncoding]);
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:htmlData];
    //tid
    NSArray *tidArray = [xpathParser searchWithXPathQuery:@"//tbody"];
    //标题
    NSArray *subjectArray = [xpathParser searchWithXPathQuery:@"//a[@class='xst']"];
    //作者
    NSArray *authorArray = [xpathParser searchWithXPathQuery:@"//tbody/tr/td[3]/cite/a"];
    //作者id
    NSArray *authoridArray = [xpathParser searchWithXPathQuery:@"//tbody/tr/td[3]/cite/a"];
    //发帖时间
    NSArray *datelineArray = [xpathParser searchWithXPathQuery:@"//tbody/tr/td[3]/em/span"]; // /span
    //区
    NSArray *forumArray = [xpathParser searchWithXPathQuery:@"//tbody/tr/td[2]"];
    //区id
    NSArray *fidArray = [xpathParser searchWithXPathQuery:@"//tbody/tr/td[2]/a"];
    //回复数
    NSArray *repliesArray = [xpathParser searchWithXPathQuery:@"//tbody/tr/td[4]/a"];
    //浏览数
    NSArray *viewsArray = [xpathParser searchWithXPathQuery:@"//tbody/tr/td[4]/em"];
    //最后回复id
    NSArray *lastposterArray = [xpathParser searchWithXPathQuery:@"//tbody/tr/td[5]/cite/a"];
    //最后回复时间
    NSArray *lastpostArray = [xpathParser searchWithXPathQuery:@"//tbody/tr/td[5]/em/a"];// /span
    
    GCGuideThreadArray *array = [[GCGuideThreadArray alloc] init];
    array.data = [NSMutableArray array];
    if (tidArray.count == 1 && subjectArray.count == 0 && [((TFHppleElement *)tidArray[0]).content isEqualToString:@"暂时还没有帖子"]) {
    }
    else {
        for (int i = 0; i < tidArray.count; i++) {
            GCGuideThreadModel *model = [[GCGuideThreadModel alloc] init];
            model.tid = [[tidArray[i] objectForKey:@"id"] split:@"_"][1];
            model.subject = ((TFHppleElement *)subjectArray[i]).content;
            model.author = ((TFHppleElement *)authorArray[i]).content;
            model.authorid = [((NSString *)[[authoridArray[i] objectForKey:@"href"] split:@"."][0]) split:@"-"][2];
            model.dateline = ((TFHppleElement *)datelineArray[i]).content;
            model.forum = ((TFHppleElement *)forumArray[i]).content;
            model.fid = [[fidArray[i] objectForKey:@"href"] split:@"-"][1];
            model.replies = ((TFHppleElement *)repliesArray[i]).content;
            model.views = ((TFHppleElement *)viewsArray[i]).content;
            model.lastposter = ((TFHppleElement *)lastposterArray[i]).content;
            model.lastpost = ((TFHppleElement *)lastpostArray[i]).content;
            [array.data addObject:model];
        }
    }
    
    return array;
}

+ (NSString *)parseSearchOvertime:(NSData *)htmlData {
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:htmlData];
    NSArray *searchArray = [xpathParser searchWithXPathQuery:@"//div[@id='messagetext']"];
    if (searchArray.count > 0) {
        if ([((TFHppleElement *)searchArray[0]).content containString:@"抱歉，您在 30 秒内只能进行一次搜索"]) {
            return @"抱歉，您在 30 秒内只能进行一次搜索";
        }
        if ([((TFHppleElement *)searchArray[0]).content containString:@"抱歉，站点设置每分钟系统最多响应搜索请求 6 次，请稍候再试"]) {
            return @"抱歉，站点设置每分钟系统最多响应搜索请求 6 次，请稍候再试";
        }

        return @"";
    }
    return @"";
}

+ (GCSearchArray *)parseSearch:(NSData *)htmlData {
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:htmlData];

    GCSearchArray *array = [[GCSearchArray alloc] init];
    array.datas = [NSMutableArray array];
    NSArray *searchArray = [xpathParser searchWithXPathQuery:@"//li[@class='pbw']"];
    for (int i = 0; i < searchArray.count; i++) {
       TFHppleElement *element = searchArray[i];
        TFHpple *searchParser = [[TFHpple alloc] initWithHTMLData:[element.raw dataUsingEncoding:NSUTF8StringEncoding]];

        //id
        NSString *tid = [element objectForKey:@"id"];
        //标题
        TFHppleElement *subjectElement = [[searchParser searchWithXPathQuery:@"//h3[@class='xs3']/a"] objectAtIndex:0];
        NSMutableString *subject = [[NSMutableString alloc] init];
        for (int i = 0; i < subjectElement.children.count; i++) {
            TFHppleElement *subjectChildrenElement = subjectElement.children[i];
            [subject appendString:subjectChildrenElement.raw ? subjectChildrenElement.raw : subjectChildrenElement.content];
        }
        
        NSArray *pArray = [searchParser searchWithXPathQuery:@"//p"];
        //回复、查看
        TFHppleElement *replyElement = [pArray objectAtIndex:0];
        NSString *reply = replyElement.content;
        //内容
        TFHppleElement *contentElement = [pArray objectAtIndex:1];
        NSMutableString *content = [[NSMutableString alloc] init];
        for (int i = 0; i < contentElement.children.count; i++) {
            TFHppleElement *contentChildrenElement = contentElement.children[i];
            [content appendString:contentChildrenElement.raw ? contentChildrenElement.raw : contentChildrenElement.content];
        }
        //时间、作者、论坛
        TFHppleElement *otherElement = [pArray objectAtIndex:2];
        NSArray *spanArray = [[[TFHpple alloc] initWithHTMLData:[otherElement.raw dataUsingEncoding:NSUTF8StringEncoding]] searchWithXPathQuery:@"//span"];
        //时间
        TFHppleElement *datelineElement = spanArray[0];
        NSString *dateline = datelineElement.content;
        //作者
        TFHppleElement *authorElement = [[[[TFHpple alloc] initWithHTMLData:[((TFHppleElement *)spanArray[1]).raw dataUsingEncoding:NSUTF8StringEncoding]] searchWithXPathQuery:@"//a"] objectAtIndex:0];
        NSString *author = authorElement.content;
        //论坛
        TFHppleElement *forumElement = [[[[TFHpple alloc] initWithHTMLData:[((TFHppleElement *)spanArray[2]).raw dataUsingEncoding:NSUTF8StringEncoding]] searchWithXPathQuery:@"//a"] objectAtIndex:0];
        NSString *forum = forumElement.content;
        
        GCSearchModel *model = [[GCSearchModel alloc] init];
        model.tid = tid;
        model.subject = subject;
        model.content = content;
        model.reply = reply;
        model.dateline = dateline;
        model.author = author;
        model.forum = forum;
        
        NSAttributedString *attributedSubject = [[NSAttributedString alloc] initWithData:[[NSString stringWithFormat:@"<div style='font-size:15px'>%@</div>", model.subject] dataUsingEncoding:NSUnicodeStringEncoding] options : @{ NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        model.attributedSubject = attributedSubject;
        
        NSAttributedString *attributedContent = [[NSAttributedString alloc] initWithData:[[NSString stringWithFormat:@"<div style='font-size:15px'>%@</div>", model.content] dataUsingEncoding:NSUnicodeStringEncoding] options : @{ NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        model.attributedContent = attributedContent;
        
        [array.datas addObject:model];
    }
    
    return array;
}

+ (NSString *)parseWebReply:(NSData *)htmlData {
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:htmlData];
    NSArray *array = [xpathParser searchWithXPathQuery:@"//form[@id='imgattachform']/input[@name='hash']"];
    TFHppleElement *element = [array firstObject];
    NSString *formhash = [element objectForKey:@"value"];
    
    return formhash;
}

@end
