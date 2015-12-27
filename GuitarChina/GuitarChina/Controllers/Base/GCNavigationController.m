//
//  GCNavigationController.m
//  GuitarChina
//
//  Created by 陈大捷 on 15/8/30.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCNavigationController.h"
#import "DKNightVersion.h"

@interface GCNavigationController ()

@end

@implementation GCNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.barTintColor = [UIColor GCRedColor];
    self.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    
//    self.navigationBar.nightBarTintColor = [UIColor GCFontColor];
//    self.navigationBar.nightTintColor = [UIColor whiteColor];
//    UIImage *image = [[[UIImage alloc] init] imageWithTintColor:[UIColor GCRedColor]];
//
//        [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
//        [self.navigationBar setShadowImage:[[UIImage alloc] init]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
