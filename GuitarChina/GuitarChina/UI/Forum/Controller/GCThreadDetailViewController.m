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
#import "GCThreadDetailMenuView.h"
#import "GCSocial.h"
#import "ZLPhoto.h"
#import "GCProfileViewController.h"
#import "GCForumDisplayViewController.h"

@interface GCThreadDetailViewController () <UIWebViewDelegate, ZLPhotoPickerBrowserViewControllerDataSource,ZLPhotoPickerBrowserViewControllerDelegate> {
    
}

@property (nonatomic, assign) CGFloat offsetY;
@property (nonatomic, assign) BOOL loaded;
@property (nonatomic, assign) NSInteger tabBarSelectedIndex;

@property (nonatomic, strong) GCThreadDetailView *threadDetailView;
@property (nonatomic, strong) GCThreadDetailMenuView *menu;

@property (nonatomic, copy) void (^refreshBlock)();
@property (nonatomic, copy) void (^replyBlock)();       //回复
@property (nonatomic, copy) void (^favoriteBlock)();    //收藏
@property (nonatomic, copy) void (^reportBlock)();      //举报


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
    [GCStatistics event:GCStatisticsEventThreadDetail extra:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    if (self.menu) {
        [self.menu dismissMenu];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)dealloc {
    NSLog(@"GCThreadDetailViewController dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
            
            return NO;
        }
        //个人资料
        if ([request.mainDocumentURL.relativeString startsWith:@"http://guitarchina.app/?uid="]) {
            GCProfileViewController *controller = [[GCProfileViewController alloc] init];
            controller.uid = [Util parseURLQueryStringToDictionary:[NSURL URLWithString:request.mainDocumentURL.relativeString]][@"uid"];
            [self.navigationController pushViewController:controller animated:YES];
            
            return NO;
        }
        //引用回复
        if ([request.mainDocumentURL.relativeString startsWith:@"http://guitarchina.app/?type=reference"]) {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
            @weakify(self);
            [actionSheet bk_addButtonWithTitle:@"引用" handler:^{
                @strongify(self);
                self.replyBlock([Util parseURLQueryStringToDictionary:[NSURL URLWithString:request.mainDocumentURL.relativeString]][@"page"], [Util parseURLQueryStringToDictionary:[NSURL URLWithString:request.mainDocumentURL.relativeString]][@"repquote"]);
            }];
            [actionSheet bk_addButtonWithTitle:@"举报" handler:^{
                @strongify(self);
                self.reportBlock();
            }];
            [actionSheet bk_setCancelButtonWithTitle:@"取消" handler:^{
            }];
            [actionSheet showInView:self.view];
            return NO;
        }
        //优酷视频
        if ([request.mainDocumentURL.relativeString startsWith:@"http://player.youku.com/player.php/sid/"] && [request.mainDocumentURL.relativeString endsWith:@".swf"]) {
            NSArray *array = [request.mainDocumentURL.relativeString split:@"/"];
            GCWebViewController *controller = [[GCWebViewController alloc] init];
            controller.urlString = GCVideo_URL_Youku([array objectAtIndex:5]);
            [self.navigationController pushViewController:controller animated:YES];
            
            return NO;
        }
        //土豆视频
        if ([request.mainDocumentURL.relativeString startsWith:@"http://www.tudou.com/v/"] && [request.mainDocumentURL.relativeString endsWith:@".swf"]) {
            NSArray *array = [request.mainDocumentURL.relativeString split:@"/"];
            GCWebViewController *controller = [[GCWebViewController alloc] init];
            controller.urlString = GCVideo_URL_Tudou([array objectAtIndex:4]);
            [self.navigationController pushViewController:controller animated:YES];
            
            return NO;
        }
        //GC帖子
        if ([request.mainDocumentURL.relativeString startsWith:@"https://bbs.guitarchina.com/thread-"] && [request.mainDocumentURL.relativePath endsWith:@".html"]) {
            NSArray *array = [request.mainDocumentURL.relativeString split:@"-"];
            GCThreadDetailViewController *controller = [[GCThreadDetailViewController alloc] init];
            controller.tid = [array objectAtIndex:1];
            [self.navigationController pushViewController:controller animated:YES];
            
            return NO;
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
            
            return NO;
        }
        //苹果商店地址
        if ([request.mainDocumentURL.relativeString startsWith:@"https://itunes.apple.com/cn/app/ji-ta-zhong-guo-hua-yu-di/"]) {

            return YES;
        }
        
        GCWebViewController *controller = [[GCWebViewController alloc] init];
        controller.urlString = request.mainDocumentURL.absoluteString;
        [self.navigationController pushViewController:controller animated:YES];
        
        return NO;
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
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(windowDidBecomeHidden:) name:UIWindowDidBecomeHiddenNotification object:nil];
}

-(void)windowDidBecomeHidden:(NSNotification *)nitice
{
    UIWindow * window = (UIWindow *)nitice.object;
    if(window){
        UIViewController *rootViewController = window.rootViewController;
        NSArray<__kindof UIViewController *> *viewVCArray = rootViewController.childViewControllers;
        if([viewVCArray.firstObject isKindOfClass:NSClassFromString(@"AVPlayerViewController")]){
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
        }
    }
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
    if (self.menu.open) {
        [self.menu dismissMenu];
    } else {
        [self.menu showInNavigationController:self.navigationController];
    }
}

#pragma mark - Private Methods

- (void)configureView {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"";
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 25, 25);
    [leftButton setAdjustsImageWhenHighlighted:YES];
    UIImage *image = [UIImage imageNamed:@"icon_bigellipsis"];
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
            
            self.threadDetailView.pagePickerView.pickerViewCount = self.pageCount;
            self.threadDetailView.pagePickerView.pickerViewIndex = self.pageIndex - 1;
            
            UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
            UILabel *label = [[UILabel alloc] init];
            label.frame = CGRectMake(0, 0, 200, 44);
            label.text = [APP.forumDictionary objectForKey: self.model.fid];
            label.textColor = [UIColor whiteColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:17];
            [titleView addSubview:label];
            self.navigationItem.titleView = titleView;
            @weakify(self);
            [titleView bk_whenTapped:^{
                @strongify(self);
                GCForumDisplayViewController *controller = [[GCForumDisplayViewController alloc] init];
                controller.title = [APP.forumDictionary objectForKey: self.model.fid];
                controller.fid = self.model.fid;
                [self.navigationController pushViewController:controller animated:YES];
            }];
            
            success(model);
            [self.threadDetailView showOtherView];
        } failure:^(NSError *error) {
            @strongify(self);
            [self.threadDetailView webViewEndRefresh];
            [self.threadDetailView webViewEndFetchMore];
            [SVProgressHUD showErrorWithStatus:@"没有网络连接！"];
        }];
    };
    
    self.replyBlock = ^(NSString *page, NSString *repquote){
        @strongify(self);
        if ([self.uid isEqualToString:@"0"]) {
            [self presentLoginViewController];
        } else {
            GCReplyThreadViewController *controller = [[GCReplyThreadViewController alloc] init];
            controller.fid = self.fid;
            controller.tid = self.tid;
            controller.formhash = self.formhash;
            controller.page = page;
            controller.repquote = repquote;
            @weakify(self);
            controller.replySuccessBlock = ^{
                @strongify(self);
                self.pageIndex = 1;
                [self.threadDetailView webViewStartRefresh];
            };
            [self.navigationController pushViewController:controller animated:YES];
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
                [SVProgressHUD showErrorWithStatus:@"收藏失败"];
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
        [self.threadDetailView.toolBarView.pageButton setTitle:[NSString stringWithFormat:@"%ld / %ld", self.pageIndex, self.pageCount] forState:UIControlStateNormal];
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
        [self.threadDetailView.toolBarView.pageButton setTitle:[NSString stringWithFormat:@"%ld / %ld", self.pageIndex, self.pageCount] forState:UIControlStateNormal];
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
        [self.threadDetailView.toolBarView.pageButton setTitle:[NSString stringWithFormat:@"%ld / %ld", self.pageIndex, self.pageCount] forState:UIControlStateNormal];
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
        _threadDetailView = [[GCThreadDetailView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigatioinBarHeight)];
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
            self.replyBlock(@"", @"");
        };
    }
    return _threadDetailView;
}

- (GCThreadDetailMenuView *)menu {
    if (!_menu) {
        @weakify(self);
        GCThreadDetailMenuItem *replyItem = [GCThreadDetailMenuItem itemWithTitle:@"回复"
                                                                   icon:[[UIImage imageNamed:@"icon_reply"] imageWithTintColor:[GCColor grayColor1]]
                                                                    row:0
                                                                      actionBlock:^{
                                                                          @strongify(self);
                                                                          self.replyBlock(@"", @"");
                                                                      }];
        GCThreadDetailMenuItem *favoriteItem = [GCThreadDetailMenuItem itemWithTitle:@"收藏"
                                                                      icon:[[UIImage imageNamed:@"icon_collect"] imageWithTintColor:[GCColor grayColor1]]
                                                                       row:0
                                                               actionBlock:self.favoriteBlock];
        GCThreadDetailMenuItem *copyItem = [GCThreadDetailMenuItem itemWithTitle:@"复制链接"
                                                                  icon:[[UIImage imageNamed:@"icon_link"] imageWithTintColor:[GCColor grayColor1]]
                                                                   row:0
                                                           actionBlock:^{
                                                               @strongify(self);
                                                               [Util copyToPasteboard:GCNetworkAPI_URL_Thread(self.tid)];
                                                               [SVProgressHUD showSuccessWithStatus:@"已复制"];
                                                           }];
        GCThreadDetailMenuItem *refreshItem = [GCThreadDetailMenuItem itemWithTitle:@"刷新"
                                                                     icon:[[UIImage imageNamed:@"icon_refresh"] imageWithTintColor:[GCColor grayColor1]]
                                                                      row:0
                                                              actionBlock:^{
                                                                  @strongify(self);
                                                                  [self.threadDetailView webViewStartRefresh];
                                                              }];
        GCThreadDetailMenuItem *reportItem = [GCThreadDetailMenuItem itemWithTitle:@"举报"
                                                                    icon:[[UIImage imageNamed:@"icon_error"] imageWithTintColor:[GCColor grayColor1]]
                                                                     row:0
                                                             actionBlock:self.reportBlock];
        
        GCThreadDetailMenuItem *safariItem = [GCThreadDetailMenuItem itemWithTitle:@"在Safari中打开"
                                                                    icon:[UIImage imageNamed:@"icon_safari"]
                                                                     row:1
                                                             actionBlock:^{
                                                                 @strongify(self);
                                                                 [Util openUrlInSafari:GCNetworkAPI_URL_Thread(self.tid)];
                                                             }];
        
        NSMutableArray *shareArray = [NSMutableArray arrayWithObjects:replyItem, favoriteItem, copyItem, refreshItem, reportItem, safariItem, nil];

        if ([GCSocial WXAppInstalled]) {
            GCThreadDetailMenuItem *wechatSessionItem = [GCThreadDetailMenuItem itemWithTitle:@"微信好友"
                                                                               icon:[UIImage imageNamed:@"icon_wechatSession"]
                                                                                row:1
                                                                        actionBlock:^{
                                                                            @strongify(self);
                                                                            [GCSocial ShareToWechatSession:GCNetworkAPI_URL_Thread(self.tid) title:self.threadSubject content:self.threadContent Success:^{
                                                                                
                                                                            } failure:^{
                                                                                
                                                                            }];
                                                                        }];
            
            [shareArray addObject:wechatSessionItem];
        }
        if ([GCSocial WXAppInstalled]) {
            GCThreadDetailMenuItem *wechatTimelineItem = [GCThreadDetailMenuItem itemWithTitle:@"朋友圈"
                                                                                icon:[UIImage imageNamed:@"icon_wechatTimeline"]
                                                                                 row:1
                                                                         actionBlock:^{
                                                                             @strongify(self);
                                                                             [GCSocial ShareToWechatTimeline:GCNetworkAPI_URL_Thread(self.tid) title:self.threadSubject Success:^{
                                                                                 
                                                                             } failure:^{
                                                                                 
                                                                             }];
                                                                         }];
            
            [shareArray addObject:wechatTimelineItem];
        }
        if ([GCSocial QQInstalled]) {
            GCThreadDetailMenuItem *qqItem = [GCThreadDetailMenuItem itemWithTitle:@"QQ好友"
                                                                    icon:[UIImage imageNamed:@"icon_qq"]
                                                                     row:1
                                                             actionBlock:^{
                                                                 @strongify(self);
                                                                 [GCSocial ShareToQQ:GCNetworkAPI_URL_Thread(self.tid) title:self.threadSubject content:self.threadContent Success:^{
                                                                     
                                                                 } failure:^{
                                                                     
                                                                 }];
                                                             }];
            
            [shareArray addObject:qqItem];
        }
   
        _menu = [[GCThreadDetailMenuView alloc] initWithRowItems:shareArray];
    }
    
    return _menu;
}

@end
