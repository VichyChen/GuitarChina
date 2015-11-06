//
//  GCLoginViewController.m
//  GuitarChina
//
//  Created by 陈大捷 on 15/9/4.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCLoginViewController.h"
#import "GCLoginView.h"
#import "GCWebViewController.h"
#import "UMSocial.h"

@interface GCLoginViewController () <UMSocialUIDelegate>

@property (nonatomic, strong) GCLoginView *loginView;

@property (nonatomic, copy) void (^loginBlock)();
@property (nonatomic, copy) void (^webLoginBlock)();

@end

@implementation GCLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureView];
    [self configureBlock];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"white.png"] ];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setShadowImage:nil];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
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
    self.navigationItem.rightBarButtonItem = [UIView createCustomBarButtonItem:@"icon_close"
                                                                   normalColor:[UIColor GCDeepGrayColor]
                                                              highlightedColor:[UIColor GCLightGrayColor]
                                                                        target:self
                                                                        action:@selector(closeAction)];
    
    [self.view addSubview:self.loginView];
}

- (void)configureBlock {
    @weakify(self);
    self.loginBlock = ^{
        @strongify(self);
        [[GCNetworkManager manager] postLoginWithUsername:self.loginView.usernameTextField.text password:self.loginView.passwordTextField.text Success:^(GCLoginModel *model) {
            ApplicationDelegate.tabBarController.selectedIndex = 2;
            
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:kGCLOGIN];
            [[NSUserDefaults standardUserDefaults] setObject:model.member_username forKey:kGCLOGINNAME];
            [[NSUserDefaults standardUserDefaults] setObject:model.member_uid forKey:kGCLOGINID];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kGCNOTIFICATION_LOGINSUCCESS object:nil];
            [self closeAction];
            
        } failure:^(NSError *error) {
            
        }];
    };
    
    self.webLoginBlock = ^{
        @strongify(self);
        GCWebViewController *controller = [[GCWebViewController alloc] init];
        controller.title = NSLocalizedString(@"Web Secure Login", nil);
        controller.urlString = GCNETWORKAPI_URL_LOGIN;
        [self.navigationController pushViewController:controller animated:YES];
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
            
//            [UMSocialSnsService presentSnsIconSheetView:self
//                                                 appKey:kUMENG_APPKEY
//                                              shareText:@"你要分享的文字"
//                                             shareImage:[UIImage imageNamed:@"icon.png"]
//                                        shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession,UMShareToQQ,nil]
//                                               delegate:self];
        };
        _loginView.webLoginActionBlock = ^{
            @strongify(self);
            self.webLoginBlock();
        };
        _loginView.usernameTextField.text = @"Vichy_Chen";
        _loginView.passwordTextField.text = @"88436658cdj";
    }
    return _loginView;
}

@end
