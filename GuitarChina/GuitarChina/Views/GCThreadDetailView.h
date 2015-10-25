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

@property (nonatomic, strong) UIView *toolBarView;
@property (nonatomic, strong) UIView *separatorLineView;
@property (nonatomic, strong) UIButton *pageButton;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *forwardButton;
@property (nonatomic, strong) UIButton *scrollTopButton;

@property (nonatomic, strong) UIView *pickerContentView;
@property (nonatomic, strong) UIButton *goButton;
@property (nonatomic, strong) UIPickerView *pickerView;


@property (nonatomic, copy) void (^webViewRefreshBlock)();
@property (nonatomic, copy) void (^webViewFetchMoreBlock)();

- (void)webViewStartRefresh;
- (void)webViewStartFetchMore;
- (void)webViewEndRefresh;
- (void)webViewEndFetchMore;

@property (nonatomic, copy) void (^pageActionBlock)();
@property (nonatomic, copy) void (^backActionBlock)();
@property (nonatomic, copy) void (^forwardActionBlock)();


@end
