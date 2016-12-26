//
//  GCForumDisplayViewController.h
//  GuitarChina
//
//  Created by 陈大捷 on 15/9/4.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCBaseViewController.h"

@interface GCForumDisplayViewController : GCBaseViewController

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *fid;
@property (nonatomic, copy) NSString *threads;
@property (nonatomic, copy) NSString *posts;
@property (nonatomic, copy) NSString *todayposts;
@property (nonatomic, copy) NSString *formhash;
@property (nonatomic, strong) NSDictionary *threadTypes;

@end
