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
#import "MobClick.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "IQKeyboardManager.h"
#import "KeyboardManager.h"
#import "GCReplyThreadViewController.h"
#import "GCReportThreadViewController.h"
#import "GCHTMLParse.h"

@interface AppDelegate ()

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
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    
    if (kIsFree) {
        [self setupADInterstitialTime];
        self.adInterstitial = [[GCAdInterstitial alloc] init];

        self.adCenterBannerView = [[GCAdCenterBannerView alloc] init];
        [self.adCenterBannerView showAfterSecond:kAdMobCenterBannerViewFirstTime];
        [self.adCenterBannerView showAfterSecond:kAdMobCenterBannerViewSecondTime];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    if (kIsFree) {
        NSDate *date = [Util getNSDateWithDateString:[NSUD stringForKey:kGCToday] format:@"yyyy-MM-dd HH:mm:ss"];
        NSTimeInterval timeInterVal = -[date timeIntervalSinceDate:[Util getDate]];
        if (timeInterVal > kAdMobEnterForegroundTimeInterval) {
            [self setupADInterstitialTime];
            [self.adInterstitial presentFromRootViewController];
        }
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
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
    [MobClick startWithAppkey:kUmengAppKey reportPolicy:BATCH channelId:@""];
    //version标识
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    //日志加密
    [MobClick setEncryptEnabled:YES];
    //禁止后台模式
    [MobClick setBackgroundTaskEnabled:NO];
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
