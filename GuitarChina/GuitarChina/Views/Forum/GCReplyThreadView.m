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
//    [self addSubview:self.avatarImage];
//    [self addSubview:self.userLabel];
//    [self addSubview:self.separatorLineView];
    [self addSubview:self.placeholderLabel];
    [self addSubview:self.textView];
}

- (void)configureFrame {
//    self.avatarImage.frame = CGRectMake(10, 10, 30, 30);
//    self.userLabel.frame = CGRectMake(50, 10, ScreenWidth - 55, 30);
//    self.separatorLineView.frame = CGRectMake(10, 50, ScreenWidth - 20, 0.5);
    self.textView.frame = CGRectMake(10, 10, ScreenWidth - 20, ScreenHeight - 64 - 65);
    self.placeholderLabel.frame = CGRectMake(15, 18, 200, 20);
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

- (UIImageView *)avatarImage {
    if (!_avatarImage) {
        _avatarImage = [UIView createImageView:CGRectZero
                                   contentMode:UIViewContentModeScaleAspectFit];
        _avatarImage.layer.cornerRadius = 5;
        _avatarImage.layer.masksToBounds = YES;
        _avatarImage.backgroundColor = [UIColor GCLightGrayFontColor];
        [_avatarImage sd_setImageWithURL:[NSURL URLWithString:GCNETWORKAPI_URL_BIGAVTARIMAGE([[NSUserDefaults standardUserDefaults] stringForKey:kGCLOGINID])]
                            placeholderImage:nil
                                     options:SDWebImageRetryFailed];
    }
    return _avatarImage;
}

- (UILabel *)userLabel {
    if (!_userLabel) {
        _userLabel = [UIView createLabel:CGRectZero
                                    text:[[NSUserDefaults standardUserDefaults] stringForKey:kGCLOGINNAME]
                                    font:[UIFont boldSystemFontOfSize:16]
                               textColor:[UIColor GCBlueColor]];
    }
    return _userLabel;
}

- (UIView *)separatorLineView {
    if (!_separatorLineView) {
        _separatorLineView = [[UIView alloc] initWithFrame:CGRectZero];
        _separatorLineView.backgroundColor = [UIColor GCSeparatorLineColor];
    }
    return _separatorLineView;
}

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
                                           font:[UIFont systemFontOfSize:16] textColor:[UIColor GCLightGrayFontColor]];
    }
    return _placeholderLabel;
}

@end
