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
#define GCNETWORKAPI_GET_FORUMDISPLAY(fid, pageIndex, pageSize) [NSString stringWithFormat:@"%@mobile=no&version=1&module=forumdisplay&submodule=checkpost&fid=%@&page=%@&tpp=%@&orderby=dateline", GCNETWORKAPI_SERVICE_URL, (fid), (pageIndex), (pageSize)]

//查看帖子详情
#define GCNETWORKAPI_GET_VIEWTHREAD(tid, pageIndex, pageSize) [NSString stringWithFormat:@"%@mobile=no&version=1&module=viewthread&submodule=checkpost&tid=%@&page=%@&ppp=%@", GCNETWORKAPI_SERVICE_URL, (tid), (pageIndex), (pageSize)]



