//
//  GCWebViewController.h
//  GuitarChina
//
//  Created by mac on 15/10/22.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GCWebViewController : GCBaseViewController

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, retain) NSString *urlString;

@end
