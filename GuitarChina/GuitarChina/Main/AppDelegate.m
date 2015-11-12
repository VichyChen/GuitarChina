//
//  AppDelegate.m
//  GuitarChina
//
//  Created by 陈大捷 on 15/8/19.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "AppDelegate.h"
#import "GCNavigationController.h"
#import "GCHotThreadViewController.h"
#import "GCForumIndexViewController.h"
#import "GCMineViewController.h"
#import "GCSettingViewController.h"
#import "GCMoreViewController.h"
#import "MobClick.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [cookieJar cookies]) {
        NSLog(@"%@", cookie);
    }
    
    //友盟统计
    [self UMengAnalytics];
    //友盟分享
    [self UMengSocial];
    [self configureForumDictionary];
    [self configureSVProgressHUD];
    [self configureTabBarController];
    [self configureSideMenuViewController];

    self.window.rootViewController = self.sideMenuViewController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {

}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [self saveCookie];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {

}

- (void)applicationDidBecomeActive:(UIApplication *)application {

}

- (void)applicationWillTerminate:(UIApplication *)application {
    [self saveCookie];
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

#pragma mark - RESideMenu Delegate

- (void)sideMenu:(RESideMenu *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"willShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu didShowMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"didShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu willHideMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"willHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu didHideMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"didHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
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
    //设置微信AppId、appSecret
    [UMSocialWechatHandler setWXAppId:kWECHAT_APPID appSecret:kWECHAT_APPSECRET url:nil];
}

#pragma mark - Private Methods

- (void)configureTabBarController {
    self.tabBarController = [[GCTabBarController alloc]init];
    
    GCHotThreadViewController *hotThreadViewController = [[GCHotThreadViewController alloc] init];
    GCNavigationController *hotThreadNavigationController = [[GCNavigationController alloc] initWithRootViewController:hotThreadViewController];
    hotThreadNavigationController.tabBarItem.title = NSLocalizedString(@"Recent", nil);
    hotThreadNavigationController.tabBarItem.image = [UIImage imageNamed:@"icon_guitar"];
    hotThreadNavigationController.tabBarItem.selectedImage = [UIImage imageNamed:@"icon_guitar_on"];
    
    GCForumIndexViewController *forumIndexViewController = [[GCForumIndexViewController alloc] init];
    GCNavigationController *forumIndexNavigationController = [[GCNavigationController alloc] initWithRootViewController:forumIndexViewController];
    forumIndexNavigationController.tabBarItem.title = NSLocalizedString(@"Forum", nil);
    forumIndexNavigationController.tabBarItem.image = [[UIImage imageNamed:@"icon_wave"] imageWithTintColor:[UIColor GCDeepGrayColor]];
    forumIndexNavigationController.tabBarItem.selectedImage = [[UIImage imageNamed:@"icon_wave_on"] imageWithTintColor:[UIColor GCDeepGrayColor]];
    
    GCMineViewController *mineViewController = [[GCMineViewController alloc] init];
    GCNavigationController *mineNavigationController = [[GCNavigationController alloc] initWithRootViewController:mineViewController];
    mineNavigationController.tabBarItem.title = NSLocalizedString(@"Mine", nil);
    mineNavigationController.tabBarItem.image = [UIImage imageNamed:@"icon_ musicconductor"];
    mineNavigationController.tabBarItem.selectedImage = [UIImage imageNamed:@"icon_ musicconductor_on"];
    
    GCMoreViewController *moreViewController = [[GCMoreViewController alloc] init];
    GCNavigationController *moreNavigationController = [[GCNavigationController alloc] initWithRootViewController:moreViewController];
    moreNavigationController.tabBarItem.title = NSLocalizedString(@"More", nil);
    moreNavigationController.tabBarItem.image = [UIImage imageNamed:@"icon_musicrecord"];
    moreNavigationController.tabBarItem.selectedImage = [UIImage imageNamed:@"icon_musicrecord_on"];
    
    self.tabBarController.viewControllers = @[hotThreadNavigationController, forumIndexNavigationController, mineNavigationController, moreNavigationController];
}

- (void)configureSideMenuViewController {
    self.rightMenuViewController = [[GCThreadRightMenuViewController alloc] init];
    self.sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:self.tabBarController
                                                             leftMenuViewController:nil
                                                            rightMenuViewController:self.rightMenuViewController];
    self.sideMenuViewController.backgroundImage = [UIImage imageNamed:@"Stars"];
    self.sideMenuViewController.menuPreferredStatusBarStyle = 1;
    self.sideMenuViewController.delegate = self;
    self.sideMenuViewController.contentViewShadowColor = [UIColor blackColor];
    self.sideMenuViewController.contentViewShadowOffset = CGSizeMake(0, 0);
    self.sideMenuViewController.contentViewShadowOpacity = 0;
    self.sideMenuViewController.contentViewShadowRadius = 5;
    self.sideMenuViewController.contentViewShadowEnabled = YES;
    self.sideMenuViewController.contentViewScaleValue = 1;
    self.sideMenuViewController.contentViewBorderEnabled = YES;
    self.sideMenuViewController.contentViewBorderPosition = ContentViewBorderPositionLeftAndRight;
    self.sideMenuViewController.contentViewBorderWidth = 0.5;
    self.sideMenuViewController.contentViewBorderColor = [UIColor lightGrayColor].CGColor;
    self.sideMenuViewController.scaleMenuView = NO;
    self.sideMenuViewController.fadeMenuView = NO;
    self.sideMenuViewController.panGestureEnabled = NO;
    if (DeviceiPhone) {
        self.sideMenuViewController.contentViewInPortraitOffsetCenterX = LeftSideMenuOffsetCenterXIniPhone;
    } else {
        self.sideMenuViewController.contentViewInPortraitOffsetCenterX = LeftSideMenuOffsetCenterXIniPad;
    }
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

- (void)saveCookie {
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *nCookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookiesURL = [nCookies cookiesForURL:[NSURL URLWithString:@"http://bbs.guitarchina.com/"]];
    
    for (id c in cookiesURL)
    {
        if ([c isKindOfClass:[NSHTTPCookie class]])
        {
            cookie=(NSHTTPCookie *)c;
            NSDate *expiresDate = [NSDate dateWithTimeIntervalSinceNow:3600*24*30*12]; //当前点后，保存一年左右
            NSArray *cookies = [NSArray arrayWithObjects:cookie.name, cookie.value, expiresDate, cookie.domain, cookie.path, nil];
            
            if(cookies){
                NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
                [cookieProperties setObject:[cookies objectAtIndex:0] forKey:NSHTTPCookieName];
                [cookieProperties setObject:[cookies objectAtIndex:1] forKey:NSHTTPCookieValue];
                [cookieProperties setObject:[cookies objectAtIndex:2] forKey:NSHTTPCookieExpires];
                [cookieProperties setObject:[cookies objectAtIndex:3] forKey:NSHTTPCookieDomain];
                [cookieProperties setObject:[cookies objectAtIndex:4] forKey:NSHTTPCookiePath];
                
                NSHTTPCookie *cookieuser = [NSHTTPCookie cookieWithProperties:cookieProperties];
                [[NSHTTPCookieStorage sharedHTTPCookieStorage]  setCookie:cookieuser];
            }
        }
    }
}

@end
