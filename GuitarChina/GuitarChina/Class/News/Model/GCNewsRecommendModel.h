//
//  GCNewsRecommendModel.h
//  GuitarChina
//
//  Created by mac on 2017/7/7.
//  Copyright © 2017年 陈大捷. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCNewsMenuModel : NSObject

@property (nonatomic, copy) NSString *catID;
@property (nonatomic, copy) NSString *value;

@property (nonatomic, strong) NSMutableArray *subMenuArray;    //GCNewsMenuModel

@end

@interface GCNewsModuleModel : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) NSMutableArray *postArray;    //GCNewsModulePostModel

@end

@interface GCNewsModulePostModel : NSObject

@property (nonatomic, copy) NSString *pid;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *summary;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *readCount;

@end

@interface GCNewsRecommendModel : NSObject

@property (nonatomic, strong) NSMutableArray *menuArray;    //GCNewsMenuModel

@property (nonatomic, strong) NSMutableArray *moduleArray;  //GCNewsModuleModel

@property (nonatomic, strong) NSMutableArray *carouselArray;  //GCNewsModulePostModel

@end
