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

@end
