//
//  GCThreadDetailViewController.h
//  GuitarChina
//
//  Created by mac on 15/10/16.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCBaseViewController.h"

@interface GCThreadDetailViewController : GCBaseViewController

@property (nonatomic, copy) NSString *tid;
@property (nonatomic, copy) NSString *formhash;

@property (nonatomic, strong) GCForumThreadModel *forumThreadModel;

@property (nonatomic, strong) GCHotThreadModel *hotThreadModel;

@end
