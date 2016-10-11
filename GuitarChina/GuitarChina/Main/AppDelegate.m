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
#import "GCUserViewController.h"
#import "GCAboutViewController.h"
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
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
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

#pragma mark - MagicalRecord

- (void)setupMagicalRecord {
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"GuitarChina.sqlite"];
}

- (void)saveContext {
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

@end
