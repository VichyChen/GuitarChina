//
//  GCWebViewController.m
//  GuitarChina
//
//  Created by mac on 15/10/22.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCWebViewController.h"

@interface GCWebViewController() <UIWebViewDelegate>

@end

@implementation GCWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webView];
    
//    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.urlString]];
//    [self.webView loadRequest:request];
    
    [self.webView loadHTMLString:self.urlString baseURL:[Util bundleBasePathURL]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UIWebViewDelegate


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
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

#pragma mark - Getters

- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _webView.dataDetectorTypes = UIDataDetectorTypeLink;
        _webView.opaque = NO;
        _webView.backgroundColor = [UIColor clearColor];
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
        _webView.delegate = self;
    }
    return _webView;
}

@end
