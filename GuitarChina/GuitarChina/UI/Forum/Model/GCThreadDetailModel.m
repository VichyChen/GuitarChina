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
            //内容
            NSString *string = [item objectForKey:@"message"];
            model.message = string ? string : @"";
            
            //处理附件图片，替换<attach>成<img>
            model.attachmentsList = [item objectForKey:@"attachments"];
            NSArray *postImageList = [item objectForKey:@"imagelist"];
            if ([postImageList isKindOfClass:[NSArray class]]) {
                model.attachImageURLArray = [NSMutableArray arrayWithArray:postImageList];
            } else {
                model.attachImageURLArray = [NSMutableArray array];
            }
            for (int i = 0; i < model.attachImageURLArray.count; i++) {
                NSMutableDictionary *imageInfo = [NSMutableDictionary dictionaryWithDictionary:[model.attachmentsList objectForKey:model.attachImageURLArray[i]]];
                //附件图片url
                NSString *imageURL = [NSString stringWithFormat:@"http://bbs.guitarchina.com/%@%@%@", [imageInfo objectForKey:@"url"], [imageInfo objectForKey:@"attachment"], [NSString stringWithFormat:@"?type=%@&pid=%@&index=%d", @"GuitarChinaImage", model.pid, i]];
                //<img>
                NSString *imageHTML = [NSString stringWithFormat:@"<a href=\"%@\"><img class=\"image\" width=\"%.f\" src=\"%@\"></a>", imageURL, kScreenWidth - 30, imageURL];
                //替换[attach]
                if ([model.message containString:[NSString stringWithFormat:@"[attach]%@[/attach]", model.attachImageURLArray[i]]]) {
                    model.message = [model.message replace:[NSString stringWithFormat:@"[attach]%@[/attach]", model.attachImageURLArray[i]] toNewString:imageHTML];
                } else {
                    model.message = [NSString stringWithFormat:@"%@%@", model.message, imageHTML];
                }
                //imageList有排序，里面的id替换成url，用于看大图
                [model.attachImageURLArray replaceObjectAtIndex:i withObject:imageURL];
            }
            //替换优酷视频script成iframe
            model.message = [self covertYoukuVideo:model.message];

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
    NSData *pictureData = UIImageJPEGRepresentation([UIImage imageNamed:@"icon_ellipsis"], 0.5);
    NSString *img = [NSString stringWithFormat:@"data:image/png;base64,%@", [pictureData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]];
    for (GCThreadDetailPostModel *item in self.postlist) {
        if ([item.number isEqualToString:@"1"] && self.optionlist.count > 0) {
            NSMutableString *tableString = [[NSMutableString alloc] init];
            NSString *tableHtml = [Util getBundleHTMLString:@"GCThreadWebViewTableHtml"];
            NSMutableString *tableRow = [[NSMutableString alloc] init];
            for (GCThreadDetailOptionModel *option in self.optionlist) {
                [tableRow appendFormat:@"<tr><td>%@</td><td>%@</td></tr>", option.title, option.value];
            }
            [tableString appendFormat:tableHtml, self.optionsortname, tableRow];
            [htmlCellString appendFormat:htmlCell, item.authorid,GCNetworkAPI_URL_SmallAvatarImage(item.authorid), item.author, [item.number isEqualToString:@"1"] ? @"楼主" : [NSString stringWithFormat:@"%@楼", item.number], item.dateline, [NSString stringWithFormat:@"repquote=%@&page=%d", item.pid, (item.number.intValue % 40 == 0 ? item.number.intValue / 40 : item.number.intValue /40 + 1)], img, tableString, item.message];
        } else {
            [htmlCellString appendFormat:htmlCell, item.authorid, GCNetworkAPI_URL_SmallAvatarImage(item.authorid), item.author, [item.number isEqualToString:@"1"] ? @"楼主" : [NSString stringWithFormat:@"%@楼", item.number], item.dateline, [NSString stringWithFormat:@"repquote=%@&page=%d", item.pid, (item.number.intValue % 40 == 0 ? item.number.intValue / 40 : item.number.intValue /40 + 1)], img, @"", item.message];
        }
    }
    NSString *htmlPage = [Util getBundleHTMLString:@"GCThreadWebViewHtml"];
    [html appendFormat:htmlPage, kScreenWidth - 30, self.subject, [NSString stringWithFormat:@"%@回复 %@浏览", self.replies, self.views], htmlCellString];

    //处理尾巴样式
    html = [html replace:@"<a href=\"https://itunes.apple.com/cn/app/ji-ta-zhong-guo-hua-yu-di/id1089161305\" target=\"_blank\"><font color=\"Gray\">发自吉他中国iPhone客户端</font></a>" toNewString:@"<a href=\"https://itunes.apple.com/cn/app/ji-ta-zhong-guo-hua-yu-di/id1089161305\" target=\"_blank\" style='margin-top:10px;font-size:13px'><font color=\"Gray\">发自吉他中国iPhone客户端</font></a>"];
    html = [html replace:@"<a href=\"https://itunes.apple.com/cn/app/ji-ta-zhong-guo-hua-yu-di/id1193034315\" target=\"_blank\"><font color=\"Gray\">发自吉他中国Pro iPhone客户端</font></a>" toNewString:@"<a href=\"https://itunes.apple.com/cn/app/ji-ta-zhong-guo-hua-yu-di/id1193034315\" target=\"_blank\" style='margin-top:10px;font-size:13px'><font color=\"Gray\">发自吉他中国Pro iPhone客户端</font></a>"];
    //替换表情链接
    html = [html replace:@"src=\"static/image/smiley/gc/em" toNewString:@"src=\"http://bbs.guitarchina.com/static/image/smiley/gc/em"];
    //替换视频
    html = [html replace:@"[media]" toNewString:@""];
    html = [html replace:@"[/media]" toNewString:@""];

    return html;
}

- (NSString *)covertYoukuVideo:(NSString *)message {
    NSString *origin = message;
    NSArray *array;
    /*
     <script type=\"text/javascript\" src=\"//player.youku.com/jsapi\"></script>
     <div id=\"youkuplayer_flv_fz5\" ></div>
     <script type=\"text/javascript\">var player = new YKU.Player('youkuplayer_flv_fz5',{styleid: '0',client_id:'d0177e05f77cc8fd',vid: 'XMzg1ODMwNzQyMA==',width:120,height:100,newPlayer: true});</script><br />\r\n
     */
    
    if ([message containString:@"<script type=\"text/javascript\" src=\"//player.youku.com/jsapi\"></script>"]) {
        //第一步:replace替换<script type=\"text/javascript\" src=\"//player.youku.com/jsapi\"></script>
        message = [message replace:@"<script type=\"text/javascript\" src=\"//player.youku.com/jsapi\"></script>" toNewString:@""];
        //第二步:解析去掉<div id=\"youkuplayer_flv_fz5\" ></div>
        array = [message componentsSeparatedByString:@"<div id=\"youkuplayer_flv_"];
        if (array.count > 0) {
            NSMutableArray *newArray = [NSMutableArray array];
            [newArray addObject:array[0]];
            for (int i = 1; i < array.count; i++) {
                NSString *string = [array[i] substringToIndex:12];
                if ([string hasSuffix:@"\" ></div>"]){
                    [newArray addObject:[array[i] substringFromIndex:12]];
                }
                else {
                    //????
                }
            }
            message = [newArray componentsJoinedByString:@""];
        }
        //第三步:解析去掉<script type=\"text/javascript\">var player = new YKU.Player('youkuplayer_flv_fz5
        array = [message componentsSeparatedByString:@"<script type=\"text/javascript\">var player = new YKU.Player('youkuplayer_flv_"];
        if (array.count > 0) {
            NSMutableArray *newArray = [NSMutableArray array];
            [newArray addObject:array[0]];
            for (int i = 1; i < array.count; i++) {
                [newArray addObject:[array[i] substringFromIndex:3]];
            }
            message = [newArray componentsJoinedByString:@""];
        }
        //第四步:',{styleid: '0',client_id:'
        array = [message componentsSeparatedByString:@"',{styleid: '0',client_id:'"];
        if (array.count > 0) {
            NSMutableArray *newArray = [NSMutableArray array];
            [newArray addObject:array[0]];
            for (int i = 1; i < array.count; i++) {
                NSString *string = [[array[i] substringFromIndex:16] replace:@"',vid: '" toNewString:[NSString stringWithFormat:@"<iframe height='%.f' width='%.f' style='margin-top:15' src='http://player.youku.com/embed/", (ScreenWidth - 30) * 180 / 320, ScreenWidth - 30]];
                string = [string replace:@",width:120,height:100,newPlayer: true});</script>" toNewString:@" frameborder=0 ></iframe>"];
                [newArray addObject:string];
            }
            message = [newArray componentsJoinedByString:@""];
        }
        
        return message;
    }
    
    return origin;
}

@end

