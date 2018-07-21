//
//  GCThreadDetailToolBarView.m
//  GuitarChina
//
//  Created by mac on 17/1/13.
//  Copyright © 2017年 陈大捷. All rights reserved.
//

#import "GCThreadDetailToolBarView.h"

@implementation GCThreadDetailToolBarView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self configureView];
    }
    return self;
}

#pragma mark - Private Methods

- (void)configureView {
    [self addSubview:self.pageButton];
    [self addSubview:self.previousPageButton];
    [self addSubview:self.nextPageButton];
    [self addSubview:self.replyView];
    [self addSubview:self.separatorLineView];
}

- (void)pageAction {
    if (self.pageActionBlock) {
        self.pageActionBlock();
    }
}

- (void)backAction {
    if (self.previousPageActionBlock) {
        self.previousPageActionBlock();
    }
}

- (void)forwardAction {
    if (self.nextPageActionBlock) {
        self.nextPageActionBlock();
    }
}

- (void)replyAction {
    if (self.replyActionBlock) {
        self.replyActionBlock();
    }
}

#pragma mark - Getters

- (UIView *)separatorLineView {
    if (!_separatorLineView) {
        _separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
        _separatorLineView.backgroundColor = [GCColor separatorLineColor];
    }
    return _separatorLineView;
}

- (UIButton *)pageButton {
    if (!_pageButton) {
        _pageButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _pageButton.frame = CGRectMake(kScreenWidth / 2 - 40, 0, 80, 40);
        [_pageButton setTitle:@"1" forState:UIControlStateNormal];
        [_pageButton addTarget:self action:@selector(pageAction) forControlEvents:UIControlEventTouchUpInside];
        _pageButton.tintColor = [GCColor grayColor1];
        _pageButton.titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _pageButton;
}

- (UIButton *)previousPageButton {
    if (!_previousPageButton) {
        _previousPageButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _previousPageButton.frame = CGRectMake(kScreenWidth / 2 - 40 - 60, 0, 60, 40);
        [_previousPageButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        _previousPageButton.tintColor = [GCColor grayColor1];
        [_previousPageButton setTitle:@"上一页" forState:UIControlStateNormal];
    }
    return _previousPageButton;
}

- (UIButton *)nextPageButton {
    if (!_nextPageButton) {
        _nextPageButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _nextPageButton.frame = CGRectMake(kScreenWidth / 2 + 40, 0, 60, 40);
        [_nextPageButton addTarget:self action:@selector(forwardAction) forControlEvents:UIControlEventTouchUpInside];
        _nextPageButton.tintColor = [GCColor grayColor1];
        [_nextPageButton setTitle:@"下一页" forState:UIControlStateNormal];
    }
    return _nextPageButton;
}

- (UIView *)replyView {
    if (!_replyView) {
        _replyView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth - 50, 0, 50, 40)];
        
        UIImageView *replyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(14, 9, 22, 22)];
        replyImageView.image = [UIImage imageNamed:@"icon_reply"];
        replyImageView.contentMode = UIViewContentModeScaleAspectFit;
        [_replyView addSubview:replyImageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(replyAction)];
        [_replyView addGestureRecognizer:tap];
    }
    return _replyView;
}

@end
