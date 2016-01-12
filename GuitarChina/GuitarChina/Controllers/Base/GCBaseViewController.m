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
    
    //    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
    if (!iOS7) {
        [backItem setBackButtonBackgroundImage:[UIImage imageNamed:@"icon_backArrow"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];//更改背景图片
    }
    [backItem setBackButtonTitlePositionAdjustment:UIOffsetMake(-500, 0)
                                     forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.backBarButtonItem=backItem;
    
    self.view.backgroundColor = [UIColor GCBackgroundColor];
    //    self.view.nightBackgroundColor = [UIColor whiteColor];
    
    //    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    //    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
