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
#import "GCDiscoveryTableViewController.h"
#import "GCForumIndexViewController.h"
#import "GCUserViewController.h"
#import "GCAboutViewController.h"
#import "GCSearchViewController.h"
#import "OfficialViewController.h"

@interface GCTabBarController () <UITabBarControllerDelegate, WMPageControllerDataSource>

@property (nonatomic, strong) WMPageController *wmPageController;

@end

@implementation GCTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    
    self.tabBar.tintColor = [UIColor whiteColor];
    self.tabBar.barTintColor = [UIColor colorWithRed:0.100 green:0.100 blue:0.100 alpha:1.00];
    /*
    self.tabBar.tintColor = [GCColor redColor];
    self.tabBar.barTintColor = [UIColor whiteColor];
     */

    [self configureView];
}

- (void)configureView {
    GCNavigationController *discoveryNavigationController = [[GCNavigationController alloc] initWithRootViewController:self.wmPageController];
    discoveryNavigationController.tabBarItem.title = NSLocalizedString(@"Home", nil);
    discoveryNavigationController.tabBarItem.image = [[UIImage imageNamed:@"tabbar_home"] imageWithTintColor:[GCColor grayColor4]];
    discoveryNavigationController.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_home"] imageWithTintColor:[GCColor redColor]];
    
    GCForumIndexViewController *forumIndexViewController = [[GCForumIndexViewController alloc] initWithStyle:UITableViewStyleGrouped];
    GCNavigationController *forumIndexNavigationController = [[GCNavigationController alloc] initWithRootViewController:forumIndexViewController];
    forumIndexNavigationController.tabBarItem.title = NSLocalizedString(@"Forum", nil);
    forumIndexNavigationController.tabBarItem.image = [[UIImage imageNamed:@"tabbar_forum"] imageWithTintColor:[GCColor grayColor4]];
    forumIndexNavigationController.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_forum"] imageWithTintColor:[GCColor redColor]];
    
    GCUserViewController *userViewController = [[GCUserViewController alloc] init];
    GCNavigationController *userNavigationController = [[GCNavigationController alloc] initWithRootViewController:userViewController];
    userNavigationController.tabBarItem.title = NSLocalizedString(@"Me", nil);
    userNavigationController.tabBarItem.image = [[UIImage imageNamed:@"icon_mine"] imageWithTintColor:[GCColor grayColor4]];
    userNavigationController.tabBarItem.selectedImage = [[UIImage imageNamed:@"icon_mine"] imageWithTintColor:[GCColor redColor]];
    
    OfficialViewController *officialViewController = [[OfficialViewController alloc] init];
    GCNavigationController *officialNavigationController = [[GCNavigationController alloc] initWithRootViewController:officialViewController];
    officialViewController.tabBarItem.title = NSLocalizedString(@"Official", nil);
    officialViewController.tabBarItem.image = [[UIImage imageNamed:@"tabbar_about"] imageWithTintColor:[GCColor grayColor4]];
    officialViewController.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_about"] imageWithTintColor:[GCColor redColor]];

    GCAboutViewController *moreViewController = [[GCAboutViewController alloc] init];
    GCNavigationController *moreNavigationController = [[GCNavigationController alloc] initWithRootViewController:moreViewController];
    moreNavigationController.tabBarItem.title = NSLocalizedString(@"About", nil);
    moreNavigationController.tabBarItem.image = [[UIImage imageNamed:@"tabbar_about"] imageWithTintColor:[GCColor grayColor4]];
    moreNavigationController.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_about"] imageWithTintColor:[GCColor redColor]];
    
    self.viewControllers = @[discoveryNavigationController, forumIndexNavigationController, officialNavigationController, moreNavigationController];
}

#pragma mark - WMPageControllerDataSource

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    GCDiscoveryTableViewController *discoveryTableViewController = [[GCDiscoveryTableViewController alloc] init];
    discoveryTableViewController.discoveryTableViewType = index;
    
    return discoveryTableViewController;
}

#pragma mark - UITabBarControllerDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if ([viewController.tabBarItem.title isEqualToString:NSLocalizedString(@"Me", nil)]) {
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
    NSArray *titles = @[NSLocalizedString(@"Hottest", nil), NSLocalizedString(@"Newest", nil), NSLocalizedString(@"Sofa", nil), NSLocalizedString(@"Essence", nil)];
    
    WMPageController *pageVC = [[WMPageController alloc] initWithViewControllerClasses:viewControllers andTheirTitles:titles];
    pageVC.dataSource = self;
    pageVC.titleSizeSelected = 16;
    pageVC.titleSizeNormal = 15;
    pageVC.pageAnimatable = YES;
    pageVC.menuHeight = 40;
    pageVC.menuViewStyle = WMMenuViewStyleLine;
    pageVC.titleColorSelected = [GCColor redColor];
    pageVC.titleColorNormal = [GCColor grayColor1];
    pageVC.progressColor = [GCColor redColor];
    pageVC.menuBGColor = [GCColor cellSelectedColor];
    pageVC.menuItemWidth = ScreenWidth / 4;
    pageVC.preloadPolicy = WMPageControllerPreloadPolicyNever;
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, 0, 100, 44);
    label.text = NSLocalizedString(@"GuitarChina", nil);
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
