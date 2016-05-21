//
//  GCSearchModel.h
//  GuitarChina
//
//  Created by 陈大捷 on 16/5/21.
//  Copyright © 2016年 陈大捷. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCSearchModel : NSObject

@property (nonatomic, copy) NSString *tid;          //帖子id
@property (nonatomic, copy) NSString *fid;          //论坛id
@property (nonatomic, copy) NSString *forum;        //论坛名
@property (nonatomic, copy) NSString *author;       //发帖者
@property (nonatomic, copy) NSString *authorid;     //发帖id
@property (nonatomic, copy) NSString *subject;      //标题
@property (nonatomic, copy) NSString *content;      //标题
@property (nonatomic, copy) NSString *dateline;     //发布时间
@property (nonatomic, copy) NSString *reply;        //回复数

@end

@interface GCSearchArray : NSObject

@property (nonatomic, strong) NSMutableArray *datas;

@end
