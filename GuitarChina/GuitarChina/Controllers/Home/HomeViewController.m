//
//  HomeViewController.m
//  GuitarChina
//
//  Created by 陈大捷 on 15/8/30.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "HomeViewController.h"
#import "RESideMenu.h"
#import "ForumViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

#pragma mark - life cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)loadView {
    [super loadView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"111";
    self.view.backgroundColor = [UIColor redColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Left"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(presentLeftMenuViewController:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Right"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(testPush:)];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)testPush:(id)sender {
    
    ForumViewController *controller = [[ForumViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];

}

@end
