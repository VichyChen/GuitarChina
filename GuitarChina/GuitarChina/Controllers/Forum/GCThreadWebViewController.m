//
//  GCThreadWebViewController.m
//  GuitarChina
//
//  Created by mac on 15/10/13.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCThreadWebViewController.h"
#import "KxMenu.h"
#import "MJRefresh.h"

@interface GCThreadWebViewController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, copy) void (^refreshBlock)();

@property (nonatomic, strong) NSMutableString *htmlString;

@end

@implementation GCThreadWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //        self.pageIndex = 1;
        //        self.pageSize = 20;
        _htmlString = [[NSMutableString alloc] init];
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"帖子详情";
    self.view.backgroundColor = [UIColor whiteColor];
    [self configureView];
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 25, 25);
    [leftButton setAdjustsImageWhenHighlighted:YES];
    UIImage *image = [UIImage imageNamed:@"icon_ellipsis"];
    [leftButton setImage:[image imageWithTintColor:[UIColor FontColor]] forState:UIControlStateNormal];
    [leftButton setImage:[image imageWithTintColor:[UIColor LightFontColor]] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(rightBarButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.rightBarButtonItem = barItem;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureView];
    [self configureBlock];
    
    self.refreshBlock();
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIView animateWithDuration:0.5 animations:^{
        self.webView.alpha = 1.0;
    }];
    
    [self.webView.scrollView.footer endRefreshing];
    
}

#pragma mark - Event Response

- (void)rightBarButtonClickAction:(id)sender {
    NSArray *menuItems = @[
                           [KxMenuItem menuItem:NSLocalizedString(@"Reply", nil)
                                          image:nil
                                         target:nil
                                         action:@selector(replyAction:)],
                           
                           [KxMenuItem menuItem:NSLocalizedString(@"Collect", nil)
                                          image:[UIImage imageNamed:@"action_icon"]
                                         target:self
                                         action:@selector(collectAction:)],
                           
                           [KxMenuItem menuItem:NSLocalizedString(@"Share", nil)
                                          image:nil
                                         target:self
                                         action:@selector(shareAction:)],
                           
                           [KxMenuItem menuItem:NSLocalizedString(@"Report", nil)
                                          image:[UIImage imageNamed:@"reload"]
                                         target:self
                                         action:@selector(reportAction:)],
                           
                           [KxMenuItem menuItem:NSLocalizedString(@"Open in Safari", nil)
                                          image:[UIImage imageNamed:@"search_icon"]
                                         target:self
                                         action:@selector(safariAction:)],
                           
                           [KxMenuItem menuItem:NSLocalizedString(@"Copy url", nil)
                                          image:[UIImage imageNamed:@"home_icon"]
                                         target:self
                                         action:@selector(copyUrlAction:)],
                           ];
    
    for (KxMenuItem *item in menuItems) {
        item.alignment = NSTextAlignmentCenter;
    }
    
    [KxMenu showMenuInView:self.view
                  fromRect:CGRectMake(ScreenWidth - 50, 20, 44, 44)
                 menuItems:menuItems];
}

- (void)replyAction:(id)sender {
}

- (void)collectAction:(id)sender {
}

- (void)shareAction:(id)sender {
}

- (void)reportAction:(id)sender {
}

- (void)safariAction:(id)sender {
}

- (void)copyUrlAction:(id)sender {
}

#pragma mark - Private Methods

- (void)configureView {
    [self.view addSubview:self.webView];
}

- (void)configureBlock {
    @weakify(self);
    self.refreshBlock = ^{
        @strongify(self);
        [[GCNetworkManager manager] getViewThreadWithThreadID:self.tid pageIndex:1 pageSize:20 Success:^(GCThreadDetailModel *model) {
            [self.htmlString appendString:[model getGCThreadDetailModelHtml]];
            [self.webView loadHTMLString:self.htmlString baseURL:[Util bundleBasePathURL]];
        } failure:^(NSError *error) {
            
        }];
    };
}

#pragma mark - Getters

- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64)];
        _webView.dataDetectorTypes = UIDataDetectorTypeLink;
        _webView.alpha = 0.0;
        _webView.delegate = self;
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
        _webView.scrollView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight);
        _webView.scrollView.header = ({
            MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(beginRefresh)];
            header.lastUpdatedTimeLabel.hidden = YES;
            header.stateLabel.hidden = YES;
            header;
        });
        _webView.scrollView.footer = ({
            MJRefreshAutoStateFooter *footer = [MJRefreshAutoStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(beginFetchMore)];
            footer.automaticallyRefresh = NO;
            footer;
        });
        
    }
    return _webView;
}

- (void)beginFetchMore {
    //    [self.htmlString appendString:@"<div style=\"margin:0 12px 0 12px;\">"];
    //    [self.htmlString appendFormat:@"<div style=\"margin:0 10px 0 0;float:left;\">%@</div>", @"111"];
    //    [self.htmlString appendFormat:@"<div style=\"margin:0 0 0 0;float:left;\">%@</div>", @"111"];
    //    [self.htmlString appendFormat:@"<div style=\"margin:0 0 0 12px;float:right;\">%@楼</div>", @"111"];
    //    [self.htmlString appendString:@"<div style = \"clear:both;\"></div>"];
    //
    //    [self.htmlString appendString:@"</div>"];
    //    [self.htmlString appendFormat:@"<div style=\"margin:10px 12px 0 12px;\">%@</div>", @"111"];
    //    [self.htmlString appendString:@"<div style=\"height:1px;background:#D3DCE2;overflow:hidden;margin:10px 10px 10px 10px;\"></div>"];
    //
    //    [self.webView loadHTMLString:self.htmlString baseURL:nil];
    
    //    [self.webView stringByEvaluatingJavaScriptFromString:@"var div = document.createElement(\"div\");div.innerHTML = \"<img src=\"http://bbs.guitarchina.com/static/image/common/logo.gif\"></img>\";document.body.appendChild(div);"];
    
    [self.webView stringByEvaluatingJavaScriptFromString:@"var div = document.createElement(\"div\");div.innerHTML = \"<p>2333</p>\";document.body.appendChild(div);"];
    
    [self.webView.scrollView.footer endRefreshing];
    
    
    
    
    //    [self.webView stringByEvaluatingJavaScriptFromString:@"var a = document.createElement(\"a\");a.innerHTML = \"aaa\";a.href=\"www.baidu.com\";document.body.appendChild(div);"];
    
    //    [self.htmlString appendString:@"<img src=\"http://bbs.guitarchina.com/static/image/common/logo.gif\"></img>"];
    //    [self.webView loadHTMLString:self.htmlString baseURL:nil];
    //
    
}

@end
