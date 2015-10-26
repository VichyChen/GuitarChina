//
//  GCLoginView.h
//  GuitarChina
//
//  Created by mac on 15/10/26.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GCLoginView : UIView

@property (nonatomic, strong) UITextField *usernameTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic,strong) UIButton *loginButton;
@property (nonatomic, copy) void (^loginActionBlock)();

@end
