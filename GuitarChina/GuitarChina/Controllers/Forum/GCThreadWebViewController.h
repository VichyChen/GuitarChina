//
//  GCThreadWebViewController.h
//  GuitarChina
//
//  Created by mac on 15/10/13.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCBaseViewController.h"

@interface GCThreadWebViewController : GCBaseViewController

@property (nonatomic, copy) NSString *tid;

@property (nonatomic, strong) GCForumThreadModel *forumThreadModel;

@property (nonatomic, strong) GCHotThreadModel *hotThreadModel;

@end
