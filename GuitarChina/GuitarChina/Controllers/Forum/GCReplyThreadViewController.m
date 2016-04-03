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
    
    if ([self.replyThreadView.textView.text trim].length == 0) {
        return;
    }
    [self.replyThreadView.textView resignFirstResponder];
    NSLog(@"click");
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [[GCNetworkManager manager] postReplyWithTid:self.tid message:[self.replyThreadView.textView.text stringByAppendingString:@"\n"] formhash:self.formhash success:^(GCSendReplyModel *model) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
        if ([model.message.messageval isEqualToString:@"post_reply_succeed"]) {
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Reply Success", nil)];
            [self closeAction];
        } else {
            [SVProgressHUD showSuccessWithStatus:model.message.messagestr];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"No Network Connection", nil)];
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }];
}

#pragma mark - Private Methods

- (void)configureView {
    self.title = NSLocalizedString(@"Write reply", nil);
    
    self.navigationItem.leftBarButtonItem = [UIView createCustomBarButtonItem:@"icon_delete"
                                                                  normalColor:[UIColor GCDarkGrayFontColor]
                                                             highlightedColor:[UIColor grayColor]
                                                                       target:self
                                                                       action:@selector(closeAction)];
    
    self.navigationItem.rightBarButtonItem = [UIView createCustomBarButtonItem:@"icon_checkmark"
                                                                   normalColor:[UIColor GCDarkGrayFontColor]
                                                              highlightedColor:[UIColor grayColor]
                                                                        target:self
                                                                        action:@selector(sendAction)];
    
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
