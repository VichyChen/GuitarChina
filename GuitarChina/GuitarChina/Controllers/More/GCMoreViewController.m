//
//  GCMoreViewController.m
//  GuitarChina
//
//  Created by mac on 15/9/25.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCMoreViewController.h"
#import "RESideMenu.h"

@interface GCMoreViewController ()

@end

@implementation GCMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = NSLocalizedString(@"More", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [UIView createCustomBarButtonItem:@"icon_hamberger"
                                                                  normalColor:[UIColor GCFontColor]
                                                             highlightedColor:[UIColor redColor]
                                                                       target:self
                                                                       action:@selector(presentLeftMenuViewController:)];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
