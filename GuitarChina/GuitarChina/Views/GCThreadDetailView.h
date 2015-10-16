//
//  GCThreadDetailView.h
//  GuitarChina
//
//  Created by mac on 15/10/16.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GCThreadDetailView : UIView

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, copy) void (^webViewRefreshBlock)();
@property (nonatomic, copy) void (^webViewFetchMoreBlock)();
- (void)webViewEndRefresh;
- (void)webViewEndFetchMore;


@end
