//
//  GCHTMLParse.m
//  GuitarChina
//
//  Created by 陈大捷 on 16/5/14.
//  Copyright © 2016年 陈大捷. All rights reserved.
//

#import "GCHTMLParse.h"
#import "TFHpple.h"

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

+ (NSString *)parseLoginWebUID:(NSString *)html {
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:[html dataUsingEncoding:NSUTF8StringEncoding]];
    TFHppleElement *element = [[xpathParser searchWithXPathQuery:@"//a[@class='icon_userinfo']"] firstObject];
    NSString *url = [element.attributes objectForKey:@"href"];
    NSDictionary *dictionary = [Util parseURLQueryStringToDictionary:[NSURL URLWithString:url]];
    return dictionary[@"uid"];
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
        NSString *reply = [[[replyElement.content replace:@" 个回复" toNewString:@"回复"] replace:@" 次查看" toNewString:@"浏览"] replace:@" - " toNewString:@" "];
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

+ (void)parseWebReply:(NSData *)htmlData
               result:(void (^)(NSString *formhash,
                                NSString *noticeauthor,
                                NSString *noticetrimstr,
                                NSString *noticeauthormsg,
                                NSString *reppid,
                                NSString *reppost))result {
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:htmlData];
    TFHppleElement *formhashElement = [[xpathParser searchWithXPathQuery:@"//form[@id='imgattachform']/input[@name='hash']"] firstObject];
    NSString *formhash = [formhashElement objectForKey:@"value"];
    
    TFHppleElement *noticeauthorElement = [[xpathParser searchWithXPathQuery:@"//input[@name='noticeauthor']"] firstObject];
    NSString *noticeauthor = [noticeauthorElement objectForKey:@"value"];

    TFHppleElement *noticetrimstrElement = [[xpathParser searchWithXPathQuery:@"//input[@name='noticetrimstr']"] firstObject];
    NSString *noticetrimstr = [noticetrimstrElement objectForKey:@"value"];

    TFHppleElement *noticeauthormsgElement = [[xpathParser searchWithXPathQuery:@"//input[@name='noticeauthormsg']"] firstObject];
    NSString *noticeauthormsg = [noticeauthormsgElement objectForKey:@"value"];

    TFHppleElement *reppidElement = [[xpathParser searchWithXPathQuery:@"//input[@name='reppid']"] firstObject];
    NSString *reppid = [reppidElement objectForKey:@"value"];

    TFHppleElement *reppostElement = [[xpathParser searchWithXPathQuery:@"//input[@name='reppost']"] firstObject];
    NSString *reppost = [reppostElement objectForKey:@"value"];
    
    result(formhash, noticeauthor, noticetrimstr, noticeauthormsg, reppid, reppost);
}

+ (void)parseWebNewThread:(NSData *)htmlData
                   result:(void (^)(NSString *formhash, NSString *posttime))result {
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:htmlData];
    //hash
    TFHppleElement *formhashElement = [[xpathParser searchWithXPathQuery:@"//form[@id='imgattachform']/input[@name='hash']"] firstObject];
    NSString *formhash = [formhashElement objectForKey:@"value"];
    TFHppleElement *posttimeElement = [[xpathParser searchWithXPathQuery:@"//input[@id='posttime']"] firstObject];
    NSString *posttime = [posttimeElement objectForKey:@"value"];
//    //typeArray
//    NSMutableArray *typeArray = [NSMutableArray array];
//    NSArray *tempTypeArray = [xpathParser searchWithXPathQuery:@"//select[@id='typeid']/option"];
//    for (TFHppleElement *typeElement in tempTypeArray) {
//        [typeArray addObject:@{ @"text" : typeElement.content, @"value" : [typeElement objectForKey:@"value"]}];
//    }
    
    result(formhash, posttime);
}

+ (GCMyPromptArray *)parseMyPrompt:(NSData *)htmlData {
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:htmlData];

    GCMyPromptArray *array = [[GCMyPromptArray alloc] init];
    array.data = [NSMutableArray array];

    NSArray *ddArray = [xpathParser searchWithXPathQuery:@"//dl[@class='cl ']"];
    for (TFHppleElement *element in ddArray) {
        GCMyPromptModel *model = [[GCMyPromptModel alloc] init];
        TFHppleElement *timeElement = [[[[TFHpple alloc] initWithHTMLData:[element.raw dataUsingEncoding:NSUTF8StringEncoding]] searchWithXPathQuery:@"//span"] lastObject];
        model.time = timeElement.content;
        
        NSArray *aArray = [[[TFHpple alloc] initWithHTMLData:[element.raw dataUsingEncoding:NSUTF8StringEncoding]] searchWithXPathQuery:@"//dd[@class='ntc_body']/a"];
        TFHppleElement *nameElement = aArray[0];
        model.uid = [([[nameElement objectForKey:@"href"] split:@"-"][2]) split:@"."][0];
        model.name = nameElement.content;
        
        TFHppleElement *remarkElement = [[xpathParser searchWithXPathQuery:@"//dd[@class='ntc_body']"] firstObject];
        model.remarkString = ((TFHppleElement *)remarkElement.children[2]).content;
        TFHppleElement *threadElement = aArray[1];
        model.tid = [[Util parseURLQueryStringToDictionary:[NSURL URLWithString:[threadElement objectForKey:@"href"]]] objectForKey:@"ptid"];
        model.threadTitle = threadElement.content;
        [array.data addObject:model];
    }
    
    return array;
}

+ (GCProfileModel *)parseProfile:(NSData *)htmlData {
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:htmlData];
    
    GCProfileModel *model = [[GCProfileModel alloc] init];
    //用户名
    TFHppleElement *usernameElement = [[xpathParser searchWithXPathQuery:@"//div[@class='hm']/h2[@class='xs2']/a"] firstObject];
    model.username = usernameElement.content;
    
    //活动状态
    NSArray *stateElementArray = [xpathParser searchWithXPathQuery:@"//ul[@id='pbbs']/li"];
    NSMutableArray *stateArray = [NSMutableArray array];
    for (TFHppleElement *stateElement in stateElementArray) {
        NSString *key = ((TFHppleElement *)stateElement.children[0]).content;
        NSString *value = ((TFHppleElement *)stateElement.children[1]).content;
        if (![key isEqualToString:@"所在时区"]) {
            [stateArray addObject:@{ @"key" : key, @"value" : value }];
        }
    }
    model.state = stateArray;

    NSArray *replyThreadElementArray = [xpathParser searchWithXPathQuery:@"//ul[@class='cl bbda pbm mbm']/li/a"];
    //回帖数
    model.replyCount = ((TFHppleElement *)replyThreadElementArray[1]).content;
    //主题数
    model.threadCount = ((TFHppleElement *)replyThreadElementArray[2]).content;
    
    //用户组
    TFHppleElement *userGroupElement = [[xpathParser searchWithXPathQuery:@"//ul/li/span[@class='xi2']/a"] firstObject];
    model.userGroup = userGroupElement.content;

    return model;
}

+ (GCNewsRecommendModel *)parseNews:(NSData *)htmlData {
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:htmlData];

    GCNewsRecommendModel *model = [[GCNewsRecommendModel alloc] init];
    //菜单
    model.menuArray = [NSMutableArray array];
    NSArray *menuArray = [xpathParser searchWithXPathQuery:@"//div[@id='et-navigation']/ul[@id='et-menu']/li"];
    for (TFHppleElement *element in menuArray) {
        TFHppleElement *menuElement = [[[[TFHpple alloc] initWithHTMLData:[element.raw dataUsingEncoding:NSUTF8StringEncoding]] searchWithXPathQuery:@"//a"] firstObject];

        GCNewsMenuModel *newsMenuModel = [[GCNewsMenuModel alloc] init];
        newsMenuModel.catID = [Util parseURLQueryStringToDictionary:[NSURL URLWithString:[menuElement objectForKey:@"href"]]][@"cat"];
        newsMenuModel.value = menuElement.content;
        newsMenuModel.subMenuArray = [NSMutableArray array];
        
        NSArray *subMenuArray = [[[TFHpple alloc] initWithHTMLData:[element.raw dataUsingEncoding:NSUTF8StringEncoding]] searchWithXPathQuery:@"//ul[@class='sub-menu']/li/a"];
        for (TFHppleElement *subMenuElement in subMenuArray) {
            GCNewsMenuModel *subNewsMenuModel = [[GCNewsMenuModel alloc] init];
            subNewsMenuModel.catID = [Util parseURLQueryStringToDictionary:[NSURL URLWithString:[subMenuElement objectForKey:@"href"]]][@"cat"];
            subNewsMenuModel.value = subMenuElement.content;
            [newsMenuModel.subMenuArray addObject:subNewsMenuModel];
        }
        
        [model.menuArray addObject:newsMenuModel];
    }
    
    //轮播
    model.carouselArray = [NSMutableArray array];
    NSArray *carouselArray = [xpathParser searchWithXPathQuery:@"//div[@class='posts-slider-module-items carousel-items et_pb_slides']/article"];
    for (TFHppleElement *carouselElement in carouselArray) {
        GCNewsModulePostModel *carouselModel = [[GCNewsModulePostModel alloc] init];
        carouselModel.pid = [Util parseURLQueryStringToDictionary:[NSURL URLWithString:[((TFHppleElement *)[[[[TFHpple alloc] initWithHTMLData:[carouselElement.raw dataUsingEncoding:NSUTF8StringEncoding]] searchWithXPathQuery:@"//div[@class='post-content-box']/div[@class='post-content']/h3/a"] firstObject]) objectForKey:@"href"]]][@"p"];
        carouselModel.content = ((TFHppleElement *)[[[[TFHpple alloc] initWithHTMLData:[carouselElement.raw dataUsingEncoding:NSUTF8StringEncoding]] searchWithXPathQuery:@"//div[@class='post-content-box']/div[@class='post-content']/h3/a"] firstObject]).content;
        carouselModel.remark = ((TFHppleElement *)[[[[TFHpple alloc] initWithHTMLData:[carouselElement.raw dataUsingEncoding:NSUTF8StringEncoding]] searchWithXPathQuery:@"//div[@class='post-content-box']/div[@class='post-content']/div[@class='post-meta vcard']/p"] firstObject]).content;
        carouselModel.summary = @"";
        
        NSString *style = [carouselElement objectForKey:@"style"];
        carouselModel.img = [style substringFrom:22 toIndex:style.length - 2];
        [model.carouselArray addObject:carouselModel];
    }
    model.moduleArray = [NSMutableArray array];
    
    //本站新闻、新闻中心
    NSArray *mainModuleArray = [xpathParser searchWithXPathQuery:@"//div[@class='tab-contents']/div[contains(@class,'tab-content tab-content-')]"];
    for (int i = 0; i < mainModuleArray.count; i++) {
        GCNewsModuleModel *newsModuleModel = [[GCNewsModuleModel alloc] init];
        newsModuleModel.name = i == 0 ? @"本站新闻" : (i == 1 ? @"新闻中心" : @"");
        newsModuleModel.postArray = [NSMutableArray array];
        
        //分类标题
        GCNewsModulePostModel *newsModulePostModel = [[GCNewsModulePostModel alloc] init];
        newsModulePostModel.pid = [Util parseURLQueryStringToDictionary:[NSURL URLWithString:[((TFHppleElement *)[[[[TFHpple alloc] initWithHTMLData:[((TFHppleElement *)mainModuleArray[i]).raw dataUsingEncoding:NSUTF8StringEncoding]] searchWithXPathQuery:@"//div[@class='main-post']/article/div[@class='post-content']/h2/a"] firstObject]) objectForKey:@"href"]]][@"p"];
        newsModulePostModel.content = ((TFHppleElement *)[[[[TFHpple alloc] initWithHTMLData:[((TFHppleElement *)mainModuleArray[i]).raw dataUsingEncoding:NSUTF8StringEncoding]] searchWithXPathQuery:@"//div[@class='main-post']/article/div[@class='post-content']/h2/a"] firstObject]).content;
        newsModulePostModel.time = ((TFHppleElement *)[[[[TFHpple alloc] initWithHTMLData:[((TFHppleElement *)mainModuleArray[i]).raw dataUsingEncoding:NSUTF8StringEncoding]] searchWithXPathQuery:@"//div[@class='main-post']/article/div[@class='post-content']/div[@class='post-meta vcard']/p/span[@class='updated']"] firstObject]).content;;
        TFHppleElement *readCountElement = [[[[TFHpple alloc] initWithHTMLData:[((TFHppleElement *)mainModuleArray[i]).raw dataUsingEncoding:NSUTF8StringEncoding]] searchWithXPathQuery:@"//div[@class='main-post']/article/div[@class='post-content']/div[@class='post-meta vcard']/p"] firstObject];
        NSArray *remarkArray = [readCountElement.content split:@"|"];
        newsModulePostModel.readCount = remarkArray[remarkArray.count - 1];
        newsModulePostModel.remark = ((TFHppleElement *)[[[[TFHpple alloc] initWithHTMLData:[((TFHppleElement *)mainModuleArray[i]).raw dataUsingEncoding:NSUTF8StringEncoding]] searchWithXPathQuery:@"//div[@class='main-post']/article/div[@class='post-content']/div[@class='post-meta vcard']/p"] firstObject]).content;
        newsModulePostModel.summary = ((TFHppleElement *)[[[[TFHpple alloc] initWithHTMLData:[((TFHppleElement *)mainModuleArray[i]).raw dataUsingEncoding:NSUTF8StringEncoding]] searchWithXPathQuery:@"//div[@class='main-post']/article/div[@class='post-content']/div[@class='excerpt entry-summary']/p"] firstObject]).content;
        newsModulePostModel.img = [((TFHppleElement *)[[[[TFHpple alloc] initWithHTMLData:[((TFHppleElement *)mainModuleArray[i]).raw dataUsingEncoding:NSUTF8StringEncoding]] searchWithXPathQuery:@"//div[@class='main-post']/article/div[@class='header']/a/img"] firstObject]) objectForKey:@"src"];
        [newsModuleModel.postArray addObject:newsModulePostModel];
        //分类列表
        NSArray *postListElementArray = [[[TFHpple alloc] initWithHTMLData:[((TFHppleElement *)mainModuleArray[i]).raw dataUsingEncoding:NSUTF8StringEncoding]] searchWithXPathQuery:@"//ul[@class='posts-list']/li/article"];
        for (TFHppleElement *postListElement in postListElementArray) {
            GCNewsModulePostModel *postModel = [[GCNewsModulePostModel alloc] init];
            postModel.pid = [Util parseURLQueryStringToDictionary:[NSURL URLWithString:[((TFHppleElement *)[[[[TFHpple alloc] initWithHTMLData:[postListElement.raw dataUsingEncoding:NSUTF8StringEncoding]] searchWithXPathQuery:@"//div[@class='post-content']/h3/a"] firstObject]) objectForKey:@"href"]]][@"p"];
            postModel.content = ((TFHppleElement *)[[[[TFHpple alloc] initWithHTMLData:[postListElement.raw dataUsingEncoding:NSUTF8StringEncoding]] searchWithXPathQuery:@"//div[@class='post-content']/h3/a"] firstObject]).content;
            postModel.remark = ((TFHppleElement *)[[[[TFHpple alloc] initWithHTMLData:[postListElement.raw dataUsingEncoding:NSUTF8StringEncoding]] searchWithXPathQuery:@"//div[@class='post-meta vcard']/p"] firstObject]).content;
            postModel.time = ((TFHppleElement *)[[[[TFHpple alloc] initWithHTMLData:[postListElement.raw dataUsingEncoding:NSUTF8StringEncoding]] searchWithXPathQuery:@"//div[@class='post-meta vcard']/p/span[@class='updated']"] firstObject]).content;;
            TFHppleElement *readCountElement = [[[[TFHpple alloc] initWithHTMLData:[postListElement.raw dataUsingEncoding:NSUTF8StringEncoding]] searchWithXPathQuery:@"//div[@class='post-meta vcard']/p"] firstObject];
            NSArray *remarkArray = [readCountElement.content split:@"|"];
            postModel.readCount = remarkArray[remarkArray.count - 1];
            postModel.summary = @"";
            postModel.img = [((TFHppleElement *)[[[[TFHpple alloc] initWithHTMLData:[postListElement.raw dataUsingEncoding:NSUTF8StringEncoding]] searchWithXPathQuery:@"//a[@class='post-thumbnail']/img"] firstObject]) objectForKey:@"src"];
            [newsModuleModel.postArray addObject:postModel];
        }
        
        [model.moduleArray addObject:newsModuleModel];
    }
    
    //分类模块
    NSArray *moduleArray = [xpathParser searchWithXPathQuery:@"//div[contains(@class,'module post-module et_pb_extra_module  et_pb_posts_')]"];
    for (TFHppleElement *moduleElement in moduleArray) {
        TFHppleElement *nameElement = [[[[TFHpple alloc] initWithHTMLData:[moduleElement.raw dataUsingEncoding:NSUTF8StringEncoding]] searchWithXPathQuery:@"//div[@class='module-head']/h1"] firstObject];
        
        GCNewsModuleModel *newsModuleModel = [[GCNewsModuleModel alloc] init];
        newsModuleModel.name = nameElement.content;
        newsModuleModel.postArray = [NSMutableArray array];
        
        //分类标题
        GCNewsModulePostModel *newsModulePostModel = [[GCNewsModulePostModel alloc] init];
        newsModulePostModel.pid = [Util parseURLQueryStringToDictionary:[NSURL URLWithString:[((TFHppleElement *)[[[[TFHpple alloc] initWithHTMLData:[moduleElement.raw dataUsingEncoding:NSUTF8StringEncoding]] searchWithXPathQuery:@"//div[@class='main-post']/article/div[@class='post-content']/h2/a"] firstObject]) objectForKey:@"href"]]][@"p"];
        newsModulePostModel.content = ((TFHppleElement *)[[[[TFHpple alloc] initWithHTMLData:[moduleElement.raw dataUsingEncoding:NSUTF8StringEncoding]] searchWithXPathQuery:@"//div[@class='main-post']/article/div[@class='post-content']/h2/a"] firstObject]).content;
        newsModulePostModel.time = ((TFHppleElement *)[[[[TFHpple alloc] initWithHTMLData:[moduleElement.raw dataUsingEncoding:NSUTF8StringEncoding]] searchWithXPathQuery:@"//div[@class='main-post']/article/div[@class='post-content']/div[@class='post-meta vcard']/p/span[@class='updated']"] firstObject]).content;;
        TFHppleElement *readCountElement = [[[[TFHpple alloc] initWithHTMLData:[moduleElement.raw dataUsingEncoding:NSUTF8StringEncoding]] searchWithXPathQuery:@"//div[@class='main-post']/article/div[@class='post-content']/div[@class='post-meta vcard']/p"] firstObject];
        NSArray *remarkArray = [readCountElement.content split:@"|"];
        newsModulePostModel.readCount = remarkArray[remarkArray.count - 1];
        newsModulePostModel.remark = ((TFHppleElement *)[[[[TFHpple alloc] initWithHTMLData:[moduleElement.raw dataUsingEncoding:NSUTF8StringEncoding]] searchWithXPathQuery:@"//div[@class='main-post']/article/div[@class='post-content']/div[@class='post-meta vcard']/p"] firstObject]).content;
        newsModulePostModel.summary = ((TFHppleElement *)[[[[TFHpple alloc] initWithHTMLData:[moduleElement.raw dataUsingEncoding:NSUTF8StringEncoding]] searchWithXPathQuery:@"//div[@class='main-post']/article/div[@class='post-content']/div[@class='excerpt entry-summary']/p"] firstObject]).content;
        newsModulePostModel.img = [((TFHppleElement *)[[[[TFHpple alloc] initWithHTMLData:[moduleElement.raw dataUsingEncoding:NSUTF8StringEncoding]] searchWithXPathQuery:@"//div[@class='main-post']/article/div[@class='header']/a/img"] firstObject]) objectForKey:@"src"];
        [newsModuleModel.postArray addObject:newsModulePostModel];
        //分类列表
        NSArray *postListElementArray = [[[TFHpple alloc] initWithHTMLData:[moduleElement.raw dataUsingEncoding:NSUTF8StringEncoding]] searchWithXPathQuery:@"//ul[@class='posts-list']/li/article"];
        for (TFHppleElement *postListElement in postListElementArray) {
            GCNewsModulePostModel *postModel = [[GCNewsModulePostModel alloc] init];
            postModel.pid = [Util parseURLQueryStringToDictionary:[NSURL URLWithString:[((TFHppleElement *)[[[[TFHpple alloc] initWithHTMLData:[postListElement.raw dataUsingEncoding:NSUTF8StringEncoding]] searchWithXPathQuery:@"//div[@class='post-content']/h3/a"] firstObject]) objectForKey:@"href"]]][@"p"];
            postModel.content = ((TFHppleElement *)[[[[TFHpple alloc] initWithHTMLData:[postListElement.raw dataUsingEncoding:NSUTF8StringEncoding]] searchWithXPathQuery:@"//div[@class='post-content']/h3/a"] firstObject]).content;
            postModel.remark = ((TFHppleElement *)[[[[TFHpple alloc] initWithHTMLData:[postListElement.raw dataUsingEncoding:NSUTF8StringEncoding]] searchWithXPathQuery:@"//div[@class='post-meta vcard']/p"] firstObject]).content;
            postModel.time = ((TFHppleElement *)[[[[TFHpple alloc] initWithHTMLData:[postListElement.raw dataUsingEncoding:NSUTF8StringEncoding]] searchWithXPathQuery:@"//div[@class='post-meta vcard']/p/span[@class='updated']"] firstObject]).content;;
            TFHppleElement *readCountElement = [[[[TFHpple alloc] initWithHTMLData:[postListElement.raw dataUsingEncoding:NSUTF8StringEncoding]] searchWithXPathQuery:@"//div[@class='post-meta vcard']/p"] firstObject];
            NSArray *remarkArray = [readCountElement.content split:@"|"];
            postModel.readCount = remarkArray[remarkArray.count - 1];
            postModel.summary = @"";
            postModel.img = [((TFHppleElement *)[[[[TFHpple alloc] initWithHTMLData:[postListElement.raw dataUsingEncoding:NSUTF8StringEncoding]] searchWithXPathQuery:@"//a[@class='post-thumbnail']/img"] firstObject]) objectForKey:@"src"];
            [newsModuleModel.postArray addObject:postModel];
        }
        
        [model.moduleArray addObject:newsModuleModel];
    }

    return model;
}

+ (GCNewsArray *)parseNewsList:(NSData *)htmlData {
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:htmlData];
    
    GCNewsArray *model = [[GCNewsArray alloc] init];

    //新闻内容
    model.newsArray = [NSMutableArray array];
    NSArray *newsArray = [xpathParser searchWithXPathQuery:@"//div[@class='paginated_page paginated_page_1 active']/article"];
    for (TFHppleElement *element in newsArray) {
        GCNewsModel *newsModel = [[GCNewsModel alloc] init];
        //标题
        TFHppleElement *contentElement = [[[[TFHpple alloc] initWithHTMLData:[element.raw dataUsingEncoding:NSUTF8StringEncoding]] searchWithXPathQuery:@"//div[@class='post-content']/h2/a"] firstObject];
        newsModel.pid = [Util parseURLQueryStringToDictionary:[NSURL URLWithString:[contentElement objectForKey:@"href"]]][@"p"];
        newsModel.content = contentElement.content;
        //时间、板块、阅读量
        TFHppleElement *remarkElement = [[[[TFHpple alloc] initWithHTMLData:[element.raw dataUsingEncoding:NSUTF8StringEncoding]] searchWithXPathQuery:@"//div[@class='post-meta vcard']/p"] firstObject];
        newsModel.remark = remarkElement.content;
        //时间
        TFHppleElement *timeElement = [[[[TFHpple alloc] initWithHTMLData:[element.raw dataUsingEncoding:NSUTF8StringEncoding]] searchWithXPathQuery:@"//div[@class='post-meta vcard']/p/span[@class='updated']"] firstObject];
        newsModel.time = timeElement.content;
        //阅读量
        TFHppleElement *readCountElement = [[[[TFHpple alloc] initWithHTMLData:[element.raw dataUsingEncoding:NSUTF8StringEncoding]] searchWithXPathQuery:@"//div[@class='post-meta vcard']/p"] firstObject];
        newsModel.readCount = [readCountElement.content split:@"|"][2];
        //内容
        TFHppleElement *summaryElement = [[[[TFHpple alloc] initWithHTMLData:[element.raw dataUsingEncoding:NSUTF8StringEncoding]] searchWithXPathQuery:@"//div[@class='excerpt entry-summary']/p"] firstObject];
        newsModel.summary = summaryElement.content;
        //图片
        TFHppleElement *imgElement = [[[[TFHpple alloc] initWithHTMLData:[element.raw dataUsingEncoding:NSUTF8StringEncoding]] searchWithXPathQuery:@"//div[@class='header']/a/img"] firstObject];
        newsModel.img = [imgElement objectForKey:@"src"];
        
        [model.newsArray addObject:newsModel];
    }
    
    return model;
}


@end
