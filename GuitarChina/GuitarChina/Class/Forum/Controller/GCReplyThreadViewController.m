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

@property (nonatomic, copy) void(^replyResultBlock)(void);

@end

@implementation GCReplyThreadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self configureView];
}

- (void)dealloc {
    NSLog(@"GCReplyThreadViewController dealloc");
}

#pragma mark - Event Responses

- (void)closeAction {
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sendAction {
    if ([self.replyThreadView.textView.text trim].length == 0) {
        return;
    }
    [self.replyThreadView.textView resignFirstResponder];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    @weakify(self);
    void (^postWebReplyBlock)(NSArray *) = ^(NSArray *attachArray){
        @strongify(self);
        [GCNetworkManager postWebReplyWithTid:self.tid fid:self.fid message:[self.replyThreadView.textView.text stringByAppendingString:kSuffix] attachArray:attachArray formhash:self.formhash success:^{
            @strongify(self);
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Reply Success", nil)];
            if (self.replySuccessBlock) {
                self.replySuccessBlock();
            }
            [GCStatistics event:GCStatisticsEventReplyThread extra:@{ @"tid" : self.tid }];
            [self closeAction];
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"No Network Connection", nil)];
        }];
    };
    
    NSArray *imageArray = self.replyThreadView.imageArray;
    NSUInteger imageCount = self.replyThreadView.imageArray.count;
    
    if (imageCount > 0) {
        [GCNetworkManager getWebReplyWithFid:self.fid tid:self.tid success:^(NSData *htmlData) {
            @strongify(self);
            //获取web页面formhash
            NSString *formhash = [GCHTMLParse parseWebReply:htmlData];
            __block int tempCount = 0;
            NSMutableArray *attachArray = [NSMutableArray array];
            for (int i = 0; i < imageCount; i++) {
                [GCNetworkManager postWebReplyImageWithFid:self.fid image:imageArray[i] formhash:formhash success:^(NSString *imageID) {
                    tempCount++;
                    [attachArray addObject:imageID];
                    if (tempCount == imageCount) {
                        postWebReplyBlock(attachArray);
                    }
                } failure:^(NSError *error) {
                    [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Image Upload Error", nil)];
                }];
            }
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"No Network Connection", nil)];
        }];
    } else {
        postWebReplyBlock(nil);
    }
    
    /*
     ** old
     [GCNetworkManager postReplyWithTid:self.tid message:[self.replyThreadView.textView.text stringByAppendingString:@"\n"] formhash:self.formhash success:^(GCSendReplyModel *model) {
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
     */
}

#pragma mark - Private Methods

- (void)configureView {
    self.title = NSLocalizedString(@"Write reply", nil);
    
    self.navigationItem.rightBarButtonItem = [UIView createCustomBarButtonItem:@"icon_checkmark"
                                                                   normalColor:[UIColor whiteColor]
                                                              highlightedColor:[GCColor grayColor4]
                                                                        target:self
                                                                        action:@selector(sendAction)];
    
    [self.view addSubview:self.replyThreadView];
}

#pragma mark - Getters

- (GCReplyThreadView *)replyThreadView {
    if (!_replyThreadView) {
        _replyThreadView = [[GCReplyThreadView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)];
        _replyThreadView.viewController = self;
    }
    return _replyThreadView;
}

@end
