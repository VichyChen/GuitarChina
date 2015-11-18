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
#import "DOPNavbarMenu.h"

@interface GCThreadDetailViewController () <UIWebViewDelegate, DOPNavbarMenuDelegate> {

}

@property (nonatomic, assign) CGFloat offsetY;
@property (nonatomic, assign) BOOL loaded;
@property (nonatomic, assign) NSInteger tabBarSelectedIndex;

@property (nonatomic, strong) GCThreadDetailView *threadDetailView;
@property (nonatomic, strong) DOPNavbarMenu *menu;

@property (nonatomic, copy) void (^refreshBlock)();

@property (nonatomic, strong) NSMutableString *htmlString;

@property (nonatomic, assign) NSInteger pageIndex;  //第几页
@property (nonatomic, assign) NSInteger pageSize;   //每页条数
@property (nonatomic, assign) NSInteger replyCount; //回贴数
@property (nonatomic, assign) NSInteger currentPageReplyCount; //回贴数
@property (nonatomic, assign) NSInteger pageCount;  //总共几页

@end

@implementation GCThreadDetailViewController

- (void)loadView {
    [super loadView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.hidesBackButton =YES;
//    self.navigationController.navigationBarHidden = YES;
    
    _offsetY = -1;
    _loaded = false;
    _tabBarSelectedIndex = ApplicationDelegate.tabBarController.selectedIndex;
    _pageIndex = 1;
    _pageSize = 40;
    _replyCount = 0;
    _pageCount = 0;
    _htmlString = [[NSMutableString alloc] init];
    
    [self configureView];
    [self configureBlock];
    [self configureNotification];

    [self.threadDetailView webViewStartRefresh];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];

    ApplicationDelegate.rightMenuViewController.tid = self.tid;
    ApplicationDelegate.rightMenuViewController.formhash = self.formhash;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:nil];
    
    if (self.menu) {
        [self.menu dismissWithAnimation:NO];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    
//        [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//        [self.navigationController.navigationBar setShadowImage:nil];
    [super viewWillDisappear:animated];
    
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kGCNOTIFICATION_LOGINSUCCESS object:nil];
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
    if (self.offsetY != -1) {
        self.threadDetailView.webView.scrollView.contentOffset = CGPointMake(0, self.offsetY);
        self.offsetY = 0;
    }
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"request.mainDocumentURL.relativeString:%@", request.mainDocumentURL.relativeString);
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        //登陆链接
        if ([request.mainDocumentURL.relativeString endsWith:@"GuitarChina.app/member.php?mod=logging&action=login"]) {
            GCLoginViewController *loginViewController = [[GCLoginViewController alloc] init];
            GCNavigationController *navigationController = [[GCNavigationController alloc] initWithRootViewController:loginViewController];
            [self presentViewController:navigationController animated:YES completion:nil];
            
            return false;
        }
        //优酷视频
        if ([request.mainDocumentURL.relativeString startsWith:@"http://player.youku.com/player.php/sid/"] && [request.mainDocumentURL.relativeString endsWith:@".swf"]) {
            NSArray *array = [request.mainDocumentURL.relativeString split:@"/"];
            GCWebViewController *controller = [[GCWebViewController alloc] init];
            controller.urlString = GCVIDEO_URL_YOUKU([array objectAtIndex:5]);
            [self.navigationController pushViewController:controller animated:YES];
            
            return false;
        }
        //土豆视频
        if ([request.mainDocumentURL.relativeString startsWith:@"http://www.tudou.com/v/"] && [request.mainDocumentURL.relativeString endsWith:@".swf"]) {
            NSArray *array = [request.mainDocumentURL.relativeString split:@"/"];
            GCWebViewController *controller = [[GCWebViewController alloc] init];
            controller.urlString = GCVIDEO_URL_TUDOU([array objectAtIndex:4]);
            [self.navigationController pushViewController:controller animated:YES];
            
            return false;
        }
        
        if ([request.mainDocumentURL.relativeString startsWith:@"http://bbs.guitarchina.com/thread-"] && [request.mainDocumentURL.relativePath endsWith:@".html"]) {
            NSArray *array = [request.mainDocumentURL.relativeString split:@"-"];
            GCThreadDetailViewController *controller = [[GCThreadDetailViewController alloc] init];
            controller.tid = [array objectAtIndex:1];
            [self.navigationController pushViewController:controller animated:YES];
            
            return false;
        }
        
        GCWebViewController *controller = [[GCWebViewController alloc] init];
        controller.urlString = request.mainDocumentURL.absoluteString;
        [self.navigationController pushViewController:controller animated:YES];
        
        return false;
    }
    
    return YES;
}

#pragma mark - DOPNavbarMenuDelegate


- (void)didShowMenu:(DOPNavbarMenu *)menu {
    
}

- (void)didDismissMenu:(DOPNavbarMenu *)menu {
    
}

- (void)didSelectedMenu:(DOPNavbarMenu *)menu atIndex:(NSInteger)index {
//    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"you selected" message:[NSString stringWithFormat:@"number %@", @(index+1)] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    [av show];
}


#pragma mark - Notification

- (void)configureNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAction) name:kGCNOTIFICATION_LOGINSUCCESS object:nil];
}

#pragma mark - Event Response

- (void)refreshAction {
    self.loaded = false;
    [self.threadDetailView webViewStartRefresh];
    ApplicationDelegate.tabBarController.selectedIndex = self.tabBarSelectedIndex;
}

#pragma mark - Private Methods

- (void)configureView {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.title = NSLocalizedString(@"Detail", nil);//@"详情";
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 25, 25);
    [leftButton setAdjustsImageWhenHighlighted:YES];
    UIImage *image = [UIImage imageNamed:@"icon_ellipsis"];
    [leftButton setImage:[image imageWithTintColor:[UIColor GCFontColor]] forState:UIControlStateNormal];
    [leftButton setImage:[image imageWithTintColor:[UIColor GCDeepGrayColor]] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(openMenu:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.rightBarButtonItem = barItem;

    [self.view addSubview:self.threadDetailView];
}

- (void)showRightMenuViewController {
    if (!self.loaded) {
        return;
    }
    [self presentRightMenuViewController:nil];
}

- (void)openMenu:(id)sender {
    if (self.menu.isOpen) {
        [self.menu dismissWithAnimation:YES];
    } else {
        [self.menu showInNavigationController:self.navigationController];
    }
}

- (void)configureBlock {
    @weakify(self);
    self.refreshBlock = ^(void (^success)(GCThreadDetailModel *)){
        @strongify(self);
        //1993403
        //1993030
        //1994974
        [[GCNetworkManager manager] getViewThreadWithThreadID:self.tid pageIndex:self.pageIndex pageSize:self.pageSize Success:^(GCThreadDetailModel *model) {
            self.loaded = true;
            self.uid = model.member_uid;
            self.formhash = model.formhash;
            ApplicationDelegate.rightMenuViewController.formhash = self.formhash;
            ApplicationDelegate.rightMenuViewController.uid = self.uid;
            
            self.replyCount = [model.replies integerValue];
            self.pageCount = self.replyCount / self.pageSize + 1;
            
            if (self.replyCount < self.pageSize) {
                self.currentPageReplyCount = self.replyCount;
            } else if (self.pageIndex * self.pageSize <= self.replyCount) {
                self.currentPageReplyCount = self.pageSize;
            } else {
                self.currentPageReplyCount = self.replyCount % ((self.pageIndex - 1) * self.pageSize) + 1;
            }
            
            self.threadDetailView.pickerViewCount = self.pageCount;
            self.threadDetailView.pickerViewIndex = self.pageIndex - 1;
            success(model);
            if (self.threadDetailView.toolBarView.alpha == 0.0f) {
                [UIView animateWithDuration:1.0 animations:^{
                    self.threadDetailView.toolBarView.alpha = 1.0f;
                }];
            }
        } failure:^(NSError *error) {
            [self.threadDetailView webViewEndRefresh];
            [self.threadDetailView webViewEndFetchMore];
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"No network connection!", nil)];
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

- (void)beginFetchMore {
    if ((self.currentPageReplyCount) % self.pageSize == 0) {
        [self beginNextPageAction];
    } else {
        self.offsetY = self.threadDetailView.webView.scrollView.contentOffset.y;
        self.refreshBlock(^(GCThreadDetailModel *model) {
            [self.htmlString setString:[model getGCThreadDetailModelHtml]];
            [self.threadDetailView.webView loadHTMLString:self.htmlString baseURL:[Util bundleBasePathURL]];
            [self.threadDetailView webViewEndFetchMore];
        });
    }
}

- (void)beginPreviousPageAction {
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

- (void)beginNextPageAction {
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
            [self beginFetchMore];
        };
        _threadDetailView.previousPageActionBlock = ^{
            @strongify(self);
            [self beginPreviousPageAction];
        };
        _threadDetailView.nextPageActionBlock = ^{
            @strongify(self);
            [self beginNextPageAction];
        };
        _threadDetailView.goActionBlock = ^(NSInteger page) {
            @strongify(self);
            if (self.pageIndex != page) {
                self.pageIndex = page;
                [self.threadDetailView webViewStartRefresh];
            }
        };
        _threadDetailView.swipeLeftActionBlock = ^{
            @strongify(self);
            [self showRightMenuViewController];
        };
    }
    return _threadDetailView;
}

- (DOPNavbarMenu *)menu {
    if (!_menu) {
        DOPNavbarMenuItem *item1 = [DOPNavbarMenuItem ItemWithTitle:NSLocalizedString(@"Reply", nil) icon:[UIImage imageNamed:@"Image"]];
        DOPNavbarMenuItem *item2 = [DOPNavbarMenuItem ItemWithTitle:NSLocalizedString(@"Collect", nil) icon:[UIImage imageNamed:@"Image"]];
        DOPNavbarMenuItem *item3 = [DOPNavbarMenuItem ItemWithTitle:NSLocalizedString(@"Report", nil) icon:[UIImage imageNamed:@"Image"]];
        DOPNavbarMenuItem *item4 = [DOPNavbarMenuItem ItemWithTitle:NSLocalizedString(@"Open in Safari", nil) icon:[UIImage imageNamed:@"Image"]];
        DOPNavbarMenuItem *item5 = [DOPNavbarMenuItem ItemWithTitle:NSLocalizedString(@"Open in Chrome", nil) icon:[UIImage imageNamed:@"Image"]];
        DOPNavbarMenuItem *item6 = [DOPNavbarMenuItem ItemWithTitle:NSLocalizedString(@"Open in QQ Broswer", nil) icon:[UIImage imageNamed:@"Image"]];

        
        DOPNavbarMenuItem *item7 = [DOPNavbarMenuItem ItemWithTitle:NSLocalizedString(@"Copy URL", nil) icon:[UIImage imageNamed:@"Image"]];
        
        _menu = [[DOPNavbarMenu alloc] initWithFirstRowItems:@[item1,item2,item3,item4,item5,item6] SecondRowItems:@[item7]];
        _menu.backgroundColor = [UIColor colorWithRed:0.930f green:0.930f blue:0.930f alpha:1.00f];
        _menu.delegate = self;
    }
    return _menu;
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
