//
//  GCForumDisplayViewController.h
//  GuitarChina
//
//  Created by 陈大捷 on 15/9/4.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCBaseTableViewController.h"

@interface GCForumDisplayViewController : GCBaseTableViewController

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *fid;
@property (nonatomic, copy) NSString *formhash;
@property (nonatomic, strong) NSDictionary *threadTypes;

@end
