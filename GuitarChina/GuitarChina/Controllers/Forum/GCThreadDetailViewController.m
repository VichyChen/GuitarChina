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

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _pageIndex = 1;
        _pageSize = 40;
        _count = 0;
        _pageCount = 0;
        _htmlString = [[NSMutableString alloc] init];
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"帖子详情";
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 25, 25);
    [leftButton setAdjustsImageWhenHighlighted:YES];
    UIImage *image = [UIImage imageNamed:@"icon_ellipsis"];
    [leftButton setImage:[image imageWithTintColor:[UIColor GCFontColor]] forState:UIControlStateNormal];
    [leftButton setImage:[image imageWithTintColor:[UIColor GCDeepGrayColor]] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(rightBarButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.rightBarButtonItem = barItem;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureView];
    [self configureBlock];
    
//    [self beginRefresh];
    [self.threadDetailView webViewStartRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
//    self.threadDetailView.webView.alpha = 0.0;
//    [UIView animateWithDuration:0.5 animations:^{
//        self.threadDetailView.webView.alpha = 1.0;
//    }];
    //    self.webView.scrollView.contentOffset = CGPointMake(self.webView.scrollView.contentOffset.x, offsetY);
}

#pragma mark - Event Response

- (void)rightBarButtonClickAction:(id)sender {
    NSArray *menuItems = @[
                           [KxMenuItem menuItem:NSLocalizedString(@"Reply", nil)
                                          image:[UIImage imageNamed:@"icon_reply"]
                                         target:self
                                         action:@selector(replyAction:)],
                           [KxMenuItem menuItem:NSLocalizedString(@"Collect", nil)
                                          image:[UIImage imageNamed:@"icon_collect"]
                                         target:self
                                         action:@selector(collectAction:)],
                           [KxMenuItem menuItem:NSLocalizedString(@"Share", nil)
                                          image:[UIImage imageNamed:@"icon_share"]
                                         target:self
                                         action:@selector(shareAction:)],
                           [KxMenuItem menuItem:@"Safari"
                                          image:[UIImage imageNamed:@"icon_open"]
                                         target:self
                                         action:@selector(safariAction:)],
                           [KxMenuItem menuItem:NSLocalizedString(@"Report", nil)
                                          image:[UIImage imageNamed:@"icon_report"]
                                         target:self
                                         action:@selector(reportAction:)],
                           ];
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

#pragma mark - Private Methods

- (void)configureView {
    self.threadDetailView = [[GCThreadDetailView alloc] init];
    self.threadDetailView.webView.delegate = self;
    @weakify(self);
    self.threadDetailView.webViewRefreshBlock = ^{
        @strongify(self);
        [self beginRefresh];
    };
    self.threadDetailView.webViewFetchMoreBlock = ^{
        @strongify(self);
        [self beginForward];
    };
    self.threadDetailView.pageActionBlock = ^{
//        @strongify(self);

    };
    self.threadDetailView.backActionBlock = ^{
        @strongify(self);
        [self beginBack];
    };
    self.threadDetailView.forwardActionBlock = ^{
        @strongify(self);
        [self beginForward];
    };
    [self.view addSubview:self.threadDetailView];
}

- (void)configureBlock {
    @weakify(self);
    self.refreshBlock = ^(void (^success)(GCThreadDetailModel *)){
        @strongify(self);
        [[GCNetworkManager manager] getViewThreadWithThreadID:self.tid pageIndex:self.pageIndex pageSize:self.pageSize Success:^(GCThreadDetailModel *model) {
        self.count = [model.replies integerValue];
            self.pageCount = self.count / self.pageSize + 1;
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
