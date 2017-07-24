//
//  GCReplyThreadViewController.h
//  GuitarChina
//
//  Created by 陈大捷 on 15/9/4.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GCReplyThreadViewController : GCBaseViewController

@property (nonatomic, copy) NSString *fid;
@property (nonatomic, copy) NSString *tid;
@property (nonatomic, copy) NSString *formhash;

//引用
@property (nonatomic, copy) NSString *page;
@property (nonatomic, copy) NSString *repquote;

@property (nonatomic, copy) void(^replySuccessBlock)(void);

@end
