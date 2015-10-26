//
//  GCLoginViewController.m
//  GuitarChina
//
//  Created by 陈大捷 on 15/9/4.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCLoginViewController.h"
#import "GCLoginView.h"

@interface GCLoginViewController ()

@property (nonatomic, strong) GCLoginView *loginView;

@property (nonatomic, copy) void (^loginBlock)();

@end

@implementation GCLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureView];
    [self configureBlock];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private Methods

- (void)configureView {
    [self.view addSubview:self.loginView];
}

- (void)configureBlock {
    @weakify(self);
    self.loginBlock = ^{
        @strongify(self);
        [[GCNetworkManager manager] postLoginWithUsername:self.loginView.usernameTextField.text password:self.loginView.passwordTextField.text Success:^(GCLoginModel *model) {
            
        } failure:^(NSError *error) {
            
        }];
    };
}

#pragma mark - Getters

- (GCLoginView *)loginView {
    if (!_loginView) {
        _loginView = [[GCLoginView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        @weakify(self);
        _loginView.loginActionBlock = ^{
            @strongify(self);
            self.loginBlock();
        };
    }
    return _loginView;
}

@end
