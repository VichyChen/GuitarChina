//
//  AppDelegate.m
//  GuitarChina
//
//  Created by 陈大捷 on 15/8/19.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "AppDelegate.h"
#import "GCNavigationController.h"
#import "GCDiscoveryViewController.h"
#import "GCForumIndexViewController.h"
#import "GCMoreViewController.h"
//#import "MobClick.h"
#import <UMengAnalytics/UMMobClick/MobClick.h>
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "IQKeyboardManager.h"
#import "KeyboardManager.h"
#import "GCReplyThreadViewController.h"
#import "GCReportThreadViewController.h"
#import "GCHTMLParse.h"
#import "GDTSplashAd.h"

@interface AppDelegate () <GDTSplashAdDelegate>

@property (strong, nonatomic) GDTSplashAd *splash;
@property (retain, nonatomic) UIView *bottomView;

//相机
@property (nonatomic, strong) UIImagePickerController *cameraImagePicker;
//相册
@property (nonatomic, strong) UIImagePickerController *albumImagePicker;

@end

@implementation AppDelegate

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    if ([self firstStart]) {
        [NSUD setBool:YES forKey:kGCAutoSwitchNightMode];
        [NSUD setBool:YES forKey:kGCLoadImage];
        [NSUD setObject:@[] forKey:kGCForumBrowseRecord];
        [NSUD synchronize];
    }
    
    //设置MagicalRecord
    [self setupMagicalRecord];
    
    //友盟统计
    [self UMengAnalytics];
    //友盟分享
    [self UMengSocial];
    
    [self configureIQKeyboardManager];
    [self configureForumDictionary];
    [self configureSVProgressHUD];
    [self configureTabBarController];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    
#if FREEVERSION
    [self setupADInterstitialTime];
    [self configureSplashAd];
#endif
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
#if FREEVERSION
    NSDate *date = [Util getNSDateWithDateString:[NSUD stringForKey:kGCToday] format:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeInterval timeInterVal = -[date timeIntervalSinceDate:[Util getDate]];
    if (timeInterVal > kGDTSplashTShowTimeInterVal) {
        [self setupADInterstitialTime];
        [self configureSplashAd];
    }
#endif
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url {
    return [UMSocialSnsService handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [UMSocialSnsService handleOpenURL:url];
}

#pragma mark - GDTSplashAdDelegate

/**
 *  开屏广告成功展示
 */
-(void)splashAdSuccessPresentScreen:(GDTSplashAd *)splashAd {
    NSLog(@"GDT开屏广告成功展示");
    [GCStatistics event:GCStatisticsEventGDTSplashShowSuccess extra:nil];
}

/**
 *  开屏广告展示失败
 */
- (void)splashAdFailToPresent:(GDTSplashAd *)splashAd withError:(NSError *)error {
    NSLog(@"GDT开屏广告展示失败");
    NSString *errorInfo = error.userInfo[@"NSLocalizedDescription"];
    [GCStatistics event:GCStatisticsEventGDTSplashShowFailure extra:@{ @"error" : String(errorInfo)}];
}

/**
 *  应用进入后台时回调
 *  详解: 当点击下载应用时会调用系统程序打开，应用切换到后台
 */
- (void)splashAdApplicationWillEnterBackground:(GDTSplashAd *)splashAd {
    NSLog(@"GDT应用进入后台时回调");}

/**
 *  开屏广告点击回调
 */
- (void)splashAdClicked:(GDTSplashAd *)splashAd {
    NSLog(@"GDT开屏广告点击回调");
    [GCStatistics event:GCStatisticsEventGDTSplashClick extra:nil];
}

/**
 *  开屏广告将要关闭回调
 */
- (void)splashAdWillClosed:(GDTSplashAd *)splashAd {
    NSLog(@"GDT开屏广告将要关闭回调");
}

/**
 *  开屏广告关闭回调
 */
- (void)splashAdClosed:(GDTSplashAd *)splashAd {
    NSLog(@"GDT开屏广告关闭回调");
    self.splash = nil;
}

/**
 *  开屏广告点击以后即将弹出全屏广告页
 */
- (void)splashAdWillPresentFullScreenModal:(GDTSplashAd *)splashAd {
    NSLog(@"GDT开屏广告点击以后即将弹出全屏广告页");
}

/**
 *  开屏广告点击以后弹出全屏广告页
 */
- (void)splashAdDidPresentFullScreenModal:(GDTSplashAd *)splashAd {
    NSLog(@"GDT开屏广告点击以后弹出全屏广告页");
}

/**
 *  点击以后全屏广告页将要关闭
 */
- (void)splashAdWillDismissFullScreenModal:(GDTSplashAd *)splashAd  {
    NSLog(@"GDT点击以后全屏广告页将要关闭");
}

/**
 *  点击以后全屏广告页已经关闭
 */
- (void)splashAdDidDismissFullScreenModal:(GDTSplashAd *)splashAd  {
    NSLog(@"GDT点击以后全屏广告页已经关闭");
}

/**
 * 开屏广告剩余时间回调
 */
- (void)splashAdLifeTime:(NSUInteger)time {
    NSLog(@"GDT开屏广告剩余时间回调 %ld", time);
}

#pragma mark - Public Methods

- (void)selectImage:(UIViewController *)controller success:(void(^)(UIImage *image, NSDictionary *info))success {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] bk_initWithTitle:@"选择图片"];
    @weakify(self);
    [actionSheet bk_addButtonWithTitle:@"拍照" handler:^{
        @strongify(self);
        self.cameraImagePicker.bk_didFinishPickingMediaBlock = ^(UIImagePickerController *picker, NSDictionary *info) {
            @strongify(self);
            UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
            [self.cameraImagePicker dismissViewControllerAnimated:YES completion:^{
                success(image, info);
            }];
        };
        [controller presentViewController:self.cameraImagePicker animated:YES completion:nil];
    }];
    [actionSheet bk_addButtonWithTitle:@"从相册选择" handler:^{
        @strongify(self);
        self.albumImagePicker.bk_didFinishPickingMediaBlock = ^(UIImagePickerController *picker, NSDictionary *info) {
            @strongify(self);
            UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
            [self.albumImagePicker dismissViewControllerAnimated:YES completion:^{
                success(image, info);
            }];
        };
        [controller presentViewController:self.albumImagePicker animated:YES completion:nil];
    }];
    [actionSheet bk_setCancelButtonWithTitle:@"取消" handler:^{
        
    }];
    [actionSheet showInView:controller.view];
}

#pragma mark - UMengAnalytics

- (void)UMengAnalytics {
    UMAnalyticsConfig *config = [[UMAnalyticsConfig alloc] init];
    config.appKey = kUmengAppKey;
    [MobClick startWithConfigure:config];
    [MobClick setAppVersion:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    [MobClick setEncryptEnabled:YES];
}

#pragma mark - UMengSocial

- (void)UMengSocial {
    [UMSocialData setAppKey:kUmengAppKey];
    //设置微信AppID、appSecret
    [UMSocialWechatHandler setWXAppId:kWechatAppID appSecret:kWechatAppSecret url:nil];
    //设置QQAppID、appKey
    [UMSocialQQHandler setQQWithAppId:kQQAppID appKey:kQQAppKey url:@"http://www.umeng.com/social"];
}

- (void)configureTabBarController {
    self.tabBarController = [[GCTabBarController alloc]init];
}

- (void)configureSplashAd {
    NSString *imageName;
    CGRect defaultImageRect;
    CGRect bottomViewImageRect;
    //4
    if (kScreenWidth == 320) {
        imageName = @"AdLaunchImage_640_1136";
        defaultImageRect = CGRectMake(0, 0, 640, 1136);
        bottomViewImageRect = CGRectMake(0, 1136 - 200, 640, 200);
    }
    //4.7
    else if (kScreenWidth == 375 && kScreenHeight == 667) {
        imageName = @"AdLaunchImage_750_1334";
        defaultImageRect = CGRectMake(0, 0, 750, 1334);
        bottomViewImageRect = CGRectMake(0, 1334 - 200, 750, 200);
    }
    //5.5
    else if (kScreenWidth == 414) {
        imageName = @"AdLaunchImage_1242_2208";
        defaultImageRect = CGRectMake(0, 0, 1242, 2208);
        bottomViewImageRect = CGRectMake(0, 2208 - 300, 1242, 300);
    }
    //5.8
    else if (kScreenWidth == 375 && kScreenHeight == 812) {
        imageName = @"AdLaunchImage_750_1334";
        defaultImageRect = CGRectMake(0, 0, 750, 1334);
        bottomViewImageRect = CGRectMake(0, 1334 - 200, 750, 200);
    }
    //!@#$%^&*()
    else {
        imageName = @"AdLaunchImage_640_1136";
        defaultImageRect = CGRectMake(0, 0, 640, 1136);
        bottomViewImageRect = CGRectMake(0, 1136 - 200, 640, 200);
    }
    
    self.splash = [[GDTSplashAd alloc] initWithAppkey:kGDTAppKey placementId:kGDTSplashPlacementID];
    self.splash.fetchDelay = 3;
    self.splash.delegate = self;
    UIImage *defaultImage = [[[UIImage imageNamed:imageName] cutWithRect:defaultImageRect] resize:CGSizeMake(kScreenWidth, kScreenHeight)];
    self.splash.backgroundColor = [UIColor colorWithPatternImage:defaultImage];
    
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 100, kScreenWidth, 100)];
    UIImage *bottomImage = [[[UIImage imageNamed:imageName] cutWithRect:bottomViewImageRect] resize:self.bottomView.frame.size];
    self.bottomView.backgroundColor = [UIColor colorWithPatternImage:bottomImage];
    
    [self.splash loadAdAndShowInWindow:APP.window withBottomView:self.bottomView];
    
    //    [APP.window addSubview:self.bottomView];
    //    [self.splash loadAdAndShowInWindow:APP.window];
}

- (void)configureSVProgressHUD {
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setBackgroundColor:[GCColor grayColor2]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
}

- (void)configureForumDictionary {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ForumList" ofType:@"plist"];
    self.forumDictionary = [NSDictionary dictionaryWithContentsOfFile:path];
}

- (void)configureIQKeyboardManager {
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [[IQKeyboardManager sharedManager] disableInViewControllerClass:[GCReplyThreadViewController class]];
    [[IQKeyboardManager sharedManager] disableInViewControllerClass:[GCReportThreadViewController class]];
}

- (BOOL)firstStart {
    BOOL result = [NSUD boolForKey:kGCFirstStart];
    if (result) {
        return NO;
    }
    else {
        [NSUD setBool:YES forKey:kGCFirstStart];
        [NSUD synchronize];
        return YES;
    }
}

- (void)setupADInterstitialTime {
    [NSUD setObject:[Util getDateStringWithNSDate:[Util getDate] format:@"yyyy-MM-dd HH:mm:ss"] forKey:kGCToday];
    [NSUD synchronize];
}

#pragma mark - MagicalRecord

- (void)setupMagicalRecord {
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"GuitarChina.sqlite"];
}

- (void)saveContext {
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

#pragma mark - Getters

- (UIImagePickerController *)cameraImagePicker {
    if (!_cameraImagePicker) {
        _cameraImagePicker = [[UIImagePickerController alloc]init];
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [_cameraImagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        } else {
            [_cameraImagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        }
        _cameraImagePicker.allowsEditing = NO;
        _cameraImagePicker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *)kUTTypeImage, nil];
        @weakify(self);
        _cameraImagePicker.bk_didCancelBlock = ^(UIImagePickerController *picker) {
            @strongify(self);
            [self.cameraImagePicker dismissViewControllerAnimated:YES completion:nil];
        };
    }
    
    return _cameraImagePicker;
}

- (UIImagePickerController *)albumImagePicker {
    if (!_albumImagePicker) {
        _albumImagePicker = [[UIImagePickerController alloc]init];
        [_albumImagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        _albumImagePicker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *)kUTTypeImage, nil];
        _albumImagePicker.allowsEditing = NO;
        @weakify(self);
        _albumImagePicker.bk_didCancelBlock = ^(UIImagePickerController *picker) {
            @strongify(self);
            [self.albumImagePicker dismissViewControllerAnimated:YES completion:nil];
        };
    }
    
    return _albumImagePicker;
}

@end
