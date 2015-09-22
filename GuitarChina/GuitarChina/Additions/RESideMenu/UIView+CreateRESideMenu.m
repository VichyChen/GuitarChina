//
//  UIView+CreateRESideMenu.m
//  GuitarChina
//
//  Created by mac on 15/9/22.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "UIView+CreateRESideMenu.h"
#import "GCNavigationController.h"
#import "GCThreadDetailRightMenuViewController.h"

@implementation UIView (CreateRESideMenu)

+ (RESideMenu *)createLeftRESideMenu {
    return nil;
}

+ (RESideMenu *)createRightRESideMenu:(UIViewController *)contentController {
    GCThreadDetailRightMenuViewController *threadDetailRightMenuViewController = [[GCThreadDetailRightMenuViewController alloc] init];
    RESideMenu *sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:contentController
                                                                    leftMenuViewController:nil
                                                                   rightMenuViewController:threadDetailRightMenuViewController];
    sideMenuViewController.backgroundImage = [UIImage imageNamed:@"Stars"];
    sideMenuViewController.menuPreferredStatusBarStyle = 1; // UIStatusBarStyleLightContent
    //    sideMenuViewController.delegate = self;
    sideMenuViewController.contentViewShadowColor = [UIColor blackColor];
    sideMenuViewController.contentViewShadowOffset = CGSizeMake(0, 0);
    sideMenuViewController.contentViewShadowOpacity = 0;
    sideMenuViewController.contentViewShadowRadius = 5;
    sideMenuViewController.contentViewShadowEnabled = YES;
    sideMenuViewController.contentViewScaleValue = 1;
    sideMenuViewController.contentViewBorderEnabled = YES;
    sideMenuViewController.contentViewBorderPosition = ContentViewBorderPositionLeft;
    sideMenuViewController.contentViewBorderWidth = 0.5;
    sideMenuViewController.contentViewBorderColor = [UIColor lightGrayColor].CGColor;
    sideMenuViewController.scaleMenuView = NO;
    sideMenuViewController.fadeMenuView = NO;
    
    return sideMenuViewController;
}


@end
