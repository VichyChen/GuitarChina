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

@end

@implementation AppDelegate

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [GCNetworkManager getSearchSuccess:^(NSData *htmlData) {
        NSLog(@"%@", htmlData);
    } failure:^(NSError *error) {
        
    }];
    
    if ([self firstStart]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kGCAUTOSWITCHNIGHTMODE];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kGCLOADIMAGE];
        [[NSUserDefaults standardUserDefaults] setObject:@[] forKey:kFORUMBROWSERECORD];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kGCNIGHTMODE]) {
        [DKNightVersionManager nightFalling];
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
    //    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
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
    [MobClick startWithAppkey:kUMENG_APPKEY reportPolicy:BATCH channelId:@""];
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
    [UMSocialData setAppKey:kUMENG_APPKEY];
    //设置微信AppID、appSecret
    [UMSocialWechatHandler setWXAppId:kWECHAT_APPID appSecret:kWECHAT_APPSECRET url:nil];
    //设置QQAppID、appKey
    [UMSocialQQHandler setQQWithAppId:kQQ_APPID appKey:kQQ_APPKEY url:@"http://www.umeng.com/social"];
}

#pragma mark - Private Methods

- (void)configureTabBarController {
    self.tabBarController = [[GCTabBarController alloc]init];
    
    GCDiscoveryViewController *discoveryViewController = [[GCDiscoveryViewController alloc] init];
    GCNavigationController *discoveryNavigationController = [[GCNavigationController alloc] initWithRootViewController:discoveryViewController];
    discoveryNavigationController.tabBarItem.title = NSLocalizedString(@"Home", nil);
    discoveryNavigationController.tabBarItem.image = [UIImage imageNamed:@"icon_guitar"];
    discoveryNavigationController.tabBarItem.selectedImage = [UIImage imageNamed:@"icon_guitar_on"];
    
    GCForumIndexViewController *forumIndexViewController = [[GCForumIndexViewController alloc] init];
    GCNavigationController *forumIndexNavigationController = [[GCNavigationController alloc] initWithRootViewController:forumIndexViewController];
    forumIndexNavigationController.tabBarItem.title = NSLocalizedString(@"Forum", nil);
    forumIndexNavigationController.tabBarItem.image = [[UIImage imageNamed:@"icon_wave"] imageWithTintColor:[UIColor GCDeepGrayColor]];
    forumIndexNavigationController.tabBarItem.selectedImage = [[UIImage imageNamed:@"icon_wave_on"] imageWithTintColor:[UIColor GCDeepGrayColor]];
    
    GCUserViewController *userViewController = [[GCUserViewController alloc] init];
    GCNavigationController *userNavigationController = [[GCNavigationController alloc] initWithRootViewController:userViewController];
    userNavigationController.tabBarItem.title = NSLocalizedString(@"Me", nil);
    userNavigationController.tabBarItem.image = [UIImage imageNamed:@"icon_ musicconductor"];
    userNavigationController.tabBarItem.selectedImage = [UIImage imageNamed:@"icon_ musicconductor_on"];
    
    GCMoreViewController *moreViewController = [[GCMoreViewController alloc] init];
    GCNavigationController *moreNavigationController = [[GCNavigationController alloc] initWithRootViewController:moreViewController];
    moreNavigationController.tabBarItem.title = NSLocalizedString(@"More", nil);
    moreNavigationController.tabBarItem.image = [UIImage imageNamed:@"icon_musicrecord"];
    moreNavigationController.tabBarItem.selectedImage = [UIImage imageNamed:@"icon_musicrecord_on"];
    
    self.tabBarController.viewControllers = @[discoveryNavigationController, forumIndexNavigationController, userNavigationController, moreNavigationController];
}

- (void)configureSVProgressHUD {
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setBackgroundColor:[UIColor GCDeepGrayColor]];
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
    BOOL result = [[NSUserDefaults standardUserDefaults] boolForKey:kGCFIRSTSTART];
    if (result) {
        return NO;
    }
    else {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kGCFIRSTSTART];
        [[NSUserDefaults standardUserDefaults] synchronize];
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
