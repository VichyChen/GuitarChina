//
//  GCReportThreadView.m
//  GuitarChina
//
//  Created by mac on 15/11/2.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCReportThreadView.h"

@interface GCReportThreadView() <UITextViewDelegate>

@end

@implementation GCReportThreadView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self configureView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self configureFrame];
}

- (void)configureView {
    [self addSubview:self.textView];
}

- (void)configureFrame {
    self.textView.frame = CGRectMake(5, 10, kScreenWidth - 10, kScreenHeight - 20);
}

#pragma mark - Getters

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.font = [UIFont systemFontOfSize:16];
        _textView.placeholder = @"输入举报内容。";
        _textView.delegate = self;
    }
    return _textView;
}

@end
