//
//  GCNewsDetailViewController.m
//  GuitarChina
//
//  Created by mac on 2017/7/7.
//  Copyright © 2017年 陈大捷. All rights reserved.
//

#import "GCNewsDetailViewController.h"
#import "GCAdBannerView.h"

@interface GCNewsDetailViewController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) GCAdBannerView *bannner;

@end

@implementation GCNewsDetailViewController

- (instancetype)init {
    if (self = [super init]) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Detail", nil);
    [self configureView];
    
    [self.webView.scrollView headerBeginRefresh];
    
    [GCStatistics event:GCStatisticsEventNewsDetail extra:nil];
}

- (void)configureView {
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webView];
#if FREEVERSION
    [self.view addSubview:self.bannner];
#endif
}

#pragma mark - UIWebViewDelegate

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self.webView.scrollView headerEndRefresh];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    //#if FREEVERSION
    //    [UIView animateWithDuration:1.0 animations:^{
    //        self.bannner.alpha = 1.0f;
    //    }];
    //#endif
    [self.webView.scrollView headerEndRefresh];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    return YES;
}

#pragma mark - HTTP

- (void)getNews {
    @weakify(self);
    [GCNetworkManager getNewsWithPID:self.pid success:^(NSData *htmlData) {
        @strongify(self);
        NSString *htmlString = [[NSString alloc] initWithData:htmlData  encoding:NSUTF8StringEncoding];
        [self.webView loadHTMLString:htmlString baseURL:[Util getBundlePathURL]];
#if FREEVERSION
        [UIView animateWithDuration:1.0 animations:^{
            self.bannner.alpha = 1.0f;
        }];
#endif
    } failure:^(NSError *error) {
        @strongify(self);
        [self.webView.scrollView headerEndRefresh];
    }];
    
    //    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", GCNetworkAPI_Get_NewsWithPID(self.pid)]]]];
}

#pragma mark - Getters

- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64)];
        _webView.opaque = NO;
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.delegate = self;
        @weakify(self);
        _webView.scrollView.headerRefreshBlock = ^{
            @strongify(self);
            [self getNews];
        };
    }
    
    return _webView;
}

- (GCAdBannerView *)bannner {
    if (!_bannner) {
        _bannner = [[GCAdBannerView alloc] initWithRootViewController:APP.window.rootViewController];
        _bannner.alpha = 0.0f;
        @weakify(self);
        _bannner.loadRequestCompleteBlock = ^{
            @strongify(self);
            self.bannner.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 50);
            [UIView animateWithDuration:0.5 animations:^{
                self.bannner.frame = CGRectMake(0, ScreenHeight - 50, ScreenWidth, 50);
                self.webView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 50);
            }];
        };
    }
    return _bannner;
}

@end
