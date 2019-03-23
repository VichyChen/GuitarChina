//
//  GCGuideThreadModel.h
//  GuitarChina
//
//  Created by 陈大捷 on 16/3/27.
//  Copyright © 2016年 陈大捷. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCGuideThreadModel : NSObject

@property (nonatomic, copy) NSString *tid;          //帖子id
@property (nonatomic, copy) NSString *fid;          //论坛id
@property (nonatomic, copy) NSString *forum;        //论坛名
@property (nonatomic, copy) NSString *author;       //发帖者
@property (nonatomic, copy) NSString *authorid;     //发帖id
@property (nonatomic, copy) NSString *subject;      //标题
@property (nonatomic, copy) NSString *dateline;     //发布时间
@property (nonatomic, copy) NSString *lastpost;     //最后回复
@property (nonatomic, copy) NSString *lastposter;   //最后回复id
@property (nonatomic, copy) NSString *views;        //浏览数
@property (nonatomic, copy) NSString *replies;      //回复数

@property (nonatomic, copy) NSMutableAttributedString *lastPosterDetailString;
@property (nonatomic, copy) NSMutableAttributedString *replyAndViewDetailString;

@end

@interface GCGuideThreadArray : NSObject

@property (nonatomic, assign) NSInteger totalPage;

@property (nonatomic, strong) NSMutableArray *data;

@end
