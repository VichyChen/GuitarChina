
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
#import "GCLoginPickerView.h"

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

@property (strong, nonatomic) GCLoginPickerView *questionPickerView;

- (IBAction)selectedPickerViewCompleteAction:(UIButton *)sender;
- (IBAction)loginAction:(UIButton *)sender;
- (IBAction)closeAction:(UIButton *)sender;
- (IBAction)refreshSeccodeVerifyAction:(UITapGestureRecognizer *)sender;
- (IBAction)backgroundClickAction:(UITapGestureRecognizer *)sender;
- (IBAction)showQuestionAction:(UITapGestureRecognizer *)sender;

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
    
    self.getLoginWebBlock();
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    //4,4s
    if (ScreenHeight == 480) {
    } else {
        self.contentOriginY.constant = 20;
    }
    if (iPhone) {
        //iphone
        self.contentWidth.constant = ScreenWidth - 30;
    } else {
        //ipad
        self.contentWidth.constant = 414;
    }
}

- (void)dealloc {
    NSLog(@"dealloc");
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
}

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
    if (self.loginSuccessBlock) {
        self.loginSuccessBlock();
    }
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
//    [UIView animateWithDuration:0.3 animations:^{
//        self.pickerBackgroundView.frame = CGRectMake(0, ScreenHeight - 240, ScreenWidth, 240);
//    }];
    [self.questionPickerView show];
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
    self.title = NSLocalizedString(@"GuitarChina", nil);
    
    [self.usernameTextField addTarget:self action:@selector(textFieldValueChange:) forControlEvents:UIControlEventEditingChanged];
    [self.passwordTextField addTarget:self action:@selector(textFieldValueChange:) forControlEvents:UIControlEventEditingChanged];
    [self.answerTextField addTarget:self action:@selector(textFieldValueChange:) forControlEvents:UIControlEventEditingChanged];
    [self.seccodeVerifyTextField addTarget:self action:@selector(textFieldValueChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [UIView createCustomBarButtonItem:@"icon_delete"
                                                                   normalColor:[UIColor whiteColor]
                                                              highlightedColor:[GCColor grayColor4]
                                                                        target:self
                                                                        action:@selector(closeAction)];
    
    [self.view addSubview:self.questionPickerView];
}

- (void)configureBlock {
    @weakify(self);
    
    self.getLoginWebBlock = ^{
        @strongify(self);
        [GCNetworkManager getLoginWebSuccess:^(NSData *htmlData) {
            [GCHTMLParse parseLoginWeb:htmlData result:^(NSString *seccode, NSString *formhash, NSString *postURL, NSArray *questionArray) {
                self.seccode = seccode;
                self.formhash = formhash;
                self.postURL = postURL;
                self.questionArray = questionArray;
                [self.pickerView reloadAllComponents];
                
                self.questionPickerView.array = questionArray;
                
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
            
            NSString *loginID = [GCHTMLParse parseLoginWebUID:html];
            
            if (loginID.length > 0) {
                NSLog(@"login success");
                APP.tabBarController.selectedIndex = 3;
                [NSUD setObject:@"1" forKey:kGCLogin];
                [NSUD setObject:loginID forKey:kGCLoginID];
                [NSUD setObject:self.usernameTextField.text forKey:kGCLoginName];
                [NSUD synchronize];
                
                [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Login Success", nil)];
                [[NSNotificationCenter defaultCenter] postNotificationName:kGCNotificationLoginSuccess object:nil];
                [self closeAction];
                [GCStatistics event:GCStatisticsEventLogin extra:@{ @"username" : self.usernameTextField.text}];
            } else if ([html rangeOfString:@"抱歉，验证码填写错误"].location != NSNotFound) {
                [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"SecCode Error", nil)];
                NSLog(@"seccodeverify error");
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
        controller.urlString = GCNetworkAPI_URL_Login;
        [self.navigationController pushViewController:controller animated:YES];
    };
}

- (void)configureColor {
    self.usernameLabel.textColor = self.passwordLabel.textColor = self.questionLabel.textColor = self.questionTextLabel.textColor = self.answerLabel.textColor = self.seccodeVerifyLabel.textColor = self.usernameTextField.textColor = self.passwordTextField.textColor = self.answerTextField.textColor = self.seccodeVerifyTextField.textColor = [GCColor fontColor];
    
    self.loginButton.backgroundColor = [GCColor redColor];
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

- (GCLoginPickerView *)questionPickerView {
    if (!_questionPickerView) {
        _questionPickerView = [[GCLoginPickerView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 64, ScreenWidth, ScreenHeight - 64)];
        @weakify(self);
        _questionPickerView.okActionBlock = ^(NSInteger index){
            @strongify(self);
            if (index == 0) {
                [self hideAnswer];
                self.answerTextField.text = @"";
            } else {
                [self showAnswer];
            }
            self.questionIndex = index;
            self.questionTextLabel.text = [self.questionArray objectAtIndex:index];
            [self textFieldValueChange:nil];
        };
    }
    return _questionPickerView;
}

@end

