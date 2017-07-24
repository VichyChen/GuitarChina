//
//  GCProfileModel.h
//  GuitarChina
//
//  Created by mac on 2017/3/5.
//  Copyright © 2017年 陈大捷. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCProfileModel : NSObject

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *userGroup;
@property (nonatomic, copy) NSArray *state;
@property (nonatomic, copy) NSString *replyCount;
@property (nonatomic, copy) NSString *threadCount;

@end
