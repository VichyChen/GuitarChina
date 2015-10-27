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
    
    [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"white.png"] ];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    
    self.navigationItem.rightBarButtonItem = [UIView createCustomBarButtonItem:@"icon_close"
                                                                  normalColor:[UIColor GCDeepGrayColor]
                                                             highlightedColor:[UIColor GCLightGrayColor]
                                                                       target:self
                                                                       action:@selector(closeAction)];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Event Response

- (void)closeAction {
    [self dismissViewControllerAnimated:YES completion:nil];
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
            ApplicationDelegate.tabBarController.selectedIndex = 2;
            [self closeAction];
            
        } failure:^(NSError *error) {
            
        }];
    };
}

#pragma mark - Getters

- (GCLoginView *)loginView {
    if (!_loginView) {
        _loginView = [[GCLoginView alloc] initWithFrame:CGRectMake(0, 20, ScreenWidth, ScreenHeight)];
        @weakify(self);
        _loginView.loginActionBlock = ^{
            @strongify(self);
            self.loginBlock();
        };
        _loginView.usernameTextField.text = @"Vichy_Chen";
        _loginView.passwordTextField.text = @"88436658cdj";
    }
    return _loginView;
}

@end
