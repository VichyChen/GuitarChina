//
//  GCThreadDetailViewController.m
//  GuitarChina
//
//  Created by mac on 15/10/16.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCThreadDetailViewController.h"
#import "KxMenu.h"
#import "GCThreadDetailView.h"
#import "GCWebViewController.h"
#import "GCReplyThreadViewController.h"
#import "GCReportThreadViewController.h"
#import "GCNavigationController.h"
#import "RESideMenu.h"
#import "GCLoginViewController.h"

@interface GCThreadDetailViewController () <UIWebViewDelegate> {
    CGFloat offsetY;
}

@property (nonatomic, strong) GCThreadDetailView *threadDetailView;
@property (nonatomic, copy) void (^refreshBlock)();

@property (nonatomic, strong) NSMutableString *htmlString;

@property (nonatomic, assign) NSInteger pageIndex;  //第几页
@property (nonatomic, assign) NSInteger pageSize;   //每页条数
@property (nonatomic, assign) NSInteger count;      //贴子数
@property (nonatomic, assign) NSInteger pageCount;  //总共几页

@end

@implementation GCThreadDetailViewController

- (void)loadView {
    [super loadView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _pageIndex = 1;
    _pageSize = 40;
    _count = 0;
    _pageCount = 0;
    _htmlString = [[NSMutableString alloc] init];

    [self configureView];
    [self configureBlock];
    [self configureNotification];
    
    [self.threadDetailView webViewStartRefresh];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kGCNOTIFICATION_LOGINSUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kGCNOTIFICATION_REPLY object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kGCNOTIFICATION_COLLECT object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kGCNOTIFICATION_SHARE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kGCNOTIFICATION_SAFARI object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kGCNOTIFICATION_COPYURL object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kGCNOTIFICATION_REPORT object:nil];
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

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        
        //登陆链接
        if ([request.mainDocumentURL.relativeString endsWith:@"GuitarChina.app/member.php?mod=logging&action=login"]) {
            GCLoginViewController *loginViewController = [[GCLoginViewController alloc] init];
            GCNavigationController *navigationController = [[GCNavigationController alloc] initWithRootViewController:loginViewController];
            [self presentViewController:navigationController animated:YES completion:nil];

            return false;
        }
        
        GCWebViewController *controller = [[GCWebViewController alloc] init];
        controller.urlString = request.mainDocumentURL.absoluteString;
        [self.navigationController pushViewController:controller animated:YES];
        return false;
    }
    
    return YES;
}

#pragma mark - Notification

- (void)configureNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAction) name:kGCNOTIFICATION_LOGINSUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(replyAction) name:kGCNOTIFICATION_REPLY object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(collectAction) name:kGCNOTIFICATION_COLLECT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shareAction) name:kGCNOTIFICATION_SHARE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(safariAction) name:kGCNOTIFICATION_SAFARI object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(copyURLAction) name:kGCNOTIFICATION_COPYURL object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reportAction) name:kGCNOTIFICATION_REPORT object:nil];
}

#pragma mark - Event Response

- (void)replyAction {
    GCReplyThreadViewController *controller = [[GCReplyThreadViewController alloc] init];
    controller.tid = self.tid;
    controller.formhash = self.formhash;
    GCNavigationController *navigationController = [[GCNavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)collectAction {
    [[GCNetworkManager manager] getCollectionWithTid:self.tid formhash:self.formhash Success:^{
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)shareAction {
}

- (void)reportAction {
    GCReportThreadViewController *controller = [[GCReportThreadViewController alloc] init];
    controller.tid = self.tid;
    GCNavigationController *navigationController = [[GCNavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)safariAction {
    [Util openUrlInSafari:GCNETWORKAPI_URL_THREAD(self.tid)];
}

- (void)copyURLAction {
    [Util copyStringToPasteboard:GCNETWORKAPI_URL_THREAD(self.tid)];
}

- (void)refreshAction {
    [self.threadDetailView webViewStartRefresh];
    ApplicationDelegate.tabBarController.selectedIndex = 1;
}

#pragma mark - Private Methods

- (void)configureView {
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = NSLocalizedString(@"Detail", nil);//@"详情";
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 25, 25);
    [leftButton setAdjustsImageWhenHighlighted:YES];
    UIImage *image = [UIImage imageNamed:@"icon_ellipsis"];
    [leftButton setImage:[image imageWithTintColor:[UIColor GCFontColor]] forState:UIControlStateNormal];
    [leftButton setImage:[image imageWithTintColor:[UIColor GCDeepGrayColor]] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(presentRightMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.rightBarButtonItem = barItem;
    
    [self.view addSubview:self.threadDetailView];
}

- (void)configureBlock {
    @weakify(self);
    self.refreshBlock = ^(void (^success)(GCThreadDetailModel *)){
        @strongify(self);
        //1992416
        //1993403
        //1993030
        [[GCNetworkManager manager] getViewThreadWithThreadID:self.tid pageIndex:self.pageIndex pageSize:self.pageSize Success:^(GCThreadDetailModel *model) {
            self.formhash = model.formhash;
            self.count = [model.replies integerValue];
            self.pageCount = self.count / self.pageSize + 1;
            self.threadDetailView.pickerViewCount = self.pageCount;
            success(model);
        } failure:^(NSError *error) {
            
        }];
    };
}

- (void)beginRefresh {
    self.refreshBlock(^(GCThreadDetailModel *model) {
        [self.htmlString setString:[model getGCThreadDetailModelHtml]];
        [self.threadDetailView.webView loadHTMLString:self.htmlString baseURL:[Util bundleBasePathURL]];
        [self.threadDetailView.pageButton setTitle:[NSString stringWithFormat:@"%ld / %ld", self.pageIndex, self.pageCount] forState:UIControlStateNormal];
        [self.threadDetailView webViewEndRefresh];
    });
}

- (void)beginBack {
    if (self.pageIndex - 1 == 0) {
        [self.threadDetailView webViewEndFetchMore];
        return;
    } else {
        self.pageIndex--;
        [self.threadDetailView.pageButton setTitle:[NSString stringWithFormat:@"%ld / %ld", self.pageIndex, self.pageCount] forState:UIControlStateNormal];
        self.refreshBlock(^(GCThreadDetailModel *model) {
            [self.htmlString setString:[model getGCThreadDetailModelHtml]];
            [self.threadDetailView.webView loadHTMLString:self.htmlString baseURL:[Util bundleBasePathURL]];
            
            [self.threadDetailView webViewEndFetchMore];
        });
    }
}

- (void)beginForward {
    //    offsetY = self.webView.scrollView.contentOffset.y;
    if (self.pageCount < self.pageIndex + 1) {
        [self.threadDetailView webViewEndFetchMore];
        return;
    } else {
        self.pageIndex++;
        [self.threadDetailView.pageButton setTitle:[NSString stringWithFormat:@"%ld / %ld", self.pageIndex, self.pageCount] forState:UIControlStateNormal];
        self.refreshBlock(^(GCThreadDetailModel *model) {
            [self.htmlString setString:[model getGCThreadDetailModelHtml]];
            [self.threadDetailView.webView loadHTMLString:self.htmlString baseURL:[Util bundleBasePathURL]];
            
            [self.threadDetailView webViewEndFetchMore];
        });
    }
}

#pragma mark - Getters

- (GCThreadDetailView *)threadDetailView {
    if (!_threadDetailView) {
        _threadDetailView = [[GCThreadDetailView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight)];
        _threadDetailView.webView.delegate = self;
        @weakify(self);
        _threadDetailView.webViewRefreshBlock = ^{
            @strongify(self);
            [self beginRefresh];
        };
        _threadDetailView.webViewFetchMoreBlock = ^{
            @strongify(self);
            [self beginForward];
        };
        _threadDetailView.pageActionBlock = ^{
            //        @strongify(self);
            
        };
        _threadDetailView.backActionBlock = ^{
            @strongify(self);
            [self beginBack];
        };
        _threadDetailView.forwardActionBlock = ^{
            @strongify(self);
            [self beginForward];
        };
        _threadDetailView.pickerSelectActionBlock = ^(NSInteger page){
            @strongify(self);
            if (self.pageIndex != page) {
                self.pageIndex = page;
                [self.threadDetailView webViewStartRefresh];
            }
        };
        _threadDetailView.swipeLeftActionBlock = ^{
            @strongify(self);
            [self presentRightMenuViewController:nil];
        };
    }
    return _threadDetailView;
}

//- (void)beginFetchMore {
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

//    [self.webView stringByEvaluatingJavaScriptFromString:@"var div = document.createElement(\"div\");div.innerHTML = \"<p>2333</p>\";document.body.appendChild(div);"];
//
//    [self.webView.scrollView.footer endRefreshing];




//    [self.webView stringByEvaluatingJavaScriptFromString:@"var a = document.createElement(\"a\");a.innerHTML = \"aaa\";a.href=\"www.baidu.com\";document.body.appendChild(div);"];

//    [self.htmlString appendString:@"<img src=\"http://bbs.guitarchina.com/static/image/common/logo.gif\"></img>"];
//    [self.webView loadHTMLString:self.htmlString baseURL:nil];
//

//}

@end
