//
//  GCParseHTML.m
//  GuitarChina
//
//  Created by mac on 16/4/3.
//  Copyright © 2016年 陈大捷. All rights reserved.
//

#import "GCParseHTML.h"
#import "TFHpple.h"

@implementation GCParseHTML

+ (void)parseGuideThread:(NSData *)htmlData {
    NSLog(@"HTML: %@", [[NSString alloc]initWithData:htmlData encoding:NSUTF8StringEncoding]);
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:htmlData];
    
    //tid
    NSArray *tidArray = [xpathParser searchWithXPathQuery:@"//tbody"];
    for (TFHppleElement *element in tidArray) {
        NSString *tid = [[element objectForKey:@"id"] split:@"_"][1];
        NSLog(@"%@", tid);
    }
    
    //标题
    NSArray *subjectArray = [xpathParser searchWithXPathQuery:@"//a[@class='xst']"];
    for (TFHppleElement *element in subjectArray) {
        NSLog(@"%@", element.content);
    }
    
    //作者
    NSArray *authorArray = [xpathParser searchWithXPathQuery:@"//tbody/tr/td[3]/cite/a"];
    for (TFHppleElement *element in authorArray) {
        NSLog(@"%@", element.content);
    }
    
    //作者id
    NSArray *authoridArray = [xpathParser searchWithXPathQuery:@"//tbody/tr/td[3]/cite/a"];
    for (TFHppleElement *element in authoridArray) {
        NSString *uid = [((NSString *)[[element objectForKey:@"href"] split:@"."][0]) split:@"-"][2];
        NSLog(@"%@", uid);
    }
    
    //发帖时间
    NSArray *datelineArray = [xpathParser searchWithXPathQuery:@"//tbody/tr/td[3]/em/span/span"];
    for (TFHppleElement *element in datelineArray) {
        NSLog(@"%@", element.content);
    }
    
    //区
    NSArray *forumArray = [xpathParser searchWithXPathQuery:@"//tbody/tr/td[2]"];
    for (TFHppleElement *element in forumArray) {
        NSLog(@"%@", element.content);
    }
    
    //回复数
    NSArray *repliesArray = [xpathParser searchWithXPathQuery:@"//tbody/tr/td[4]/a"];
    for (TFHppleElement *element in repliesArray) {
        NSLog(@"%@", element.content);
    }
    //浏览数
    NSArray *viewsArray = [xpathParser searchWithXPathQuery:@"//tbody/tr/td[4]/em"];
    for (TFHppleElement *element in viewsArray) {
        NSLog(@"%@", element.content);
    }
    
    //最后回复id
    NSArray *lastposterArray = [xpathParser searchWithXPathQuery:@"//tbody/tr/td[5]/cite/a"];
    for (TFHppleElement *element in lastposterArray) {
        NSLog(@"%@", element.content);
    }
    
    //最后回复时间
    NSArray *lastpostArray = [xpathParser searchWithXPathQuery:@"//tbody/tr/td[5]/em/a/span"];
    for (TFHppleElement *element in lastpostArray) {
        NSLog(@"%@", element.content);
    }
}

+ (void)parseGuideHot:(NSData *)htmlData {
    NSLog(@"HTML: %@", [[NSString alloc]initWithData:htmlData encoding:NSUTF8StringEncoding]);
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:htmlData];
    
    //tid
    NSArray *tidArray = [xpathParser searchWithXPathQuery:@"//tbody"];
    for (TFHppleElement *element in tidArray) {
        NSString *tid = [[element objectForKey:@"id"] split:@"_"][1];
        NSLog(@"%@", tid);
    }
    
    //标题
    NSArray *subjectArray = [xpathParser searchWithXPathQuery:@"//a[@class='xst']"];
    for (TFHppleElement *element in subjectArray) {
        NSLog(@"%@", element.content);
    }
    
    //作者
    NSArray *authorArray = [xpathParser searchWithXPathQuery:@"//tbody/tr/td[3]/cite/a"];
    for (TFHppleElement *element in authorArray) {
        NSLog(@"%@", element.content);
    }
    
    //作者id
    NSArray *authoridArray = [xpathParser searchWithXPathQuery:@"//tbody/tr/td[3]/cite/a"];
    for (TFHppleElement *element in authoridArray) {
        NSString *uid = [((NSString *)[[element objectForKey:@"href"] split:@"."][0]) split:@"-"][2];
        NSLog(@"%@", uid);
    }
    
    //发帖时间
    NSArray *datelineArray = [xpathParser searchWithXPathQuery:@"//tbody/tr/td[3]/em/span/span"];
    for (TFHppleElement *element in datelineArray) {
        NSLog(@"%@", element.content);
    }
    
    //区
    NSArray *forumArray = [xpathParser searchWithXPathQuery:@"//tbody/tr/td[2]"];
    for (TFHppleElement *element in forumArray) {
        NSLog(@"%@", element.content);
    }
    
    //回复数
    NSArray *repliesArray = [xpathParser searchWithXPathQuery:@"//tbody/tr/td[4]/a"];
    for (TFHppleElement *element in repliesArray) {
        NSLog(@"%@", element.content);
    }
    //浏览数
    NSArray *viewsArray = [xpathParser searchWithXPathQuery:@"//tbody/tr/td[4]/em"];
    for (TFHppleElement *element in viewsArray) {
        NSLog(@"%@", element.content);
    }
    
    //最后回复id
    NSArray *lastposterArray = [xpathParser searchWithXPathQuery:@"//tbody/tr/td[5]/cite/a"];
    for (TFHppleElement *element in lastposterArray) {
        NSLog(@"%@", element.content);
    }
    
    //最后回复时间
    NSArray *lastpostArray = [xpathParser searchWithXPathQuery:@"//tbody/tr/td[5]/em/a/span"];
    for (TFHppleElement *element in lastpostArray) {
        NSLog(@"%@", element.content);
    }
}

+ (void)parseGuideDigest:(NSData *)htmlData {
    NSLog(@"HTML: %@", [[NSString alloc]initWithData:htmlData encoding:NSUTF8StringEncoding]);
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:htmlData];
    
    //tid
    NSArray *tidArray = [xpathParser searchWithXPathQuery:@"//tbody"];
    for (TFHppleElement *element in tidArray) {
        NSString *tid = [[element objectForKey:@"id"] split:@"_"][1];
        NSLog(@"%@", tid);
    }
    
    //标题
    NSArray *subjectArray = [xpathParser searchWithXPathQuery:@"//a[@class='xst']"];
    for (TFHppleElement *element in subjectArray) {
        NSLog(@"%@", element.content);
    }
    
    //作者
    NSArray *authorArray = [xpathParser searchWithXPathQuery:@"//tbody/tr/td[3]/cite/a"];
    for (TFHppleElement *element in authorArray) {
        NSLog(@"%@", element.content);
    }
    
    //作者id
    NSArray *authoridArray = [xpathParser searchWithXPathQuery:@"//tbody/tr/td[3]/cite/a"];
    for (TFHppleElement *element in authoridArray) {
        NSString *uid = [((NSString *)[[element objectForKey:@"href"] split:@"."][0]) split:@"-"][2];
        NSLog(@"%@", uid);
    }
    
    //发帖时间
    NSArray *datelineArray = [xpathParser searchWithXPathQuery:@"//tbody/tr/td[3]/em/span/span"];
    for (TFHppleElement *element in datelineArray) {
        NSLog(@"%@", element.content);
    }
    
    //区
    NSArray *forumArray = [xpathParser searchWithXPathQuery:@"//tbody/tr/td[2]"];
    for (TFHppleElement *element in forumArray) {
        NSLog(@"%@", element.content);
    }
    
    //回复数
    NSArray *repliesArray = [xpathParser searchWithXPathQuery:@"//tbody/tr/td[4]/a"];
    for (TFHppleElement *element in repliesArray) {
        NSLog(@"%@", element.content);
    }
    //浏览数
    NSArray *viewsArray = [xpathParser searchWithXPathQuery:@"//tbody/tr/td[4]/em"];
    for (TFHppleElement *element in viewsArray) {
        NSLog(@"%@", element.content);
    }
    
    //最后回复id
    NSArray *lastposterArray = [xpathParser searchWithXPathQuery:@"//tbody/tr/td[5]/cite/a"];
    for (TFHppleElement *element in lastposterArray) {
        NSLog(@"%@", element.content);
    }
    
    //最后回复时间
    NSArray *lastpostArray = [xpathParser searchWithXPathQuery:@"//tbody/tr/td[5]/em/a/span"];
    for (TFHppleElement *element in lastpostArray) {
        NSLog(@"%@", element.content);
    }
}

+ (void)parseGuideNew:(NSData *)htmlData {
    NSLog(@"HTML: %@", [[NSString alloc]initWithData:htmlData encoding:NSUTF8StringEncoding]);
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:htmlData];
    
    //tid
    NSArray *tidArray = [xpathParser searchWithXPathQuery:@"//tbody"];
    for (TFHppleElement *element in tidArray) {
        NSString *tid = [[element objectForKey:@"id"] split:@"_"][1];
        NSLog(@"%@", tid);
    }
    
    //标题
    NSArray *subjectArray = [xpathParser searchWithXPathQuery:@"//a[@class='xst']"];
    for (TFHppleElement *element in subjectArray) {
        NSLog(@"%@", element.content);
    }
    
    //作者
    NSArray *authorArray = [xpathParser searchWithXPathQuery:@"//tbody/tr/td[3]/cite/a"];
    for (TFHppleElement *element in authorArray) {
        NSLog(@"%@", element.content);
    }
    
    //作者id
    NSArray *authoridArray = [xpathParser searchWithXPathQuery:@"//tbody/tr/td[3]/cite/a"];
    for (TFHppleElement *element in authoridArray) {
        NSString *uid = [((NSString *)[[element objectForKey:@"href"] split:@"."][0]) split:@"-"][2];
        NSLog(@"%@", uid);
    }
    
    //发帖时间
    NSArray *datelineArray = [xpathParser searchWithXPathQuery:@"//tbody/tr/td[3]/em/span/span"];
    for (TFHppleElement *element in datelineArray) {
        NSLog(@"%@", element.content);
    }
    
    //区
    NSArray *forumArray = [xpathParser searchWithXPathQuery:@"//tbody/tr/td[2]"];
    for (TFHppleElement *element in forumArray) {
        NSLog(@"%@", element.content);
    }
    
    //回复数
    NSArray *repliesArray = [xpathParser searchWithXPathQuery:@"//tbody/tr/td[4]/a"];
    for (TFHppleElement *element in repliesArray) {
        NSLog(@"%@", element.content);
    }
    //浏览数
    NSArray *viewsArray = [xpathParser searchWithXPathQuery:@"//tbody/tr/td[4]/em"];
    for (TFHppleElement *element in viewsArray) {
        NSLog(@"%@", element.content);
    }
    
    //最后回复id
    NSArray *lastposterArray = [xpathParser searchWithXPathQuery:@"//tbody/tr/td[5]/cite/a"];
    for (TFHppleElement *element in lastposterArray) {
        NSLog(@"%@", element.content);
    }
    
    //最后回复时间
    NSArray *lastpostArray = [xpathParser searchWithXPathQuery:@"//tbody/tr/td[5]/em/a/span"];
    for (TFHppleElement *element in lastpostArray) {
        NSLog(@"%@", element.content);
    }
}

+ (void)parseGuideNewThread:(NSData *)htmlData {
    NSLog(@"HTML: %@", [[NSString alloc]initWithData:htmlData encoding:NSUTF8StringEncoding]);
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:htmlData];
    
    //tid
    NSArray *tidArray = [xpathParser searchWithXPathQuery:@"//tbody"];
    for (TFHppleElement *element in tidArray) {
        NSString *tid = [[element objectForKey:@"id"] split:@"_"][1];
        NSLog(@"%@", tid);
    }
    
    //标题
    NSArray *subjectArray = [xpathParser searchWithXPathQuery:@"//a[@class='xst']"];
    for (TFHppleElement *element in subjectArray) {
        NSLog(@"%@", element.content);
    }
    
    //作者
    NSArray *authorArray = [xpathParser searchWithXPathQuery:@"//tbody/tr/td[3]/cite/a"];
    for (TFHppleElement *element in authorArray) {
        NSLog(@"%@", element.content);
    }
    
    //作者id
    NSArray *authoridArray = [xpathParser searchWithXPathQuery:@"//tbody/tr/td[3]/cite/a"];
    for (TFHppleElement *element in authoridArray) {
        NSString *uid = [((NSString *)[[element objectForKey:@"href"] split:@"."][0]) split:@"-"][2];
        NSLog(@"%@", uid);
    }
    
    //发帖时间
    NSArray *datelineArray = [xpathParser searchWithXPathQuery:@"//tbody/tr/td[3]/em/span/span"];
    for (TFHppleElement *element in datelineArray) {
        NSLog(@"%@", element.content);
    }
    
    //区
    NSArray *forumArray = [xpathParser searchWithXPathQuery:@"//tbody/tr/td[2]"];
    for (TFHppleElement *element in forumArray) {
        NSLog(@"%@", element.content);
    }
    
    //回复数
    NSArray *repliesArray = [xpathParser searchWithXPathQuery:@"//tbody/tr/td[4]/a"];
    for (TFHppleElement *element in repliesArray) {
        NSLog(@"%@", element.content);
    }
    //浏览数
    NSArray *viewsArray = [xpathParser searchWithXPathQuery:@"//tbody/tr/td[4]/em"];
    for (TFHppleElement *element in viewsArray) {
        NSLog(@"%@", element.content);
    }
    
    //最后回复id
    NSArray *lastposterArray = [xpathParser searchWithXPathQuery:@"//tbody/tr/td[5]/cite/a"];
    for (TFHppleElement *element in lastposterArray) {
        NSLog(@"%@", element.content);
    }
    
    //最后回复时间
    NSArray *lastpostArray = [xpathParser searchWithXPathQuery:@"//tbody/tr/td[5]/em/a/span"];
    for (TFHppleElement *element in lastpostArray) {
        NSLog(@"%@", element.content);
    }
}

+ (void)parseGuideSofa:(NSData *)htmlData {
    NSLog(@"HTML: %@", [[NSString alloc]initWithData:htmlData encoding:NSUTF8StringEncoding]);
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:htmlData];
    
    //tid
    NSArray *tidArray = [xpathParser searchWithXPathQuery:@"//tbody"];
    for (TFHppleElement *element in tidArray) {
        NSString *tid = [[element objectForKey:@"id"] split:@"_"][1];
        NSLog(@"%@", tid);
    }
    
    //标题
    NSArray *subjectArray = [xpathParser searchWithXPathQuery:@"//a[@class='xst']"];
    for (TFHppleElement *element in subjectArray) {
        NSLog(@"%@", element.content);
    }
    
    //作者
    NSArray *authorArray = [xpathParser searchWithXPathQuery:@"//tbody/tr/td[3]/cite/a"];
    for (TFHppleElement *element in authorArray) {
        NSLog(@"%@", element.content);
    }
    
    //作者id
    NSArray *authoridArray = [xpathParser searchWithXPathQuery:@"//tbody/tr/td[3]/cite/a"];
    for (TFHppleElement *element in authoridArray) {
        NSString *uid = [((NSString *)[[element objectForKey:@"href"] split:@"."][0]) split:@"-"][2];
        NSLog(@"%@", uid);
    }
    
    //发帖时间
    NSArray *datelineArray = [xpathParser searchWithXPathQuery:@"//tbody/tr/td[3]/em/span/span"];
    for (TFHppleElement *element in datelineArray) {
        NSLog(@"%@", element.content);
    }
    
    //区
    NSArray *forumArray = [xpathParser searchWithXPathQuery:@"//tbody/tr/td[2]"];
    for (TFHppleElement *element in forumArray) {
        NSLog(@"%@", element.content);
    }
    
    //回复数
    NSArray *repliesArray = [xpathParser searchWithXPathQuery:@"//tbody/tr/td[4]/a"];
    for (TFHppleElement *element in repliesArray) {
        NSLog(@"%@", element.content);
    }
    //浏览数
    NSArray *viewsArray = [xpathParser searchWithXPathQuery:@"//tbody/tr/td[4]/em"];
    for (TFHppleElement *element in viewsArray) {
        NSLog(@"%@", element.content);
    }
    
    //最后回复id
    NSArray *lastposterArray = [xpathParser searchWithXPathQuery:@"//tbody/tr/td[5]/cite/a"];
    for (TFHppleElement *element in lastposterArray) {
        NSLog(@"%@", element.content);
    }
    
    //最后回复时间
    NSArray *lastpostArray = [xpathParser searchWithXPathQuery:@"//tbody/tr/td[5]/em/a/span"];
    for (TFHppleElement *element in lastpostArray) {
        NSLog(@"%@", element.content);
    }
}

@end
