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
    
    self.title = NSLocalizedString(@"Others", nil);
    self.view.backgroundColor = [UIColor GCBackgroundColor];
    
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GCMineCell *cell = [[GCMineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.titleLabel.text = NSLocalizedString(@"User Protocol", nil);
    cell.leftImageView.image = [UIImage imageNamed:@"icon_law"];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @" ";
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 100)];
    view.backgroundColor = [UIColor GCBackgroundColor];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 28, ScreenWidth, 0.5)];
    line.backgroundColor = [UIColor GCSeparatorLineColor];
    [view addSubview:line];
    
    return view;
}


#pragma mark - Private Methods

- (void)configureView {
    [self.view addSubview:self.tableView];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 100)];
    UIButton *button = [UIView createButton:CGRectMake(15, 28, ScreenWidth - 30, 44)
                                       text:NSLocalizedString(@"Logout Account", nil)
                                     target:self
                                     action:@selector(logoutAction)];
    button.backgroundColor = [UIColor GCLightGrayFontColor];
    button.layer.cornerRadius = 5;
    button.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    button.tintColor = [UIColor whiteColor];
    
    [view addSubview:button];
    self.tableView.tableFooterView = view;
}

#pragma mark - Event Response

- (void)logoutAction {
    [Util clearCookie];
    ApplicationDelegate.tabBarController.selectedIndex = 0;
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:kGCLOGIN];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kGCLOGINNAME];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //    [[NSNotificationCenter defaultCenter] postNotificationName:kGCNOTIFICATION_LOGINSUCCESS object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Getters

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)];
        _tableView.backgroundColor = [UIColor GCBackgroundColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.bounces = NO;
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

@end
