//
//  GCThreadDetailViewController.m
//  GuitarChina
//
//  Created by mac on 15/10/16.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCThreadDetailViewController.h"
#import "GCThreadDetailView.h"
#import "GCWebViewController.h"
#import "GCReplyThreadViewController.h"
#import "GCReportThreadViewController.h"
#import "GCNavigationController.h"
#import "GCLoginViewController.h"
#import "DOPNavbarMenu.h"
#import "GCSocial.h"
#import "ZLPhoto.h"

@interface GCThreadDetailViewController () <UIWebViewDelegate, ZLPhotoPickerBrowserViewControllerDataSource,ZLPhotoPickerBrowserViewControllerDelegate> {
    
}

@property (nonatomic, assign) CGFloat offsetY;
@property (nonatomic, assign) BOOL loaded;
@property (nonatomic, assign) NSInteger tabBarSelectedIndex;

@property (nonatomic, strong) GCThreadDetailView *threadDetailView;
@property (nonatomic, strong) DOPNavbarMenu *menu;

@property (nonatomic, copy) void (^refreshBlock)();

@property (nonatomic, copy) void (^replyBlock)();       //回复
@property (nonatomic, copy) void (^favoriteBlock)();    //收藏
@property (nonatomic, copy) void (^reportBlock)();    //举报


@property (nonatomic, strong) NSMutableString *htmlString;

@property (nonatomic, assign) NSInteger pageIndex;  //第几页
@property (nonatomic, assign) NSInteger pageSize;   //每页条数
@property (nonatomic, assign) NSInteger replyCount; //回贴数
@property (nonatomic, assign) NSInteger currentPageReplyCount; //回贴数
@property (nonatomic, assign) NSInteger pageCount;  //总共几页

@property (nonatomic, copy) NSString *threadSubject;  //标题
@property (nonatomic, copy) NSString *threadContent;//内容

@property (nonatomic, strong) GCThreadDetailModel *model;
@property (nonatomic, copy) NSString *seletImagePid;

@end

@implementation GCThreadDetailViewController

- (instancetype)init {
    if (self = [super init]) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.offsetY = -1;
    self.loaded = false;
    self.tabBarSelectedIndex = APP.tabBarController.selectedIndex;
    self.pageIndex = 1;
    self.pageSize = 40;
    self.replyCount = 0;
    self.pageCount = 0;
    self.htmlString = [[NSMutableString alloc] init];
    
    [self configureView];
    [self configureBlock];
    [self configureNotification];
    
    [self.threadDetailView webViewStartRefresh];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    if (self.menu) {
        [self.menu dismissWithAnimation:NO];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kGCNotificationLoginSuccess object:nil];
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
        [UIView animateWithDuration:0.5 animations:^{
        self.threadDetailView.webView.scrollView.contentOffset = CGPointMake(0, self.offsetY);
        }];
        self.offsetY = 0;
    }
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"request.mainDocumentURL.relativeString:%@", request.mainDocumentURL.relativeString);
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        //登陆链接
        if ([request.mainDocumentURL.relativeString endsWith:@"GuitarChina.app/member.php?mod=logging&action=login"]) {
            [self presentLoginViewController];
            
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
        //GC帖子
        if ([request.mainDocumentURL.relativeString startsWith:@"http://bbs.guitarchina.com/thread-"] && [request.mainDocumentURL.relativePath endsWith:@".html"]) {
            NSArray *array = [request.mainDocumentURL.relativeString split:@"-"];
            GCThreadDetailViewController *controller = [[GCThreadDetailViewController alloc] init];
            controller.tid = [array objectAtIndex:1];
            [self.navigationController pushViewController:controller animated:YES];
            
            return false;
        }
        //附件图片大图
        if ([request.mainDocumentURL.relativeString startsWith:@"http://bbs.guitarchina.com/"] &&
            [[[Util parseURLQueryStringToDictionary:request.mainDocumentURL] objectForKey:@"type"] isEqualToString:@"GuitarChinaImage"]) {
        
            NSDictionary *dictionary = [Util parseURLQueryStringToDictionary:request.mainDocumentURL];
            NSString *pid = dictionary[@"pid"];
            self.seletImagePid = pid;
            NSString *index = dictionary[@"index"];
            
            ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
            pickerBrowser.delegate = self;
            pickerBrowser.dataSource = self;
            pickerBrowser.status = UIViewAnimationAnimationStatusFade;
            pickerBrowser.currentIndexPath = [NSIndexPath indexPathForItem:[index integerValue] inSection:0];
            [pickerBrowser showPickerVc:self];
            
            return false;
        }
        //苹果商店地址
        if ([request.mainDocumentURL.relativeString isEqualToString:@"https://itunes.apple.com/cn/app/ji-ta-zhong-guo-hua-yu-di/id1089161305"]) {

            return YES;
        }
        
        GCWebViewController *controller = [[GCWebViewController alloc] init];
        controller.urlString = request.mainDocumentURL.absoluteString;
        [self.navigationController pushViewController:controller animated:YES];
        
        return false;
    }
    
    return YES;
}

//显示大图
#pragma mark - ZLPhotoPickerBrowserViewControllerDataSource

- (NSInteger)numberOfSectionInPhotosInPickerBrowser:(ZLPhotoPickerBrowserViewController *)pickerBrowser {
    return 1;
}

- (NSInteger)photoBrowser:(ZLPhotoPickerBrowserViewController *)photoBrowser numberOfItemsInSection:(NSUInteger)section {
    for (GCThreadDetailPostModel *model in self.model.postlist) {
        if ([model.pid isEqualToString:self.seletImagePid]) {
            return model.attachImageURLArray.count;
        }
    }
    return 0;
}

- (ZLPhotoPickerBrowserPhoto *)photoBrowser:(ZLPhotoPickerBrowserViewController *)pickerBrowser photoAtIndexPath:(NSIndexPath *)indexPath {
    for (GCThreadDetailPostModel *model in self.model.postlist) {
        if ([model.pid isEqualToString:self.seletImagePid]) {
            ZLPhotoAssets *imageObj = [model.attachImageURLArray objectAtIndex:indexPath.row];
            ZLPhotoPickerBrowserPhoto *photo = [ZLPhotoPickerBrowserPhoto photoAnyImageObjWith:imageObj];
            return photo;
        }
    }
    
    return nil;
}

#pragma mark - Notification

- (void)configureNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAction) name:kGCNotificationLoginSuccess object:nil];
}

#pragma mark - Event Responses

- (void)refreshAction {
    self.loaded = false;
    [self.threadDetailView webViewStartRefresh];
    APP.tabBarController.selectedIndex = self.tabBarSelectedIndex;
}

- (void)openMenu:(id)sender {
    if (!self.loaded) {
        return;
    }
    if (self.menu.isOpen) {
        [self.menu dismissWithAnimation:YES];
    } else {
        [self.menu showInNavigationController:self.navigationController];
    }
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
    [leftButton setImage:[image imageWithTintColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [leftButton setImage:[image imageWithTintColor:[GCColor grayColor4]] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(openMenu:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.rightBarButtonItem = barItem;
    
    [self.view addSubview:self.threadDetailView];
}

- (void)configureBlock {
    @weakify(self);
    self.refreshBlock = ^(void (^success)(GCThreadDetailModel *)){
        @strongify(self);
        [GCNetworkManager getViewThreadWithThreadID:self.tid pageIndex:self.pageIndex pageSize:self.pageSize success:^(GCThreadDetailModel *model) {
            @strongify(self);
            self.model = model;
            self.loaded = true;
            self.uid = model.member_uid;
            self.fid = model.fid;
            self.formhash = model.formhash;
            self.threadSubject = model.subject;
            if ([model.postlist isKindOfClass:[NSArray class]] && model.postlist.count > 0) {
                GCThreadDetailPostModel * threadDetailPostModel = [model.postlist objectAtIndex:0];
                self.threadContent = threadDetailPostModel.message;
            }
                        
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
            @strongify(self);
            [self.threadDetailView webViewEndRefresh];
            [self.threadDetailView webViewEndFetchMore];
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"No Network Connection", nil)];
        }];
    };
    
    self.replyBlock = ^{
        @strongify(self);
        if ([self.uid isEqualToString:@"0"]) {
            [self presentLoginViewController];
        } else {
            GCReplyThreadViewController *controller = [[GCReplyThreadViewController alloc] init];
            controller.fid = self.fid;
            controller.tid = self.tid;
            controller.formhash = self.formhash;
            GCNavigationController *navigationController = [[GCNavigationController alloc] initWithRootViewController:controller];
            [self presentViewController:navigationController animated:YES completion:nil];
        }
    };
    self.favoriteBlock = ^{
        @strongify(self);
        if ([self.uid isEqualToString:@"0"]) {
            [self presentLoginViewController];
        } else {
            [GCNetworkManager getCollectionWithTid:self.tid formhash:self.formhash success:^(NSString *string){
                [SVProgressHUD showSuccessWithStatus:string];
            } failure:^(NSError *error) {
                [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Collect Failure", nil)];
            }];
        }
    };
    self.reportBlock = ^{
        @strongify(self);
        GCReportThreadViewController *controller = [[GCReportThreadViewController alloc] init];
        controller.tid = self.tid;
        GCNavigationController *navigationController = [[GCNavigationController alloc] initWithRootViewController:controller];
        [self presentViewController:navigationController animated:YES completion:nil];
    };
}

- (void)beginRefresh {
    self.refreshBlock(^(GCThreadDetailModel *model) {
        [self.htmlString setString:[model getGCThreadDetailModelHtml]];
        [self.threadDetailView.webView loadHTMLString:self.htmlString baseURL:[Util getBundlePathURL]];
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
            [self.threadDetailView.webView loadHTMLString:self.htmlString baseURL:[Util getBundlePathURL]];
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
            [self.threadDetailView.webView loadHTMLString:self.htmlString baseURL:[Util getBundlePathURL]];
            
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
            [self.threadDetailView.webView loadHTMLString:self.htmlString baseURL:[Util getBundlePathURL]];
            
            [self.threadDetailView webViewEndFetchMore];
        });
    }
}

- (void)presentLoginViewController {
    GCLoginViewController *loginViewController = [[GCLoginViewController alloc] initWithNibName:@"GCLoginViewController" bundle:nil];
    GCNavigationController *navigationController = [[GCNavigationController alloc] initWithRootViewController:loginViewController];
    [self presentViewController:navigationController animated:YES completion:nil];
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
        _threadDetailView.replyActionBlock = ^{
            @strongify(self);
            self.replyBlock();
        };
    }
    return _threadDetailView;
}

- (DOPNavbarMenu *)menu {
    if (!_menu) {
        DOPNavbarMenuItem *replyItem = [DOPNavbarMenuItem ItemWithTitle:NSLocalizedString(@"Reply", nil)
                                                                   icon:[[UIImage imageNamed:@"icon_reply"] imageWithTintColor:[GCColor grayColor1]]
                                                                    row:0
                                                            actionBlock:self.replyBlock];
        DOPNavbarMenuItem *favoriteItem = [DOPNavbarMenuItem ItemWithTitle:NSLocalizedString(@"Favorite", nil)
                                                                      icon:[[UIImage imageNamed:@"icon_collect"] imageWithTintColor:[GCColor grayColor1]]
                                                                       row:0
                                                               actionBlock:self.favoriteBlock];
        DOPNavbarMenuItem *copyItem = [DOPNavbarMenuItem ItemWithTitle:NSLocalizedString(@"Copy URL", nil)
                                                                  icon:[[UIImage imageNamed:@"icon_link"] imageWithTintColor:[GCColor grayColor1]]
                                                                   row:0
                                                           actionBlock:^{
                                                               [Util copyToPasteboard:GCNETWORKAPI_URL_THREAD(self.tid)];
                                                               [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Copy Complete", nil)];
                                                           }];
        DOPNavbarMenuItem *refreshItem = [DOPNavbarMenuItem ItemWithTitle:NSLocalizedString(@"Refresh", nil)
                                                                     icon:[[UIImage imageNamed:@"icon_refresh"] imageWithTintColor:[GCColor grayColor1]]
                                                                      row:0
                                                              actionBlock:^{
                                                                  [self.threadDetailView webViewStartRefresh];
                                                              }];
        DOPNavbarMenuItem *reportItem = [DOPNavbarMenuItem ItemWithTitle:NSLocalizedString(@"Report", nil)
                                                                    icon:[[UIImage imageNamed:@"icon_error"] imageWithTintColor:[GCColor grayColor1]]
                                                                     row:0
                                                             actionBlock:self.reportBlock];
        
        DOPNavbarMenuItem *safariItem = [DOPNavbarMenuItem ItemWithTitle:NSLocalizedString(@"Open in Safari", nil)
                                                                    icon:[UIImage imageNamed:@"icon_safari"]
                                                                     row:1
                                                             actionBlock:^{
                                                                 [Util openUrlInSafari:GCNETWORKAPI_URL_THREAD(self.tid)];
                                                             }];
        
        NSMutableArray *shareArray = [NSMutableArray arrayWithObjects:replyItem, favoriteItem, copyItem, refreshItem, reportItem, safariItem, nil];

        if ([GCSocial WXAppInstalled]) {
            DOPNavbarMenuItem *wechatSessionItem = [DOPNavbarMenuItem ItemWithTitle:NSLocalizedString(@"Wechat Session", nil)
                                                                               icon:[UIImage imageNamed:@"icon_wechatSession"]
                                                                                row:1
                                                                        actionBlock:^{
                                                                            [GCSocial ShareToWechatSession:GCNETWORKAPI_URL_THREAD(self.tid) title:self.threadSubject content:self.threadContent Success:^{
                                                                                
                                                                            } failure:^{
                                                                                
                                                                            }];
                                                                        }];
            
            [shareArray addObject:wechatSessionItem];
        }
        if ([GCSocial WXAppInstalled]) {
            DOPNavbarMenuItem *wechatTimelineItem = [DOPNavbarMenuItem ItemWithTitle:NSLocalizedString(@"Wechat Timeline", nil)
                                                                                icon:[UIImage imageNamed:@"icon_wechatTimeline"]
                                                                                 row:1
                                                                         actionBlock:^{
                                                                             [GCSocial ShareToWechatTimeline:GCNETWORKAPI_URL_THREAD(self.tid) title:self.threadSubject Success:^{
                                                                                 
                                                                             } failure:^{
                                                                                 
                                                                             }];
                                                                         }];
            
            [shareArray addObject:wechatTimelineItem];
        }
        if ([GCSocial QQInstalled]) {
            DOPNavbarMenuItem *qqItem = [DOPNavbarMenuItem ItemWithTitle:NSLocalizedString(@"QQ", nil)
                                                                    icon:[UIImage imageNamed:@"icon_qq"]
                                                                     row:1
                                                             actionBlock:^{
                                                                 [GCSocial ShareToQQ:GCNETWORKAPI_URL_THREAD(self.tid) title:self.threadSubject content:self.threadContent Success:^{
                                                                     
                                                                 } failure:^{
                                                                     
                                                                 }];
                                                             }];
            
            [shareArray addObject:qqItem];
        }
   
        _menu = [[DOPNavbarMenu alloc] initWithRowItems:shareArray];
    }
    
    return _menu;
}

@end
