//
//  GCMyFavThreadModel.h
//  GuitarChina
//
//  Created by mac on 15/10/28.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCBaseModel.h"

@interface GCMyFavThreadModel : NSObject

@property (nonatomic, copy) NSString *favid;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *idfield;
@property (nonatomic, copy) NSString *idtype;
@property (nonatomic, copy) NSString *spaceuid;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *descriptionfield;
@property (nonatomic, copy) NSString *dateline;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *replies;
@property (nonatomic, copy) NSString *author;

@end

@interface GCMyFavThreadArray : GCBaseModel

@property (nonatomic, copy) NSString *perpage;
@property (nonatomic, copy) NSString *count;

@property (nonatomic, strong) NSArray *data;    //GCMyFavThreadModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
