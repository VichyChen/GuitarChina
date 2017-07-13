//
//  GCNewsModel.h
//  GuitarChina
//
//  Created by mac on 2017/7/6.
//  Copyright © 2017年 陈大捷. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCNewsModel : NSObject

@property (nonatomic, copy) NSString *pid;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *summary;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *readCount;
@property (nonatomic, copy) NSString *img;

@end

@interface GCNewsArray : NSObject

@property (nonatomic, strong) NSMutableArray *newsArray;    //GCNewsModel


@end
