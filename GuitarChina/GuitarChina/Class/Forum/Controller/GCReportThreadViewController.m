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
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Report Success", nil)];
        [self closeAction];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"No Network Connection", nil)];
    }];
}

#pragma mark - Private Methods

- (void)configureView {
    self.navigationItem.leftBarButtonItem = [UIView createCustomBarButtonItem:@"icon_delete"
                                                                   normalColor:[GCColor grayColor1]
                                                              highlightedColor:[UIColor grayColor]
                                                                        target:self
                                                                        action:@selector(closeAction)];
    
    self.navigationItem.rightBarButtonItem = [UIView createCustomBarButtonItem:@"icon_checkmark"
                                                                   normalColor:[GCColor grayColor1]
                                                              highlightedColor:[UIColor grayColor]
                                                                        target:self
                                                                        action:@selector(sendAction)];
    
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
