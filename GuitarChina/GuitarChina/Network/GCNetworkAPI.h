//
//  GCNetworkAPI.h
//  GuitarChina
//
//  Created by 陈大捷 on 15/8/19.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import <Foundation/Foundation.h>

#define GCHOST @"http://bbs.guitarchina.com/"

//论坛登陆地址
#define GCNetworkAPI_URL_Login @"http://bbs.guitarchina.com/member.php?mod=logging&action=login"

//验证码
#define GCSeccode(idhash) [NSString stringWithFormat:@"http://bbs.guitarchina.com/misc.php?mod=seccode&action=update&idhash=%@&modid=member::logging", (idhash)]

//论坛小头像
#define GCNetworkAPI_URL_SmallAvatarImage(uid) [NSString stringWithFormat:@"https://user.guitarchina.com/data/avatar/%@_avatar_small.jpg", [Util getAvatorImageURL:(uid)]]

//论坛中头像
#define GCNetworkAPI_URL_MiddleAvatarImage(uid) [NSString stringWithFormat:@"https://user.guitarchina.com/data/avatar/%@_avatar_middle.jpg", [Util getAvatorImageURL:(uid)]]

//论坛大头像
#define GCNetworkAPI_URL_BigAvatarImage(uid) [NSString stringWithFormat:@"https://user.guitarchina.com/data/avatar/%@_avatar_big.jpg", [Util getAvatorImageURL:(uid)]]

//论坛帖子
#define GCNetworkAPI_URL_Thread(tid) [NSString stringWithFormat:@"http://bbs.guitarchina.com/thread-%@-1-1.html", (tid)]

//查看热帖
#define GCNetworkAPI_Get_HotThread @"http://bbs.guitarchina.com/api/mobile/index.php?mobile=no&version=1&module=hotthread"

//论坛模块列表
#define GCNetworkAPI_Get_ForumIndex @"http://bbs.guitarchina.com/api/mobile/index.php?mobile=no&version=1&module=forumindex"

//论坛模块帖子列表
#define GCNetworkAPI_Get_ForumDisplay(fid, pageIndex, pageSize) [NSString stringWithFormat:@"http://bbs.guitarchina.com/api/mobile/index.php?mobile=no&version=1&module=forumdisplay&submodule=checkpost&fid=%@&page=%ld&tpp=%ld", (fid), (pageIndex), (pageSize)]

//查看帖子详情
#define GCNetworkAPI_Get_ViewThread(tid, pageIndex, pageSize) [NSString stringWithFormat:@"http://bbs.guitarchina.com/api/mobile/index.php?mobile=no&version=1&module=viewthread&submodule=checkpost&tid=%@&page=%ld&ppp=%ld", (tid), (pageIndex), (pageSize)]

//登陆前的授权
#define GCNetworkAPI_Get_LoginSecure @"http://bbs.guitarchina.com/api/mobile/index.php?mobile=no&version=1&module=secure&type=login"
//登陆
#define GCNetworkAPI_Post_Login @"http://bbs.guitarchina.com/api/mobile/index.php?mobile=no&version=1&module=login&loginsubmit=yes&loginfield=auto&submodule=checkpost"

//我的收藏
#define GCNetworkAPI_Get_MyFavThread @"http://bbs.guitarchina.com/api/mobile/index.php?mobile=no&version=1&module=myfavthread&page=1"

//我的主题
#define GCNetworkAPI_Get_MyThread @"http://bbs.guitarchina.com/api/mobile/index.php?mobile=no&version=1&module=mythread&page=1"

//我的提醒
#define GCNetworkAPI_Get_MyPrompt @"http://bbs.guitarchina.com/home.php?mod=space&do=notice&view=mypost"

//回复、发布主题前的授权
#define GCNetworkAPI_Get_PostSecure @"http://bbs.guitarchina.com/api/mobile/index.php?mobile=no&version=1&module=secure&type=post"
//回复
#define GCNetworkAPI_Post_SendReply(tid) [NSString stringWithFormat:@"http://bbs.guitarchina.com/api/mobile/index.php?mobile=no&version=1&module=sendreply&seccodeverify=&sechash=&replysubmit=yes&tid=%@", (tid)]

//发布主题
#define GCNetworkAPI_Post_NewThread(fid) [NSString stringWithFormat:@"http://bbs.guitarchina.com/api/mobile/index.php?mobile=no&version=1&module=newthread&seccodeverify=&sechash=&topicsubmit=yes&fid=%@", (fid)]

//WEB上传图片
#define GCNetworkAPI_Post_WebUploadImage(fid) [NSString stringWithFormat:@"https://bbs.guitarchina.com/misc.php?mod=swfupload&action=swfupload&operation=upload&fid=%@", (fid)]

//WEB回复页面获取
#define GCNetworkAPI_Get_WebReply(fid, tid, page, repquote) [NSString stringWithFormat:@"http://bbs.guitarchina.com/forum.php?mod=post&action=reply&fid=%@&tid=%@&extra=page=%@&repquote=%@", (fid), (tid), (page), (repquote)]
//WEB回复前调用
#define GCNetworkAPI_Get_WebReplySecure @"http://bbs.guitarchina.com/forum.php?mod=ajax&action=checkpostrule&ac=reply&inajax=yes"
//WEB回复
#define GCNetworkAPI_Post_WebReply(fid, tid) [NSString stringWithFormat:@"https://bbs.guitarchina.com/forum.php?mod=post&action=reply&fid=%@&tid=%@&extra=&replysubmit=yes", (fid), (tid)]

//WEB发布主题页面获取
#define GCNetworkAPI_Get_WebPostThread(fid, sortid) [NSString stringWithFormat:@"http://bbs.guitarchina.com/forum.php?mod=post&action=newthread&fid=%@&sortid=%@&cedit=yes&extra=", (fid), (sortid)]
//WEB发布主题前调用
#define GCNetworkAPI_Get_WebPostThreadSecure @"http://bbs.guitarchina.com/forum.php?mod=ajax&action=checkpostrule&ac=newthread&inajax=yes"
//WEB发布
#define GCNetworkAPI_Post_WebPostThread(fid) [NSString stringWithFormat:@"https://bbs.guitarchina.com/forum.php?mod=post&action=newthread&fid=%@&extra=&topicsubmit=yes", (fid)]


//举报
#define GCNetworkAPI_Post_Report(tid) [NSString stringWithFormat:@"http://art.365day.tv/api/set.html?act=SetSayReport&say_id=%@&V=1.1.1&F=ios&key=&user_name=&sign=", (tid)]

//收藏帖子
#define GCNetworkAPI_Get_Collection(tid, formhash) [NSString stringWithFormat:@"http://bbs.guitarchina.com/home.php?mod=spacecp&ac=favorite&type=thread&id=%@&formhash=%@&infloat=yes&handlekey=k_favorite&inajax=1&ajaxtarget=fwin_content_k_favorite",(tid),(formhash)]

//最新热门
#define GCNetworkAPI_Get_GuideHot(pageIndex) [NSString stringWithFormat:@"http://bbs.guitarchina.com/forum.php?mod=guide&view=hot&page=%ld", (pageIndex)]

//最新精华
#define GCNetworkAPI_Get_GuideDigest(pageIndex) [NSString stringWithFormat:@"http://bbs.guitarchina.com/forum.php?mod=guide&view=digest&page=%ld", (pageIndex)]

//最新回复
#define GCNetworkAPI_Get_GuideNew(pageIndex) [NSString stringWithFormat:@"http://bbs.guitarchina.com/forum.php?mod=guide&view=new&page=%ld", (pageIndex)]

//最新发表
#define GCNetworkAPI_Get_GuideNewThread(pageIndex) [NSString stringWithFormat:@"http://bbs.guitarchina.com/forum.php?mod=guide&view=newthread&page=%ld", (pageIndex)]

//抢沙发
#define GCNetworkAPI_Get_GuideSofa(pageIndex) [NSString stringWithFormat:@"http://bbs.guitarchina.com/forum.php?mod=guide&view=sofa&page=%ld", (pageIndex)]

//个人资料
#define GCNetworkAPI_Get_Profile(uid) [NSString stringWithFormat:@"http://bbs.guitarchina.com/home.php?mod=space&uid=%@&do=profile", (uid)]

//优酷视频地址
#define GCVideo_URL_Youku(id) [NSString stringWithFormat:@"http://v.youku.com/v_show/id_%@.html", (id)]
//土豆视频地址
#define GCVideo_URL_Tudou(id) [NSString stringWithFormat:@"http://www.tudou.com/programs/view/%@/", (id)]

