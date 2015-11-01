//
//  GCLoginView.h
//  GuitarChina
//
//  Created by mac on 15/10/26.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GCLoginView : UIView

@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UITextField *usernameTextField;
@property (nonatomic, strong) UIView *separatorFirstLineView;
@property (nonatomic, strong) UILabel *passwordLabel;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UIView *separatorSecondLineView;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, copy) void (^loginActionBlock)();

@property (nonatomic, strong) UIButton *webLoginButton;
@property (nonatomic, strong) UILabel *descriptLabel;
@property (nonatomic, copy) void (^webLoginActionBlock)();

@end
