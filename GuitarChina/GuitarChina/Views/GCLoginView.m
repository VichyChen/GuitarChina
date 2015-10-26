//
//  GCLoginView.m
//  GuitarChina
//
//  Created by mac on 15/10/26.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCLoginView.h"

@interface GCLoginView()

@end

@implementation GCLoginView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configureView];
    }
    return self;
}

- (void)configureView {
    [self addSubview:self.usernameTextField];
    [self addSubview:self.passwordTextField];
    [self addSubview:self.loginButton];
}

#pragma mark - Event Responses

- (void)loginAction {
    self.loginActionBlock();
}

#pragma mark - Getters

- (UITextField *)usernameTextField {
    if (!_usernameTextField) {
        _usernameTextField = [UIView createTextField:CGRectMake(0, 0, 0, 0)
                                         borderStyle:UITextBorderStyleNone];
    }
    return _usernameTextField;
}

- (UITextField *)passwordTextField {
    if (!_passwordTextField) {
        _passwordTextField = [UIView createTextField:CGRectMake(0, 0, 0, 0)
                                         borderStyle:UITextBorderStyleNone];
        _passwordTextField.secureTextEntry = YES;
    }
    return _passwordTextField;
}

- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [UIView createButton:CGRectMake(0, 0, 0, 0)
                                       text:@"登陆"
                                     target:self
                                     action:@selector(loginAction)];
    }
    return _loginButton;
}

@end
