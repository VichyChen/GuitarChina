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
#import "GCMoreViewController.h"
#import "GCSearchViewController.h"

@interface GCTabBarController () <UITabBarControllerDelegate, WMPageControllerDataSource>

@property (nonatomic, strong) WMPageController *wmPageController;

@end

@implementation GCTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    
    self.tabBar.tintColor = [UIColor GCRedColor];
    self.tabBar.barTintColor = [UIColor whiteColor];
    
    [self configureView];
}

- (void)configureView {
    GCNavigationController *discoveryNavigationController = [[GCNavigationController alloc] initWithRootViewController:self.wmPageController];
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
    
    self.viewControllers = @[discoveryNavigationController, forumIndexNavigationController, userNavigationController, moreNavigationController];
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
        if (![[NSUD stringForKey:kGCLOGIN] isEqualToString:@"1"]) {
            GCLoginViewController *loginViewController = [[GCLoginViewController alloc] initWithNibName:@"GCLoginViewController" bundle:nil];
            [self presentViewController:loginViewController animated:YES completion:nil];

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
    pageVC.titleColorSelected = [UIColor GCRedColor];
    pageVC.titleColorNormal = [UIColor GCDarkGrayFontColor];
    pageVC.progressColor = [UIColor colorWithRed:168.0/255.0 green:20.0/255.0 blue:4/255.0 alpha:1];
    pageVC.menuItemWidth = ScreenWidth / 4;
    pageVC.preloadPolicy = WMPageControllerPreloadPolicyNever;
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, 0, 100, 44);
    label.text = NSLocalizedString(@"GuitarChina", nil);
    label.textColor = [UIColor GCDarkGrayFontColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:16];
    pageVC.navigationItem.titleView = label;
    
    pageVC.navigationItem.rightBarButtonItem = [UIView createCustomBarButtonItem:@"icon_search"
                                                                   normalColor:[UIColor GCDarkGrayFontColor]
                                                              highlightedColor:[UIColor grayColor]
                                                                        target:self
                                                                        action:@selector(searchAction)];
    
    return pageVC;
}

@end
