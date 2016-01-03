
//
//  GCLoginViewController.m
//  GuitarChina
//
//  Created by 陈大捷 on 15/9/4.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCLoginViewController.h"
#import "GCWebViewController.h"

@interface GCLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *seccodeVerifyTextField;
@property (weak, nonatomic) IBOutlet UIImageView *seccodeVerifyImageView;
- (IBAction)loginAction:(UIButton *)sender;
- (IBAction)refreshSeccodeVerifyAction:(UITapGestureRecognizer *)sender;


@property (nonatomic, copy) void (^getLoginWebBlock)();
@property (nonatomic, copy) void (^getSeccodeVerifyImageBlock)(NSString *seccode);
@property (nonatomic, copy) void (^loginBlock)();
@property (nonatomic, copy) void (^webLoginBlock)();

@property (nonatomic, copy) NSString *seccode;
@property (nonatomic, copy) NSString *formhash;
@property (nonatomic, copy) NSString *postURL;

@end

@implementation GCLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureView];
    [self configureBlock];
    
    self.usernameTextField.text = @"Vichy_Chen";
    self.passwordTextField.text = @"88436658cdj";
    
    self.getLoginWebBlock();
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
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
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.navigationItem.rightBarButtonItem = [UIView createCustomBarButtonItem:@"icon_delete"
                                                                   normalColor:[UIColor GCDeepGrayColor]
                                                              highlightedColor:[UIColor GCLightGrayColor]
                                                                        target:self
                                                                        action:@selector(closeAction)];
    
}

- (void)configureBlock {
    @weakify(self);
    //    self.loginBlock = ^{
    //        @strongify(self);
    //        self.loginView.loginButton.enabled = NO;
    //        [[GCNetworkManager manager] postLoginWithUsername:self.loginView.usernameTextField.text password:self.loginView.passwordTextField.text Success:^(GCLoginModel *model) {
    //            if ([model.message.messageval isEqualToString:@"login_succeed"]) {
    //                ApplicationDelegate.tabBarController.selectedIndex = 2;
    //
    //                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:kGCLOGIN];
    //                [[NSUserDefaults standardUserDefaults] setObject:model.member_uid forKey:kGCLOGINID];
    //                [[NSUserDefaults standardUserDefaults] setObject:model.member_username forKey:kGCLOGINNAME];
    //                [[NSUserDefaults standardUserDefaults] setObject:model.member_level forKey:kGCLOGINLEVEL];
    //                [[NSUserDefaults standardUserDefaults] synchronize];
    //
    //                [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Login Success", nil)];
    //                [[NSNotificationCenter defaultCenter] postNotificationName:kGCNOTIFICATION_LOGINSUCCESS object:nil];
    //                [self closeAction];
    //            } else if ([model.message.messageval isEqualToString:@"login_invalid"]) {
    //                [SVProgressHUD showErrorWithStatus:model.message.messagestr];
    //            }
    //            self.loginView.loginButton.enabled = YES;
    //        } failure:^(NSError *error) {
    //            self.loginView.loginButton.enabled = YES;
    //            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"No network connection!", nil)];
    //        }];
    //    };
    
    self.getLoginWebBlock = ^{
        @strongify(self);
        [[GCNetworkManager manager] getLoginWebSuccess:^(NSString *seccode, NSString *formhash, NSString *postURL) {
            self.seccode = seccode;
            self.formhash = formhash;
            self.postURL = postURL;
            self.getSeccodeVerifyImageBlock(seccode);
        } failure:^(NSError *error) {
            
        }];
    };
    
    self.getSeccodeVerifyImageBlock = ^(NSString *seccode) {
        @strongify(self);
        [[GCNetworkManager manager] getSeccodeVerifyImage:self.seccode success:^(NSString *image) {
            
            [[GCNetworkManager manager] downloadSeccodeVerifyImageWithURL:image success:^(UIImage *image) {
                
                self.seccodeVerifyImageView.image = image;
                
            } failure:^(NSError *error) {
                
            }];
            
        } failure:^(NSError *error) {
            
        }];
    };
    
    self.loginBlock = ^{
        @strongify(self);
        [[GCNetworkManager manager] postLoginWithUsername:self.usernameTextField.text
                                                 password:self.passwordTextField.text
                                           fastloginfield:@"username"
                                            seccodeverify:self.seccodeVerifyTextField.text
                                               questionid:@"0"
                                                   answer:@""
                                              seccodehash:self.seccode
                                                 formhash:self.formhash
                                                  postURL:self.postURL
                                                  success:^(NSString *html) {
                                                      
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

//- (GCLoginView *)loginView {
//    if (!_loginView) {
//        _loginView = [[GCLoginView alloc] initWithFrame:CGRectMake(0, 20, ScreenWidth, ScreenHeight)];
//        @weakify(self);
//        _loginView.loginActionBlock = ^{
//            @strongify(self);
//            self.loginBlock();
//
//
//            //            NSArray* activities = @[ [CustomActivety new] ];
//            //            UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:nil applicationActivities:activities];
//            //
//            //            [self presentViewController:activityVC animated:YES completion:nil];
//        };
//        _loginView.webLoginActionBlock = ^{
//            @strongify(self);
//            self.webLoginBlock();
//        };
//        _loginView.usernameTextField.text = @"Vichy_Chen";
//        _loginView.passwordTextField.text = @"88436658cdj";
//    }
//    return _loginView;
//}

- (IBAction)loginAction:(UIButton *)sender {
    self.loginBlock();
}

- (IBAction)refreshSeccodeVerifyAction:(UITapGestureRecognizer *)sender {
    self.getSeccodeVerifyImageBlock(self.seccode);
}

@end

