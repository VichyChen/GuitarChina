//
//  GCWebViewController.m
//  GuitarChina
//
//  Created by mac on 15/10/22.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCWebViewController.h"

@interface GCWebViewController() <UIWebViewDelegate, NJKWebViewProgressDelegate>

@end

@implementation GCWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webView];
    [self.view addSubview:self.progressView];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.urlString]];
    [self.webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UIWebViewDelegate


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if([request.mainDocumentURL.relativePath isEqualToString:@"/Translate/popAction"])
    {
        [self.navigationController popViewControllerAnimated:YES];
        return false;
    }
    
    return YES;
}

-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [self.progressView setProgress:progress animated:NO];
}

#pragma mark - Getters

- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _webView.dataDetectorTypes = UIDataDetectorTypeLink;
        _webView.opaque = NO;
        _webView.backgroundColor = [UIColor clearColor];
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
        _webView.delegate = self;
        
        _progressProxy = [[NJKWebViewProgress alloc] init]; // instance variable
        _webView.delegate = _progressProxy;
        _progressProxy.webViewProxyDelegate = self;
        _progressProxy.progressDelegate = self;
    }
    return _webView;
}

- (NJKWebViewProgressView *)progressView {
    if (!_progressView) {
        CGRect navBounds = self.navigationController.navigationBar.bounds;
        CGRect barFrame = CGRectMake(0,
                                     navBounds.size.height - 2,
                                     navBounds.size.width,
                                     2);
        _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
        _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        [_progressView setProgress:0 animated:YES];
    }
    return _progressView;
}

@end
