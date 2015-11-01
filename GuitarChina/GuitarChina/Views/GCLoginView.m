//
//  GCLoginView.m
//  GuitarChina
//
//  Created by mac on 15/10/26.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCLoginView.h"

#define CurrentScreenWidth (ScreenWidth - 60)

@interface GCLoginView()

@end

@implementation GCLoginView

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
    [self addSubview:self.logoImageView];
    [self addSubview:self.usernameLabel];
    [self addSubview:self.usernameTextField];
    [self addSubview:self.separatorFirstLineView];
    [self addSubview:self.passwordLabel];
    [self addSubview:self.passwordTextField];
    [self addSubview:self.separatorSecondLineView];
    [self addSubview:self.loginButton];
    [self addSubview:self.webLoginButton];
    [self addSubview:self.descriptLabel];
}

- (void)configureFrame {
    self.logoImageView.frame = CGRectMake(ScreenWidth / 2 - 50, 70, 100, 100);
    self.usernameLabel.frame = CGRectMake(30, 190, CurrentScreenWidth * 0.33, 44);
    self.usernameTextField.frame = CGRectMake(30 + CurrentScreenWidth * 0.33 + 10, 190, CurrentScreenWidth * 0.66, 44);
    self.separatorFirstLineView.frame = CGRectMake(30, 235, CurrentScreenWidth, 1);
    self.passwordLabel.frame = CGRectMake(30, 255, CurrentScreenWidth * 0.33, 44);
    self.passwordTextField.frame = CGRectMake(30 + CurrentScreenWidth * 0.33 + 10, 255, CurrentScreenWidth * 0.66, 44);
    self.separatorSecondLineView.frame = CGRectMake(30, 300, CurrentScreenWidth, 1);
    self.loginButton.frame = CGRectMake(30, 330, CurrentScreenWidth, 44);
    self.webLoginButton.frame = CGRectMake(25, 410, ScreenWidth - 50, 40);
    self.descriptLabel.frame = CGRectMake(25, 450, ScreenWidth - 50, 50);
}

#pragma mark - Event Responses

- (void)loginAction {
    self.loginActionBlock();
}

- (void)webLoginAction {
    self.webLoginActionBlock();
}

#pragma mark - Getters

- (UIImageView *)logoImageView {
    if (!_logoImageView) {
        _logoImageView = [UIView createImageView:CGRectZero
                                           image:[UIImage imageNamed:@"logo_big.jpg"]
                                     contentMode:UIViewContentModeScaleAspectFit];
    }
    return _logoImageView;
}
   
- (UILabel *)usernameLabel {
    if (!_usernameLabel) {
        _usernameLabel = [UIView createLabel:CGRectZero
                                        text:NSLocalizedString(@"Username", nil)
                                        font:[UIFont systemFontOfSize:16]
                                   textColor:[UIColor GCDeepGrayColor]];
    }
    return _usernameLabel;
}

- (UITextField *)usernameTextField {
    if (!_usernameTextField) {
        _usernameTextField = [UIView createTextField:CGRectZero
                                         borderStyle:UITextBorderStyleNone
                                         placeholder:NSLocalizedString(@"Enter the username.", nil)];
    }
    return _usernameTextField;
}

- (UIView *)separatorFirstLineView {
    if (!_separatorFirstLineView) {
        _separatorFirstLineView = [[UIView alloc] initWithFrame:CGRectZero];
        _separatorFirstLineView.backgroundColor = [UIColor GCGrayLineColor];
    }
    return _separatorFirstLineView;
}

- (UILabel *)passwordLabel {
    if (!_passwordLabel) {
        _passwordLabel = [UIView createLabel:CGRectZero
                                        text:NSLocalizedString(@"Password", nil)
                                        font:[UIFont systemFontOfSize:16]
                                   textColor:[UIColor GCDeepGrayColor]];
    }
    return _passwordLabel;
}

- (UITextField *)passwordTextField {
    if (!_passwordTextField) {
        _passwordTextField = [UIView createTextField:CGRectZero
                                         borderStyle:UITextBorderStyleNone
                                         placeholder:NSLocalizedString(@"Enter the password.", nil)];
        _passwordTextField.secureTextEntry = YES;
    }
    return _passwordTextField;
}

- (UIView *)separatorSecondLineView {
    if (!_separatorSecondLineView) {
        _separatorSecondLineView = [[UIView alloc] initWithFrame:CGRectZero];
        _separatorSecondLineView.backgroundColor = [UIColor GCGrayLineColor];
    }
    return _separatorSecondLineView;
}

- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [UIView createButton:CGRectZero
                                       text:NSLocalizedString(@"Login", nil)
                                     target:self
                                     action:@selector(loginAction)];
        _loginButton.backgroundColor = [UIColor GCRedColor];
        _loginButton.tintColor = [UIColor whiteColor];
        _loginButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        _loginButton.layer.cornerRadius = 5;
    }
    return _loginButton;
}
//点击这里先通过网页登陆
- (UIButton *)webLoginButton {
    if (!_webLoginButton) {
        _webLoginButton = [UIView createButton:CGRectZero
                                       text:NSLocalizedString(@"有安全提问的账号？先点击这里登陆。", nil)
                                     target:self
                                     action:@selector(webLoginAction)];
        _webLoginButton.tintColor = [UIColor GCBlueColor];
        _webLoginButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        _webLoginButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _webLoginButton;
}

- (UILabel *)descriptLabel {
    if (!_descriptLabel) {
        _descriptLabel = [UIView createLabel:CGRectZero
                                        text:NSLocalizedString(@"＊设置了安全提问的账号先通过网页登陆，登陆成功后返回到该页面再次进行登陆，即可登陆成功。", nil)
                                        font:[UIFont systemFontOfSize:13]
                                   textColor:[UIColor GCDeepGrayColor]
                               numberOfLines:0
                     preferredMaxLayoutWidth:ScreenWidth - 50];
        
    }
    return _descriptLabel;
}

@end
