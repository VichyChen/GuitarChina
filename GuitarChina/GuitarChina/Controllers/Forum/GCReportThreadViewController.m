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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Event Response

- (void)closeAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendAction {
    if ([self.reportThreadView.textView.text trim].length == 0) {
        return;
    }
    [self.reportThreadView.textView resignFirstResponder];
    [[GCNetworkManager manager] postReportWithTid:self.tid text:self.reportThreadView.textView.text Success:^{
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Reply Success", nil)];
        [self closeAction];
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - Private Methods

- (void)configureView {
    UIBarButtonItem *leftBarItem = [UIView createBarButtonItem:NSLocalizedString(@"Cancel", nil) target:self action:@selector(closeAction)];
    leftBarItem.tintColor = [UIColor GCLightGrayFontColor];
    self.navigationItem.leftBarButtonItem = leftBarItem;
    
    UIBarButtonItem *rightBarItem = [UIView createBarButtonItem:NSLocalizedString(@"Send", nil) target:self action:@selector(sendAction)];
    rightBarItem.tintColor = [UIColor GCBlueColor];
    self.navigationItem.rightBarButtonItem = rightBarItem;

    self.title = NSLocalizedString(@"Report", nil);
    
    [self.view addSubview:self.reportThreadView];
}

#pragma mark - Getters

- (GCReportThreadView *)reportThreadView {
    if (!_reportThreadView) {
        _reportThreadView = [[GCReportThreadView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)];
    }
    return _reportThreadView;
}

@end
