//
//  GCReplyThreadViewController.m
//  GuitarChina
//
//  Created by 陈大捷 on 15/9/4.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCReplyThreadViewController.h"
#import "GCReplyThreadView.h"

@interface GCReplyThreadViewController ()

@property (nonatomic, strong) GCReplyThreadView *replyThreadView;

@end

@implementation GCReplyThreadViewController

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
    [[GCNetworkManager manager] postReplyWithTid:self.tid message:self.replyThreadView.textView.text formhash:self.formhash Success:^(GCSendReplyModel *model) {
        [self closeAction];
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - Private Methods

- (void)configureView {
    UIBarButtonItem *leftBarItem = [UIView createBarButtonItem:NSLocalizedString(@"Cancel", nil) target:self action:@selector(closeAction)];
    self.navigationItem.leftBarButtonItem = leftBarItem;
    
    UIBarButtonItem *rightBarItem = [UIView createBarButtonItem:NSLocalizedString(@"Send", nil) target:self action:@selector(sendAction)];
    self.navigationItem.rightBarButtonItem = rightBarItem;

    [self.view addSubview:self.replyThreadView];
}

#pragma mark - Getters

- (GCReplyThreadView *)replyThreadView {
    if (!_replyThreadView) {
        _replyThreadView = [[GCReplyThreadView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)];
    }
    return _replyThreadView;
}

@end
