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

@interface GCTabBarController ()

@end

@implementation GCTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.delegate = self;
    
    self.tabBar.tintColor = [UIColor GCRedColor];
    self.tabBar.barTintColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if ([viewController.tabBarItem.title isEqualToString:NSLocalizedString(@"Mine", nil)]) {
        
        GCLoginViewController *loginViewController = [[GCLoginViewController alloc] init];
        GCNavigationController *navigationController = [[GCNavigationController alloc] initWithRootViewController:loginViewController];
        [self presentViewController:navigationController animated:YES completion:nil];
        
        return NO;
    }
    
    return YES;
}

@end
