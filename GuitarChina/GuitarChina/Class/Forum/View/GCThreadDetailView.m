//
//  GCThreadDetailView.m
//  GuitarChina
//
//  Created by mac on 15/10/16.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCThreadDetailView.h"
#import "MJRefresh.h"

@interface GCThreadDetailView ()  <UIPickerViewDataSource, UIPickerViewDelegate, UIScrollViewDelegate>

@end

@implementation GCThreadDetailView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configureView];
    }
    return self;
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.pickerViewCount;
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [NSString stringWithFormat:@"%ld", row + 1];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 35;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self hidePickerContentView];
}

#pragma mark - Public Methods

- (void)webViewStartRefresh {
    [self.webView.scrollView.header beginRefreshing];
}

- (void)webViewStartFetchMore {
    [self.webView.scrollView.header beginRefreshing];
}

- (void)webViewEndRefresh {
    [self.webView.scrollView.header endRefreshing];
}

- (void)webViewEndFetchMore {
    [self.webView.scrollView.footer endRefreshing];
}

#pragma mark - Private Methods

- (void)configureView {
    [self addSubview:self.webView];
//    if (kIsFree) {
//        [self addSubview:self.bannner];
//    }
    [self addSubview:self.pickerContentView];
    [self addSubview:self.toolBarView];
}

- (void)hidePickerContentView {
    [UIView animateWithDuration:0.2 animations:^{
        self.pickerContentView.frame = CGRectMake(0, ScreenHeight - 63 + 1, ScreenWidth, 200);
    }];
}

#pragma mark - Event Responses

- (void)beginRefresh {
    if (self.webViewRefreshBlock) {
        self.webViewRefreshBlock();
    }
}

- (void)beginFetchMore {
    if (self.webViewFetchMoreBlock) {
        self.webViewFetchMoreBlock();
    }
}

- (void)pageAction {
    if ([self.pageButton.titleLabel.text isEqualToString:@"1 / 1"]) {
        return;
    }
    [UIView animateWithDuration:0.2 animations:^{
        CGFloat height = ScreenHeight - 63 + 1;
        if (self.pickerContentView.frame.origin.y == height) {
            self.pickerContentView.frame = CGRectMake(0, ScreenHeight - 63 - 40 - 200, ScreenWidth, 200);
        } else {
            self.pickerContentView.frame = CGRectMake(0, ScreenHeight - 63 + 1, ScreenWidth, 200);
        }
    }];
    
    if (self.pageActionBlock) {
        self.pageActionBlock();
    }
}

- (void)backAction {
    [self hidePickerContentView];
    if (self.previousPageActionBlock) {
        self.previousPageActionBlock();
    }
}

- (void)forwardAction {
    [self hidePickerContentView];
    if (self.nextPageActionBlock) {
        self.nextPageActionBlock();
    }
}

- (void)goAction {
    if (self.goActionBlock) {
        self.goActionBlock([self.pickerView selectedRowInComponent:0] + 1);
    }
}

- (void)replyAction {
    if (self.replyActionBlock) {
        self.replyActionBlock();
    }
}

#pragma mark - Setters

- (void)setPickerViewCount:(NSInteger)pickerViewCount {
    _pickerViewCount = pickerViewCount;
    
    [self.pickerView reloadComponent:0];
}

- (void)setPickerViewIndex:(NSInteger)pickerViewIndex {
    _pickerViewIndex = pickerViewIndex;
    
    [self.pickerView selectRow:pickerViewIndex inComponent:0 animated:YES];
}

#pragma mark - Getters

- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64 - 44)];
        _webView.dataDetectorTypes = UIDataDetectorTypeLink;
        _webView.opaque = NO;
        _webView.backgroundColor = [UIColor clearColor];
        _webView.scrollView.delegate = self;
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
        _webView.scrollView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight);
        @weakify(self);
        _webView.scrollView.headerRefreshing = ^{
            @strongify(self);
            [self beginRefresh];
        };
    }
    return _webView;
}

- (UIView *)toolBarView {
    if (!_toolBarView) {
        _toolBarView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 64 - 40, ScreenWidth, 40)];
        _toolBarView.backgroundColor = [UIColor whiteColor];
        _toolBarView.alpha = 0.0f;
        [_toolBarView addSubview:self.pageButton];
        [_toolBarView addSubview:self.previousPageButton];
        [_toolBarView addSubview:self.nextPageButton];
        [_toolBarView addSubview:self.replyBackgroundView];
        [_toolBarView addSubview:self.replyButton];
        [_toolBarView addSubview:self.separatorLineView];
    }
    return _toolBarView;
}

- (UIView *)separatorLineView {
    if (!_separatorLineView) {
        _separatorLineView = [UIView createHorizontalLine:ScreenWidth originX:0 originY:0 color:[GCColor separatorLineColor]];
    }
    return _separatorLineView;
}

- (UIButton *)pageButton {
    if (!_pageButton) {
        _pageButton = [UIView createButton:CGRectMake(ScreenWidth / 2 - 40, 0, 80, 40)
                                      text:@"1"
                                    target:self
                                    action:@selector(pageAction)];
        _pageButton.tintColor = [GCColor grayColor1];
        _pageButton.titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _pageButton;
}

- (UIButton *)previousPageButton {
    if (!_previousPageButton) {
        _previousPageButton = [UIView createButton:CGRectMake(ScreenWidth / 2 - 40 - 60, 0, 60, 40)
                                    target:self
                                    action:@selector(backAction)];
        _previousPageButton.tintColor = [GCColor grayColor1];
        [_previousPageButton setTitle:NSLocalizedString(@"Prev", nil) forState:UIControlStateNormal];
    }
    return _previousPageButton;
}

- (UIButton *)nextPageButton {
    if (!_nextPageButton) {
        _nextPageButton = [UIView createButton:CGRectMake(ScreenWidth / 2 + 40, 0, 60, 40)
                                       target:self
                                       action:@selector(forwardAction)];
        _nextPageButton.tintColor = [GCColor grayColor1];
        [_nextPageButton setTitle:NSLocalizedString(@"Next", nil) forState:UIControlStateNormal];
    }
    return _nextPageButton;
}

- (UIButton *)replyButton {
    if (!_replyButton) {
        _replyButton = [UIView createButton:CGRectMake(ScreenWidth - 40, 9, 22, 22)
                                         target:self
                                         action:@selector(replyAction)];
        [_replyButton setImage:[[UIImage imageNamed:@"icon_reply"] imageWithTintColor:[GCColor grayColor1]] forState:UIControlStateNormal];
        _replyButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _replyButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _replyButton.contentMode = UIViewContentModeScaleAspectFit;
        _replyButton.tintColor = [GCColor grayColor1];
    }
    return _replyButton;
}

- (UIView *)replyBackgroundView {
    if (!_replyBackgroundView) {
        _replyBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth - 50, 0, 50, 40)];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(replyAction)];
        [_replyBackgroundView addGestureRecognizer:tap];
    }
    return _replyBackgroundView;
}

- (UIView *)pickerContentView {
    if (!_pickerContentView) {
        _pickerContentView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 66 + 1, ScreenWidth, 200)];
        _pickerContentView.backgroundColor = [GCColor cellSelectedColor];
        _pickerContentView.layer.borderColor = [GCColor separatorLineColor].CGColor;
        _pickerContentView.layer.borderWidth = 1;
        _pickerContentView.layer.masksToBounds = YES;
        
        [_pickerContentView addSubview:self.goButton];
        [_pickerContentView addSubview:self.pickerView];
    }
    return _pickerContentView;
}

- (UIButton *)goButton {
    if (!_goButton) {
        _goButton = [UIView createButton:CGRectMake(0, 0, ScreenWidth, 40)
                                    text:NSLocalizedString(@"Go", nil)
                                  target:self
                                  action:@selector(goAction)];
        _goButton.tintColor = [UIColor lightGrayColor];
    }
    return _goButton;
}

- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, ScreenWidth, 160)];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
    }
    return _pickerView;
}

- (GCAdBannerView *)bannner {
    if (!_bannner) {
        _bannner = [[GCAdBannerView alloc] initWithRootViewController:APP.window.rootViewController countDown:15];
        _bannner.alpha = 0.0f;
        _bannner.frame = CGRectMake(0, self.toolBarView.frame.origin.y - 50, ScreenWidth, 50);
    }
    return _bannner;
}

@end
