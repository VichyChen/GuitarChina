
//
//  GCLoginViewController.m
//  GuitarChina
//
//  Created by 陈大捷 on 15/9/4.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCLoginViewController.h"
#import "GCWebViewController.h"
#import "GCHTMLParse.h"

@interface GCLoginViewController () <UIScrollViewDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UILabel *questionTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *answerLabel;
@property (weak, nonatomic) IBOutlet UITextField *answerTextField;

@property (weak, nonatomic) IBOutlet UIView *answerBottomSeparatorView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *answerRowHeight;

@property (weak, nonatomic) IBOutlet UILabel *seccodeVerifyLabel;
@property (weak, nonatomic) IBOutlet UITextField *seccodeVerifyTextField;
@property (weak, nonatomic) IBOutlet UIImageView *seccodeVerifyImageView;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIView *pickerBackgroundView;

- (IBAction)selectedPickerViewCompleteAction:(UIButton *)sender;
- (IBAction)loginAction:(UIButton *)sender;
- (IBAction)closeAction:(UIButton *)sender;
- (IBAction)refreshSeccodeVerifyAction:(UITapGestureRecognizer *)sender;
- (IBAction)backgroundClickAction:(UITapGestureRecognizer *)sender;
- (IBAction)showQuestionAction:(UITapGestureRecognizer *)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollviewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentOriginY;

@property (nonatomic, copy) void (^getLoginWebBlock)();
@property (nonatomic, copy) void (^getSeccodeVerifyImageBlock)(NSString *seccode);
@property (nonatomic, copy) void (^loginBlock)();
@property (nonatomic, copy) void (^webLoginBlock)();

@property (nonatomic, copy) NSString *seccode;
@property (nonatomic, copy) NSString *formhash;
@property (nonatomic, copy) NSString *postURL;
@property (nonatomic, assign) NSInteger questionIndex;
@property (nonatomic, strong) NSArray *questionArray;

@end

@implementation GCLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [Util clearCookie];
    
    [NSUD setObject:@"0" forKey:kGCLogin];
    [NSUD setObject:@"" forKey:kGCLoginName];
    [NSUD synchronize];
    
    [self configureView];
    [self configureColor];
    [self configureBlock];
    
    //    self.usernameTextField.text = @"Vichy_Chen";
    //    self.passwordTextField.text = @"88436658cdj";
    //    self.answerTextField.text = @"汕头";
    
    self.getLoginWebBlock();
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    //4,4s
    if (ScreenHeight == 480) {
        self.scrollviewHeight.constant = 568;
    } else {
        self.scrollviewHeight.constant = ScreenHeight + 1;
        self.contentOriginY.constant = 100;
    }
    if (iPhone) {
        //iphone
        self.contentWidth.constant = ScreenWidth - 30;
    } else {
        //ipad
        self.contentWidth.constant = 414;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)dealloc {
    NSLog(@"dealloc");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
}

#pragma mark - UITextFieldDelegate

//- (void)textFieldDidChange:(UITextView *)textView {
//
//}
//
//- (void)textViewDidBeginEditing:(UITextView *)textView {
//    if (self.usernameTextField.text.length == 0 ||
//        self.passwordTextField.text.length == 0 ||
//        self.answerTextField.text.length == 0 ||
//        self.seccodeVerifyTextField.text.length == 0) {
//        self.loginButton.enabled = NO;
//    } else {
//        self.loginButton.enabled = YES;
//    }
//}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.questionArray.count;
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.questionArray objectAtIndex:row];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 35;
}

#pragma mark - Event Responses

- (void)closeAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)loginAction:(UIButton *)sender {
    self.loginBlock();
}

- (IBAction)closeAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)refreshSeccodeVerifyAction:(UITapGestureRecognizer *)sender {
    self.getSeccodeVerifyImageBlock(self.seccode);
}

- (IBAction)backgroundClickAction:(UITapGestureRecognizer *)sender {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [UIView animateWithDuration:0.5 animations:^{
        self.pickerBackgroundView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 240);
    }];
}

- (IBAction)showQuestionAction:(UITapGestureRecognizer *)sender {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [UIView animateWithDuration:0.3 animations:^{
        self.pickerBackgroundView.frame = CGRectMake(0, ScreenHeight - 240, ScreenWidth, 240);
    }];
}

- (IBAction)selectedPickerViewCompleteAction:(UIButton *)sender {
    NSInteger index = [self.pickerView selectedRowInComponent:0];
    if (index == 0) {
        [self hideAnswer];
        self.answerTextField.text = @"";
    } else {
        [self showAnswer];
    }
    self.questionIndex = index;
    self.questionTextLabel.text = [self.questionArray objectAtIndex:[self.pickerView selectedRowInComponent:0]];
    [UIView animateWithDuration:0.3 animations:^{
        self.pickerBackgroundView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 240);
    }];
    [self textFieldValueChange:nil];
}

- (void)textFieldValueChange:(UITextField *)textField {
    if (self.usernameTextField.text.length > 0 &&
        self.passwordTextField.text.length > 0 &&
        self.seccodeVerifyTextField.text.length > 0 &&
        (self.questionIndex == 0 ? YES : self.answerTextField.text.length > 0)) {
        self.loginButton.enabled = YES;
    } else {
        self.loginButton.enabled = NO;
    }
}

#pragma mark - Private Methods

- (void)configureView {
    
    [self.usernameTextField addTarget:self action:@selector(textFieldValueChange:) forControlEvents:UIControlEventEditingChanged];
    [self.passwordTextField addTarget:self action:@selector(textFieldValueChange:) forControlEvents:UIControlEventEditingChanged];
    [self.answerTextField addTarget:self action:@selector(textFieldValueChange:) forControlEvents:UIControlEventEditingChanged];
    [self.seccodeVerifyTextField addTarget:self action:@selector(textFieldValueChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [UIView createCustomBarButtonItem:@"icon_delete"
                                                                   normalColor:[UIColor GCLightGrayFontColor]
                                                              highlightedColor:[UIColor GCLightGrayFontColor]
                                                                        target:self
                                                                        action:@selector(closeAction)];
    
}

- (void)configureBlock {
    @weakify(self);
    //    self.loginBlock = ^{
    //        @strongify(self);
    //        self.loginView.loginButton.enabled = NO;
    //        [GCNetworkManager postLoginWithUsername:self.loginView.usernameTextField.text password:self.loginView.passwordTextField.text Success:^(GCLoginModel *model) {
    //            if ([model.message.messageval isEqualToString:@"login_succeed"]) {
    //                APP.tabBarController.selectedIndex = 2;
    //
    //                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:kGCLogin];
    //                [[NSUserDefaults standardUserDefaults] setObject:model.member_uid forKey:GCLoginID];
    //                [[NSUserDefaults standardUserDefaults] setObject:model.member_username forKey:kGCLoginName];
    //                [[NSUserDefaults standardUserDefaults] setObject:model.member_level forKey:kGCLoginLevel];
    //                [[NSUserDefaults standardUserDefaults] synchronize];
    //
    //                [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Login Success", nil)];
    //                [[NSNotificationCenter defaultCenter] postNotificationName:kGCNotificationLoginSuccess object:nil];
    //                [self closeAction];
    //            } else if ([model.message.messageval isEqualToString:@"login_invalid"]) {
    //                [SVProgressHUD showErrorWithStatus:model.message.messagestr];
    //            }
    //            self.loginView.loginButton.enabled = YES;
    //        } failure:^(NSError *error) {
    //            self.loginView.loginButton.enabled = YES;
    //            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"No Network Connection", nil)];
    //        }];
    //    };
    
    self.getLoginWebBlock = ^{
        @strongify(self);
        [GCNetworkManager getLoginWebSuccess:^(NSData *htmlData) {
            [GCHTMLParse parseLoginWeb:htmlData result:^(NSString *seccode, NSString *formhash, NSString *postURL, NSArray *questionArray) {
                self.seccode = seccode;
                self.formhash = formhash;
                self.postURL = postURL;
                self.questionArray = questionArray;
                [self.pickerView reloadAllComponents];
                
                self.getSeccodeVerifyImageBlock(seccode);
            }];
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"No Network Connection", nil)];
        }];
    };
    
    self.getSeccodeVerifyImageBlock = ^(NSString *seccode) {
        @strongify(self);
        [GCNetworkManager getSeccodeVerifyImage:self.seccode success:^(NSData *htmlData) {
            
            NSString *image = [GCHTMLParse parseSeccodeVerifyImage:htmlData];
            [GCNetworkManager downloadSeccodeVerifyImageWithURL:image success:^(UIImage *image) {
                self.seccodeVerifyImageView.image = image;
            } failure:^(NSError *error) {
                [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"No Network Connection", nil)];
            }];
            
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"No Network Connection", nil)];
        }];
    };
    
    self.loginBlock = ^{
        @strongify(self);
        
        NSString *fastLoginType = [self.usernameTextField.text containString:@"@"] ? @"email" : @"username";
        [GCNetworkManager postLoginWithUsername:self.usernameTextField.text password:self.passwordTextField.text fastloginfield:fastLoginType seccodeverify:self.seccodeVerifyTextField.text questionid:[NSString stringWithFormat:@"%ld", (long)self.questionIndex] answer:self.answerTextField.text seccodehash:self.seccode formhash:self.formhash postURL:self.postURL success:^(NSString *html) {
            NSLog(@"%@", html);
            if ([html rangeOfString:@"现在将转入登录前页面"].location != NSNotFound && ([html rangeOfString:@"点击此链接进行跳转"].location != NSNotFound || [html rangeOfString:@"如果您的浏览器没有自动跳转，请点击此链接"].location != NSNotFound)) {
                NSLog(@"login success");
                APP.tabBarController.selectedIndex = 2;
                [NSUD setObject:@"1" forKey:kGCLogin];
                //                                                          [NSUD setObject:model.member_uid forKey:GCLoginID];
                [NSUD setObject:self.usernameTextField.text forKey:kGCLoginName];
                //                                                          [NSUD setObject:model.member_level forKey:kGCLoginLevel];
                [NSUD synchronize];
                
                [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Login Success", nil)];
                [[NSNotificationCenter defaultCenter] postNotificationName:kGCNotificationLoginSuccess object:nil];
                [self closeAction];
                
            } else if ([html rangeOfString:@"抱歉，验证码填写错误"].location != NSNotFound) {
                [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"SecCode Error", nil)];
                //                self.seccodeVerifyTextField.text = @"";
                NSLog(@"seccodeverify error");
                //                self.getSeccodeVerifyImageBlock(self.seccode);
            } else if ([html rangeOfString:@"登录失败，您还可以尝试"].location != NSNotFound) {
                [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Password Error", nil)];
                NSLog(@"password error");
            } else if ([html rangeOfString:@"请选择安全提问以及填写正确的答案"].location != NSNotFound) {
                [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Question or Answer Error", nil)];
                NSLog(@"Question or Answer Error");
            } else if ([html rangeOfString:@"密码错误次数过多，请 15 分钟后重新登录"].location != NSNotFound) {
                [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Login after 15 minute", nil)];
                NSLog(@"Login after 15 minute");
            } else {
                [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Other Error", nil)];
                NSLog(@"other error ????");
            }
            
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"No Network Connection", nil)];
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

- (void)configureColor {
    self.usernameLabel.textColor = self.passwordLabel.textColor = self.questionLabel.textColor = self.questionTextLabel.textColor = self.answerLabel.textColor = self.seccodeVerifyLabel.textColor = self.usernameTextField.textColor = self.passwordTextField.textColor = self.answerTextField.textColor = self.seccodeVerifyTextField.textColor = [UIColor GCDarkGrayFontColor];
    
    self.loginButton.backgroundColor = [UIColor GCRedColor];
}

- (void)hideAnswer {
    self.answerRowHeight.constant = 0;
    self.answerTextField.hidden = YES;
    self.answerLabel.hidden = YES;
    self.answerBottomSeparatorView.hidden = YES;
}

- (void)showAnswer {
    self.answerRowHeight.constant = 44;
    self.answerTextField.hidden = NO;
    self.answerLabel.hidden = NO;
    self.answerBottomSeparatorView.hidden = NO;
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




@end

