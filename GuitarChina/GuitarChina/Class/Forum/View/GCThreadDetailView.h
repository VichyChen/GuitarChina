//
//  GCThreadDetailView.h
//  GuitarChina
//
//  Created by mac on 15/10/16.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCAdBannerView.h"
#import "GCThreadDetailToolBarView.h"
#import "GCThreadDetailPagePickerView.h"

@interface GCThreadDetailView : UIView

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) GCThreadDetailToolBarView *toolBarView;
@property (nonatomic, strong) GCThreadDetailPagePickerView *pagePickerView;
@property (nonatomic, strong) GCAdBannerView *bannner;

@property (nonatomic, copy) void (^previousPageActionBlock)();
@property (nonatomic, copy) void (^nextPageActionBlock)();
@property (nonatomic, copy) void (^goActionBlock)(NSInteger page);
@property (nonatomic, copy) void (^replyActionBlock)();

@property (nonatomic, copy) void (^webViewRefreshBlock)();
@property (nonatomic, copy) void (^webViewFetchMoreBlock)();

- (void)webViewStartRefresh;
- (void)webViewStartFetchMore;
- (void)webViewEndRefresh;
- (void)webViewEndFetchMore;

- (void)showOtherView;

@end
