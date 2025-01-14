//
//  GCTabBarController.m
//  GuitarChina
//
//  Created by 陈大捷 on 15/10/17.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCTabBarController.h"
#import "GCNavigationController.h"
#import "GCLoginViewController.h"
#import "WMPageController.h"
#import "GCNewsViewController.h"
#import "GCDiscoveryTableViewController.h"
#import "GCForumIndexViewController.h"
#import "GCMoreViewController.h"
#import "GCSearchViewController.h"
#import "GCOfficialViewController.h"
#import "GCDiscoveryViewController.h"
#import "UITabBarItem+DoubleTap.h"

@interface GCTabBarController () <UITabBarControllerDelegate, WMPageControllerDataSource>

@property (nonatomic, strong) WMPageController *wmPageController;

@end

@implementation GCTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    self.tabBar.translucent = NO;

    self.tabBar.tintColor = [UIColor whiteColor];
    self.tabBar.barTintColor = [UIColor colorWithRed:0.100 green:0.100 blue:0.100 alpha:1.00];

//    self.tabBar.tintColor = [GCColor redColor];
//    self.tabBar.barTintColor = [UIColor whiteColor];

    [self configureView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self updateMorePromptRedCount];
}

- (void)configureView {
    GCDiscoveryViewController *discoveryViewController = [[GCDiscoveryViewController alloc] init];
    GCNavigationController *discoveryNavigationController = [[GCNavigationController alloc] initWithRootViewController:discoveryViewController];
    discoveryNavigationController.tabBarItem.title = @"首页";
    discoveryNavigationController.tabBarItem.image = [[UIImage imageNamed:@"tabbar_home"] imageWithTintColor:[GCColor grayColor4]];
    discoveryNavigationController.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_home"] imageWithTintColor:[GCColor redColor]];
    discoveryNavigationController.tabBarItem.doubleTapBlock = ^(UITabBarItem *tabBarItem, NSInteger index) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kGCNotificationDiscoveryDoubleTap object:nil];
    };
    
    GCForumIndexViewController *forumIndexViewController = [[GCForumIndexViewController alloc] init];
    GCNavigationController *forumIndexNavigationController = [[GCNavigationController alloc] initWithRootViewController:forumIndexViewController];
    forumIndexNavigationController.tabBarItem.title = @"论坛";
    forumIndexNavigationController.tabBarItem.image = [[UIImage imageNamed:@"tabbar_forum"] imageWithTintColor:[GCColor grayColor4]];
    forumIndexNavigationController.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_forum"] imageWithTintColor:[GCColor redColor]];
    
    GCNewsViewController *newsViewController = [[GCNewsViewController alloc] init];
    GCNavigationController *newsNavigationController = [[GCNavigationController alloc] initWithRootViewController:newsViewController];
    newsNavigationController.tabBarItem.title = @"新闻";
    newsNavigationController.tabBarItem.image = [[UIImage imageNamed:@"icon_wave"] imageWithTintColor:[GCColor grayColor4]];
    newsNavigationController.tabBarItem.selectedImage = [[UIImage imageNamed:@"icon_wave"] imageWithTintColor:[GCColor redColor]];
    
    GCOfficialViewController *officialViewController = [[GCOfficialViewController alloc] init];
    GCNavigationController *officialNavigationController = [[GCNavigationController alloc] initWithRootViewController:officialViewController];
    officialViewController.tabBarItem.title = @"官方";
    officialViewController.tabBarItem.image = [[UIImage imageNamed:@"icon_guitar"] imageWithTintColor:[GCColor grayColor4]];
    officialViewController.tabBarItem.selectedImage = [[UIImage imageNamed:@"icon_guitar"] imageWithTintColor:[GCColor redColor]];

    GCMoreViewController *moreViewController = [[GCMoreViewController alloc] init];
    GCNavigationController *moreNavigationController = [[GCNavigationController alloc] initWithRootViewController:moreViewController];
    moreNavigationController.tabBarItem.title = @"更多";
    moreNavigationController.tabBarItem.image = [[UIImage imageNamed:@"tabbar_about"] imageWithTintColor:[GCColor grayColor4]];
    moreNavigationController.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_about"] imageWithTintColor:[GCColor redColor]];
    
    self.viewControllers = @[discoveryNavigationController, forumIndexNavigationController, newsNavigationController, officialNavigationController, moreNavigationController];
}

- (void)updateMorePromptRedCount {
    NSInteger redCount = [NSUD integerForKey:kGCNewMyPost];
    if (redCount == 0) {
        self.viewControllers[4].tabBarItem.badgeValue = nil;
    } else {
        self.viewControllers[4].tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld", redCount];
    }
}

#pragma mark - WMPageControllerDataSource

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    GCDiscoveryTableViewController *discoveryTableViewController = [[GCDiscoveryTableViewController alloc] init];
    discoveryTableViewController.discoveryTableViewType = index;
    
    return discoveryTableViewController;
}

#pragma mark - UITabBarControllerDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if ([viewController.tabBarItem.title isEqualToString:@"我"]) {
        if (![[NSUD stringForKey:kGCLogin] isEqualToString:@"1"]) {
            GCLoginViewController *loginViewController = [[GCLoginViewController alloc] initWithNibName:@"GCLoginViewController" bundle:nil];
            GCNavigationController *navigationController = [[GCNavigationController alloc] initWithRootViewController:loginViewController];
            [self presentViewController:navigationController animated:YES completion:nil];

            return NO;
        }
    }
    
    return YES;
}

#pragma mark - Event Response

- (void)searchAction {
    GCSearchViewController *controller = [[GCSearchViewController alloc] init];
    GCNavigationController *navigationController = [[GCNavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:navigationController animated:NO completion:^{
        
    }];
}

#pragma mark - Getters

- (WMPageController *)wmPageController {
    NSArray *viewControllers = @[[GCDiscoveryTableViewController class], [GCDiscoveryTableViewController class], [GCDiscoveryTableViewController class], [GCDiscoveryTableViewController class]];
    NSArray *titles = @[@"最热", @"最新", @"抢沙发", @"精华"];
    
    WMPageController *pageVC = [[WMPageController alloc] initWithViewControllerClasses:viewControllers andTheirTitles:titles];
    pageVC.dataSource = self;
    pageVC.titleSizeSelected = 16;
    pageVC.titleSizeNormal = 15;
    pageVC.pageAnimatable = YES;
    pageVC.menuHeight = 40;
    pageVC.menuViewStyle = WMMenuViewStyleDefault;
    pageVC.titleColorSelected = [GCColor redColor];
    pageVC.titleColorNormal = [GCColor grayColor1];
    pageVC.progressColor = [GCColor redColor];
    pageVC.menuBGColor = [GCColor cellSelectedColor];
    pageVC.menuItemWidth = kScreenWidth / 4;
    pageVC.preloadPolicy = WMPageControllerPreloadPolicyNever;
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, 0, 100, 44);
    label.text = @"吉他中国";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:17];
    pageVC.navigationItem.titleView = label;
    
    pageVC.navigationItem.rightBarButtonItem = [UIView createCustomBarButtonItem:@"icon_search"
                                                                   normalColor:[UIColor whiteColor]
                                                              highlightedColor:[UIColor whiteColor]
                                                                        target:self
                                                                        action:@selector(searchAction)];
    
    return pageVC;
}

@end
