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
@property (nonatomic, copy) void (^pageActionBlock)();

@property (nonatomic, strong) UIButton *previousPageButton;
@property (nonatomic, copy) void (^previousPageActionBlock)();

@property (nonatomic, strong) UIButton *nextPageButton;
@property (nonatomic, copy) void (^nextPageActionBlock)();

@property (nonatomic, strong) UIButton *replyButton;
@property (nonatomic, strong) UIView *replyBackgroundView;
@property (nonatomic, copy) void (^replyActionBlock)();

@property (nonatomic, strong) UIView *pickerContentView;

@property (nonatomic, strong) UIButton *goButton;
@property (nonatomic, copy) void (^goActionBlock)(NSInteger page);

@property (nonatomic, strong) UIPickerView *pickerView;


@property (nonatomic, copy) void (^webViewRefreshBlock)();
@property (nonatomic, copy) void (^webViewFetchMoreBlock)();

- (void)webViewStartRefresh;
- (void)webViewStartFetchMore;
- (void)webViewEndRefresh;
- (void)webViewEndFetchMore;

@property (nonatomic, assign) NSInteger pickerViewCount;
@property (nonatomic, assign) NSInteger pickerViewIndex;

@property (nonatomic, copy) void (^swipeLeftActionBlock)();

@end
