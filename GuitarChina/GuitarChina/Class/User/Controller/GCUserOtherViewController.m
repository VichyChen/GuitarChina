//
//  GCUserOtherViewController.m
//  GuitarChina
//
//  Created by mac on 15/10/28.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCUserOtherViewController.h"
#import "GCMineCell.h"
#import "GCUserProtocolViewController.h"

@interface GCUserOtherViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation GCUserOtherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Setting", nil);
    self.view.backgroundColor = [GCColor backgroundColor];
    
    [self configureView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GCMineCell *cell = [[GCMineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.titleLabel.text = NSLocalizedString(@"User Protocol", nil);
    cell.leftImageView.image = [UIImage imageNamed:@"icon_law"];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GCUserProtocolViewController *userProtocolViewController = [[GCUserProtocolViewController alloc] init];
    [self.navigationController pushViewController:userProtocolViewController animated:YES];
}

#pragma mark - Private Methods

- (void)configureView {
    [self.view addSubview:self.tableView];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 100)];
    UIButton *button = [UIView createButton:CGRectMake(15, 28, ScreenWidth - 30, 42)
                                       text:NSLocalizedString(@"Logout Account", nil)
                                     target:self
                                     action:@selector(logoutAction)];
    button.backgroundColor = [GCColor redColor];
    button.layer.cornerRadius = 5;
    button.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    button.tintColor = [UIColor whiteColor];
    
    [view addSubview:button];
    self.tableView.tableFooterView = view;
}

#pragma mark - Event Responses

- (void)logoutAction {
    [Util clearCookie];
//    APP.tabBarController.selectedIndex = 0;
    [NSUD setObject:@"0" forKey:kGCLogin];
    [NSUD setObject:@"" forKey:kGCLoginName];
    [NSUD synchronize];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Getters

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)];
        _tableView.backgroundColor = [GCColor backgroundColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

@end
