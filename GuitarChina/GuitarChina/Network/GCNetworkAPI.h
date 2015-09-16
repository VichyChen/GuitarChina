//
//  GCNetworkAPI.h
//  GuitarChina
//
//  Created by 陈大捷 on 15/8/19.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import <Foundation/Foundation.h>

#define GCNETWORKAPI_SERVICE_URL @"http://bbs.guitarchina.com/api/mobile/index.php?"

//查看热帖
#define GCNETWORKAPI_GET_HOTTHREAD [NSString stringWithFormat:@"%@mobile=no&version=1&module=hotthread", GCNETWORKAPI_SERVICE_URL]

//论坛模块列表
#define GCNETWORKAPI_GET_FORUMINDEX [NSString stringWithFormat:@"%@mobile=no&version=1&module=forumindex", GCNETWORKAPI_SERVICE_URL]

//论坛模块帖子列表
#define GCNETWORKAPI_GET_FORUMDISPLAY(fid, pageIndex, pageSize) [NSString stringWithFormat:@"%@mobile=no&version=1&module=forumdisplay&submodule=checkpost&fid=%@&page=%ld&tpp=%ld", GCNETWORKAPI_SERVICE_URL, (fid), (pageIndex), (pageSize)]

//查看帖子详情
#define GCNETWORKAPI_GET_VIEWTHREAD(tid, pageIndex, pageSize) [NSString stringWithFormat:@"%@mobile=no&version=1&module=viewthread&submodule=checkpost&tid=%@&page=%ld&ppp=%ld", GCNETWORKAPI_SERVICE_URL, (tid), (pageIndex), (pageSize)]

//登陆前的授权
#define GCNETWORKAPI_GET_LGOINSECURE [NSString stringWithFormat:@"%@mobile=no&version=1&module=secure&type=login", GCNETWORKAPI_SERVICE_URL]
//登陆
#define GCNETWORKAPI_POST_LOGIN [NSString stringWithFormat:@"%@mobile=no&version=1&module=login&loginsubmit=yes&loginfield=auto&submodule=checkpost", GCNETWORKAPI_SERVICE_URL]

//我的收藏
#define GCNETWORKAPI_GET_MYFAVTHREAD [NSString stringWithFormat:@"%@mobile=no&version=1&module=myfavthread&page=1", GCNETWORKAPI_SERVICE_URL]

//我的主题
#define GCNETWORKAPI_GET_MYTHREAD [NSString stringWithFormat:@"%@mobile=no&version=1&module=mythread&page=1", GCNETWORKAPI_SERVICE_URL]

//回复、发布主题前的授权
#define GCNETWORKAPI_GET_POSTSECURE [NSString stringWithFormat:@"%@mobile=no&version=1&module=secure&type=post", GCNETWORKAPI_SERVICE_URL]
//回复
#define GCNETWORKAPI_POST_SENDREPLY(tid) [NSString stringWithFormat:@"%@mobile=no&version=1&module=sendreply&seccodeverify=&sechash=&replysubmit=yes&tid=%@", GCNETWORKAPI_SERVICE_URL, (tid)]
//发布主题
#define GCNETWORKAPI_POST_NEWTHREAD(fid) [NSString stringWithFormat:@"%@mobile=no&version=1&module=newthread&seccodeverify=&sechash=&topicsubmit=yes&fid=%@", GCNETWORKAPI_SERVICE_URL, (fid)]

//举报
#define GC_NETWORKAPI_REPORT(tid) [NSString stringWithFormat:@"http://art.365day.tv/api/set.html?act=SetSayReport&say_id=%@&V=1.1.1&F=ios&key=&user_name=&sign=", (tid)]

//收藏帖子
#define GC_NETWORKAPI_GET_COLLECTION(tid, formhash) [NSString stringWithFormat:@"http://bbs.guitarchina.com/home.php?mod=spacecp&ac=favorite&type=thread&id=%@&formhash=%@&infloat=yes&handlekey=k_favorite&inajax=1&ajaxtarget=fwin_content_k_favorite",(tid),(formhash)]
