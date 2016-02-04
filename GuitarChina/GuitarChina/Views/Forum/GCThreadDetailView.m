//
//  GCThreadDetailView.m
//  GuitarChina
//
//  Created by mac on 15/10/16.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCThreadDetailView.h"
#import "MJRefresh.h"
#import "RESideMenu.h"

@interface GCThreadDetailView ()  <UIPickerViewDataSource, UIPickerViewDelegate, UIScrollViewDelegate> {
    NSInteger lastContentOffsetY;
    NSInteger lastPosition;
}

@end

@implementation GCThreadDetailView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configureView];
        [self configureGesture];
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
//    self.pickerSelectActionBlock(row + 1);
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self hidePickerContentView];
//    if (scrollView.contentOffset.y + (ScreenHeight - 64 - 44) >= scrollView.contentSize.height) {
//        [UIView animateWithDuration:0.2 animations:^{
//            self.toolBarView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0.f, 0);
//        }];
//    } else {
//        if (lastContentOffsetY >= scrollView.contentOffset.y) {
//            lastContentOffsetY = scrollView.contentOffset.y;
//            if (lastPosition != 0) {
//                [UIView animateWithDuration:0.2 animations:^{
//                    self.toolBarView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0.f, 0);
//                    lastPosition = 0;
//                }];
//            }
//        } else {
//            NSInteger position = scrollView.contentOffset.y;
//            lastContentOffsetY = position;
//            if (position < 0) {
//                position = 0;
//            }
//            else if (position >= 44) {
//                position = 44;
//            }
//            [UIView animateWithDuration:0.2 animations:^{
//                self.toolBarView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0.f, position);
//            }];
//            lastPosition = -position;
//        }
//    }
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
    [self addSubview:self.pickerContentView];
    [self addSubview:self.toolBarView];
}

- (void)configureGesture {
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFromLeft:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self addGestureRecognizer:recognizer];
    
//        UITapGestureRecognizer *gestureRecognizer;
//        gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
//                                                                    action:@selector(hidePickerContentView)];
//        [self.webView addGestureRecognizer:gestureRecognizer];
}

- (void)hidePickerContentView {
    [UIView animateWithDuration:0.2 animations:^{
        self.pickerContentView.frame = CGRectMake(0, ScreenHeight - 63 + 1, ScreenWidth, 200);
    }];
}

#pragma mark - Event Response

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

- (void)scrollTopAction {
    [self.webView.scrollView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}

-(void)handleSwipeFromLeft:(UISwipeGestureRecognizer *)recognizer{
    if (self.swipeLeftActionBlock) {
        self.swipeLeftActionBlock();
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
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)];
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
            footer.mj_h = 88.0f;
            footer.automaticallyRefresh = NO;
            footer.refreshingTitleHidden = YES;
            [footer setTitle:NSLocalizedString(@"Load more.", nil) forState:MJRefreshStateIdle];
            footer;
        });
    }
    return _webView;
}

- (UIView *)toolBarView {
    if (!_toolBarView) {
        _toolBarView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 64 - 40, ScreenWidth, 40)];
        _toolBarView.backgroundColor = [UIColor GCBackgroundColor];
        _toolBarView.alpha = 0.0f;
        [_toolBarView addSubview:self.pageButton];
        [_toolBarView addSubview:self.previousPageButton];
        [_toolBarView addSubview:self.nextPageButton];
        [_toolBarView addSubview:self.scrollTopButton];
        [_toolBarView addSubview:self.separatorLineView];
    }
    return _toolBarView;
}

- (UIView *)separatorLineView {
    if (!_separatorLineView) {
        _separatorLineView = [UIView createHorizontalLine:ScreenWidth originX:0 originY:0 color:[UIColor GCSeparatorLineColor]];
    }
    return _separatorLineView;
}

- (UIButton *)pageButton {
    if (!_pageButton) {
        _pageButton = [UIView createButton:CGRectMake(ScreenWidth / 2 - 40, 0, 80, 40)
                                      text:@"1"
                                    target:self
                                    action:@selector(pageAction)];
        _pageButton.tintColor = [UIColor GCDarkGrayFontColor];
        _pageButton.titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _pageButton;
}

- (UIButton *)previousPageButton {
    if (!_previousPageButton) {
        _previousPageButton = [UIView createButton:CGRectMake(ScreenWidth / 2 - 40 - 40, 0, 40, 40)
                                    target:self
                                    action:@selector(backAction)];
        [_previousPageButton setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
        _previousPageButton.tintColor = [UIColor GCDarkGrayFontColor];
//        _previousPageButton.backgroundColor = [UIColor whiteColor];
//        _previousPageButton.layer.cornerRadius = 20;
//        _previousPageButton.layer.borderWidth = 1;
//        _previousPageButton.layer.borderColor = [UIColor GCLightGrayFontColor].CGColor;
    }
    return _previousPageButton;
}

- (UIButton *)nextPageButton {
    if (!_nextPageButton) {
        _nextPageButton = [UIView createButton:CGRectMake(ScreenWidth / 2 + 40, 0, 40, 40)
                                       target:self
                                       action:@selector(forwardAction)];
        [_nextPageButton setImage:[UIImage imageNamed:@"icon_forward"] forState:UIControlStateNormal];
        _nextPageButton.tintColor = [UIColor GCDarkGrayFontColor];
//        _nextPageButton.backgroundColor = [UIColor whiteColor];
//        _nextPageButton.layer.cornerRadius = 20;
//        _nextPageButton.layer.borderWidth = 1;
//        _nextPageButton.layer.borderColor = [UIColor GCLightGrayFontColor].CGColor;
    }
    return _nextPageButton;
}

- (UIButton *)scrollTopButton {
    if (!_scrollTopButton) {
        _scrollTopButton = [UIView createButton:CGRectMake(ScreenWidth - 15 - 40, 0, 40, 40)
                                         target:self
                                         action:@selector(scrollTopAction)];
        [_scrollTopButton setImage:[[UIImage imageNamed:@"icon_upArrow"] imageWithTintColor:[UIColor GCDarkGrayFontColor]] forState:UIControlStateNormal];
        _scrollTopButton.tintColor = [UIColor GCDarkGrayFontColor];
//        _scrollTopButton.backgroundColor = [UIColor whiteColor];
//        _scrollTopButton.layer.cornerRadius = 20;
//        _scrollTopButton.layer.borderWidth = 1;
//        _scrollTopButton.layer.borderColor = [UIColor GCLightGrayFontColor].CGColor;
    }
    return _scrollTopButton;
}

- (UIView *)pickerContentView {
    if (!_pickerContentView) {
        _pickerContentView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 66 + 1, ScreenWidth, 200)];
        _pickerContentView.backgroundColor = [UIColor whiteColor];
        _pickerContentView.layer.borderColor = [UIColor GCSeparatorLineColor].CGColor;
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
                                    text:@"跳转"
                                  target:self
                                  action:@selector(goAction)];
        _goButton.tintColor = [UIColor GCDarkGrayFontColor];
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

@end
