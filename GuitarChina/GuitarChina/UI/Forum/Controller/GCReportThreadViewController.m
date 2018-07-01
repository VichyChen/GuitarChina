//
//  GCReportThreadViewController.m
//  GuitarChina
//
//  Created by mac on 15/11/2.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCReportThreadViewController.h"
#import "GCReportThreadView.h"

@interface GCReportThreadViewController ()

@property (nonatomic, strong) GCReportThreadView *reportThreadView;

@end

@implementation GCReportThreadViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self configureView];
}

#pragma mark - Event Responses

- (void)closeAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendAction {
    if ([self.reportThreadView.textView.text trim].length == 0) {
        return;
    }
    [self.reportThreadView.textView resignFirstResponder];
    [GCNetworkManager postReportWithTid:self.tid text:self.reportThreadView.textView.text success:^{
        [SVProgressHUD showSuccessWithStatus:@"举报成功"];
        [self closeAction];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"没有网络连接！"];
    }];
}

#pragma mark - Private Methods

- (void)configureView {
    self.navigationItem.leftBarButtonItem = [UIView createCustomBarButtonItem:@"icon_delete"
                                                                   normalColor:[UIColor whiteColor]
                                                              highlightedColor:[GCColor grayColor4]
                                                                        target:self
                                                                        action:@selector(closeAction)];
    
    self.navigationItem.rightBarButtonItem = [UIView createCustomBarButtonItem:@"icon_checkmark"
                                                                   normalColor:[UIColor whiteColor]
                                                              highlightedColor:[GCColor grayColor4]
                                                                        target:self
                                                                        action:@selector(sendAction)];
    
    self.title = @"举报";
    
    [self.view addSubview:self.reportThreadView];
}

#pragma mark - Getters

- (GCReportThreadView *)reportThreadView {
    if (!_reportThreadView) {
        _reportThreadView = [[GCReportThreadView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - kNavigatioinBarHeight)];
    }
    return _reportThreadView;
}

@end
