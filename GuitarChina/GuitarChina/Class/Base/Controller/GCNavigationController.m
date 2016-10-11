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
    
    self.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationBar.tintColor = [GCColor grayColor1];
    self.navigationBar.titleTextAttributes = @{ NSForegroundColorAttributeName : [GCColor fontColor], NSFontAttributeName : [UIFont systemFontOfSize:17]};
    //    self.navigationBar.nightBarTintColor = [GCColor grayColor1];
//    self.navigationBar.nightTintColor = [UIColor whiteColor];
//    UIImage *image = [[[UIImage alloc] init] imageWithTintColor:[GCColor redColor]];
//
//        [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
//        [self.navigationBar setShadowImage:[[UIImage alloc] init]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
