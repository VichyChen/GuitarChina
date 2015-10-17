//
//  GCMineViewController.m
//  GuitarChina
//
//  Created by mac on 15/9/25.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCMineViewController.h"
#import "RESideMenu.h"

@interface GCMineViewController ()

@end

@implementation GCMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = NSLocalizedString(@"Mine", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    
//    self.navigationItem.leftBarButtonItem = [UIView createCustomBarButtonItem:@"icon_hamberger"
//                                                                  normalColor:[UIColor FontColor]
//                                                             highlightedColor:[UIColor redColor]
//                                                                       target:self
//                                                                       action:@selector(presentLeftMenuViewController:)];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
