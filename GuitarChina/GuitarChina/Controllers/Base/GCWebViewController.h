//
//  GCWebViewController.h
//  GuitarChina
//
//  Created by mac on 15/10/22.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"

@interface GCWebViewController : UIViewController

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) NJKWebViewProgressView *progressView;
@property (nonatomic, strong) NJKWebViewProgress *progressProxy;

@property (nonatomic, retain) NSString *urlString;

@end
