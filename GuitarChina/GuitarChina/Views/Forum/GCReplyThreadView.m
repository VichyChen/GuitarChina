//
//  GCReplyThreadView.m
//  GuitarChina
//
//  Created by mac on 15/10/26.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCReplyThreadView.h"

@interface GCReplyThreadView() <UITextViewDelegate>

@end

@implementation GCReplyThreadView

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
    [self addSubview:self.placeholderLabel];
    [self addSubview:self.textView];
}

- (void)configureFrame {
    self.textView.frame = CGRectMake(10, 10, ScreenWidth - 20, ScreenWidth - 20);
    self.placeholderLabel.frame = CGRectMake(15, 17, 200, 20);
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self textViewChange];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [self textViewChange];
}

- (void)textViewDidChange:(UITextView *)textView {
    [self textViewChange];
}

#pragma mark - Event Responses

#pragma mark - Private Methods

- (void)textViewChange {
    if ([self.textView.text isEqualToString:@""]) {
        self.placeholderLabel.hidden = NO;
    } else {
        self.placeholderLabel.hidden = YES;
    }
}

#pragma mark - Getters

- (UITextView *)textView {
    if (!_textView) {
        _textView = [UIView createTextView:CGRectZero];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.font = [UIFont systemFontOfSize:16];
        _textView.delegate = self;
    }
    return _textView;
}

- (UILabel *)placeholderLabel {
    if (!_placeholderLabel) {
        _placeholderLabel = [UIView createLabel:CGRectZero
                                           text:NSLocalizedString(@"Write reply.", nil)
                                           font:[UIFont systemFontOfSize:16] textColor:[UIColor GCDeepGrayColor]];
    }
    return _placeholderLabel;
}

@end