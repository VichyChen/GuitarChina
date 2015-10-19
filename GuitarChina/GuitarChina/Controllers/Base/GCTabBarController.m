//
//  GCTabBarController.m
//  GuitarChina
//
//  Created by 陈大捷 on 15/10/17.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCTabBarController.h"

@interface GCTabBarController ()

@end

@implementation GCTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tabBar.tintColor = [UIColor GCRedColor];
    self.tabBar.barTintColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
