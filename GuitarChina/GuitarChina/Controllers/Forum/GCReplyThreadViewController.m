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
    leftBarItem.tintColor = [UIColor GCDeepGrayColor];
    self.navigationItem.leftBarButtonItem = leftBarItem;
    
    UIBarButtonItem *rightBarItem = [UIView createBarButtonItem:NSLocalizedString(@"Send", nil) target:self action:@selector(sendAction)];
    rightBarItem.tintColor = [UIColor GCBlueColor];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    UILabel *titleLabel = [UIView createLabel:CGRectMake(0, 0, 200, 22)
                                         text:@"写回复"
                                         font:[UIFont boldSystemFontOfSize:17]
                                    textColor:[UIColor GCFontColor]];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    UILabel *nameLabel = [UIView createLabel:CGRectMake(0, 22, 200, 20)
                                        text:[[NSUserDefaults standardUserDefaults] stringForKey:kGCLOGINNAME]
                                        font:[UIFont systemFontOfSize:15]
                                   textColor:[UIColor GCDeepGrayColor]];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    
    [titleView addSubview:titleLabel];
    [titleView addSubview:nameLabel];
    self.navigationItem.titleView = titleView;
    
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
