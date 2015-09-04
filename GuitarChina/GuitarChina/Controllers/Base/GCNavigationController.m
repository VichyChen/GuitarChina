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
    
    self.navigationBar.barTintColor = [UIColor redColor];
    self.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
