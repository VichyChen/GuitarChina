//
//  GCThreadDetailView.m
//  GuitarChina
//
//  Created by mac on 15/10/16.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCThreadDetailView.h"
#import "MJRefresh.h"

@interface GCThreadDetailView () <UIPickerViewDataSource, UIPickerViewDelegate, UIScrollViewDelegate>

@end

@implementation GCThreadDetailView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        self.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight);
        [self configureView];
//        [self configureGesture];
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
    self.pickerSelectActionBlock(row + 1);
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

- (void)setPickerViewCount:(NSInteger)pickerViewCount {
    _pickerViewCount = pickerViewCount;
    
    [self.pickerView reloadComponent:0];
}

#pragma mark - Private Methods

- (void)configureView {
    [self addSubview:self.webView];
    [self addSubview:self.pickerContentView];
    [self addSubview:self.toolBarView];
}

- (void)configureGesture {
    UITapGestureRecognizer *gestureRecognizer;
    gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                action:@selector(hidePickerContentView)];
    [self addGestureRecognizer:gestureRecognizer];
}

- (void)hidePickerContentView {
    [UIView animateWithDuration:0.3 animations:^{
        self.pickerContentView.frame = CGRectMake(ScreenWidth / 2 - 140, ScreenHeight - 64, 280, 200);
    }];
}

#pragma mark - Event Response

- (void)beginRefresh {
    self.webViewRefreshBlock();
}

- (void)beginFetchMore {
    self.webViewFetchMoreBlock();
}

- (void)pageAction {
    [UIView animateWithDuration:0.3 animations:^{
        CGFloat height = ScreenHeight - 64;
        if (self.pickerContentView.frame.origin.y == height) {
            self.pickerContentView.frame = CGRectMake(ScreenWidth / 2 - 140, ScreenHeight - 64 - 44 - 200 + 1, 280, 200);
        } else {
            self.pickerContentView.frame = CGRectMake(ScreenWidth / 2 - 140, ScreenHeight - 64, 280, 200);
        }
    }];
    
    if (!self.pageActionBlock) {
        self.pageActionBlock();
    }
}

- (void)backAction {
    if (self.backActionBlock) {
        self.backActionBlock();
    }
}

- (void)forwardAction {
    if (self.forwardActionBlock) {
        self.forwardActionBlock();
    }
}

- (void)scrollTopAction {
    [self.webView.scrollView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
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
        _webView.scrollView.header = ({
            MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(beginRefresh)];
            header.lastUpdatedTimeLabel.hidden = YES;
            header.stateLabel.hidden = YES;
            header;
        });
        _webView.scrollView.footer = ({
            MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(beginFetchMore)];
            footer.automaticallyRefresh = NO;
            footer.refreshingTitleHidden = YES;
            [footer setTitle:NSLocalizedString(@"Load more", nil) forState:MJRefreshStateIdle];
            footer;
        });
    }
    return _webView;
}

- (UIView *)toolBarView {
    if (!_toolBarView) {
        _toolBarView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 64 - 44, ScreenWidth, 44)];
        _toolBarView.backgroundColor = [UIColor whiteColor];
        
        [_toolBarView addSubview:self.pageButton];
        [_toolBarView addSubview:self.backButton];
        [_toolBarView addSubview:self.forwardButton];
        [_toolBarView addSubview:self.scrollTopButton];
        [_toolBarView addSubview:self.separatorLineView];
    }
    return _toolBarView;
}

- (UIView *)separatorLineView {
    if (!_separatorLineView) {
        _separatorLineView = [UIView createHorizontalLine:ScreenWidth originX:0 originY:0 color:[UIColor GCGrayLineColor]];
    }
    return _separatorLineView;
}

- (UIButton *)pageButton {
    if (!_pageButton) {
        _pageButton = [UIView createButton:CGRectMake(ScreenWidth / 2 - 30, 0, 60, 44)
                                      text:@"1"
                                    target:self
                                    action:@selector(pageAction)];
        _pageButton.tintColor = [UIColor GCDeepGrayColor];
    }
    return _pageButton;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIView createButton:CGRectMake(ScreenWidth / 2 - 30 - 44, 0, 44, 44)
                                    target:self
                                    action:@selector(backAction)];
        [_backButton setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
        _backButton.tintColor = [UIColor GCDeepGrayColor];
    }
    return _backButton;
}

- (UIButton *)forwardButton {
    if (!_forwardButton) {
        _forwardButton = [UIView createButton:CGRectMake(ScreenWidth / 2 + 30, 0, 44, 44)
                                       target:self
                                       action:@selector(forwardAction)];
        [_forwardButton setImage:[UIImage imageNamed:@"icon_forward"] forState:UIControlStateNormal];
        _forwardButton.tintColor = [UIColor GCDeepGrayColor];
    }
    return _forwardButton;
}

- (UIButton *)scrollTopButton {
    if (!_scrollTopButton) {
        _scrollTopButton = [UIView createButton:CGRectMake(ScreenWidth - 15 - 44, 0, 44, 44)
                                         target:self
                                         action:@selector(scrollTopAction)];
        [_scrollTopButton setImage:[UIImage imageNamed:@"icon_up"] forState:UIControlStateNormal];
        _scrollTopButton.tintColor = [UIColor GCDeepGrayColor];
    }
    return _scrollTopButton;
}

- (UIView *)pickerContentView {
    if (!_pickerContentView) {
        _pickerContentView = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth / 2 - 140, ScreenHeight - 64, 280, 200)];
        _pickerContentView.backgroundColor = [UIColor whiteColor];
        _pickerContentView.layer.borderColor = [UIColor GCGrayLineColor].CGColor;
        _pickerContentView.layer.borderWidth = 1;
        _pickerContentView.layer.masksToBounds = YES;
        
        [_pickerContentView addSubview:self.goButton];
        [_pickerContentView addSubview:self.pickerView];
    }
    return _pickerContentView;
}

- (UIButton *)goButton {
    if (!_goButton) {
        _goButton = [UIView createButton:CGRectMake(0, 0, 280, 40)
                                    text:@"跳转"
                                  target:self
                                  action:@selector(scrollTopAction)];
        _goButton.tintColor = [UIColor GCDeepGrayColor];
    }
    return _goButton;
}

- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, 280, 80)];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
    }
    return _pickerView;
}

@end
