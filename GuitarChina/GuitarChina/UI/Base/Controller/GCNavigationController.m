//
//  GCNavigationController.m
//  GuitarChina
//
//  Created by 陈大捷 on 15/8/30.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCNavigationController.h"

@interface GCNavigationController ()

@end

@implementation GCNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.barTintColor = [GCColor redColor];
    self.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationBar.translucent = NO;
    self.navigationBar.titleTextAttributes = @{ NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont systemFontOfSize:17]};
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

@end
