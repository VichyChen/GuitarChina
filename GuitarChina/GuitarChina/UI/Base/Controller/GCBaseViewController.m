//
//  GCBaseViewController.m
//  GuitarChina
//
//  Created by 陈大捷 on 15/8/30.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCBaseViewController.h"

@interface GCBaseViewController ()

@end

@implementation GCBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
////    if (!iOS7) {
//        [backItem setBackButtonBackgroundImage:[UIImage imageNamed:@"icon_backArrow2"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
////    }
//    [backItem setBackButtonTitlePositionAdjustment:UIOffsetMake(-500, 0)
//                                     forBarMetrics:UIBarMetricsDefault];
//    self.navigationItem.backBarButtonItem = backItem;

    if (self.navigationController.childViewControllers.count > 1) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(0, -5, 44, 44);
        [button setImage:[UIImage imageNamed:@"icon_backArrow2"] forState:UIControlStateNormal];
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
        [button setTintColor:[UIColor whiteColor]];
        [button setTitle:@"" forState:UIControlStateNormal];
        @weakify(self);
        [button bk_whenTapped:^{
            @strongify(self);
            [self.navigationController popViewControllerAnimated:YES];
        }];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        
        self.navigationController.interactivePopGestureRecognizer.delegate=(id)self;
    }

    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)showAlertView:(NSString *)message{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
}

@end
