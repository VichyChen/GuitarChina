//
//  GCMineViewController.m
//  GuitarChina
//
//  Created by mac on 15/9/25.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCMineViewController.h"
#import "GCMineHeaderCell.h"
#import "GCMineCell.h"
#import "GCMineOtherViewController.h"
#import "GCUserInfoViewController.h"
#import "GCMyThreadViewController.h"
#import "GCMyFavThreadViewController.h"

@interface GCMineViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation GCMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Mine", nil);
    self.view.backgroundColor = [UIColor GCVeryLightGrayBackgroundColor];
    
    self.username = [[NSUserDefaults standardUserDefaults] stringForKey:kGCLOGINNAME];
    
    [self configureView];
    [self configureNotification];
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 100)];
//    UIButton *button = [UIView createButton:CGRectMake(15, 28, ScreenWidth - 30, 44)
//                                       text:@"注销账号"
//                                     target:self
//                                     action:@selector(logOutAction)];
//    button.backgroundColor = [UIColor GCLightGrayColor];
//    button.layer.cornerRadius = 5;
//    button.titleLabel.font = [UIFont boldSystemFontOfSize:17];
//    button.tintColor = [UIColor whiteColor];
//    
//    [view addSubview:button];
//    self.tableView.tableFooterView = view;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kGCNOTIFICATION_LOGINSUCCESS object:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 3;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        GCMineHeaderCell *cell = [[GCMineHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.userLabel.text = self.username;
        
        return cell;
    } else if (indexPath.section == 1) {
        GCMineCell *cell = [[GCMineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        if (indexPath.row == 0) {
            cell.titleLabel.text = NSLocalizedString(@"My Theme", nil);
            cell.leftImageView.image = [UIImage imageNamed:@"icon_document"];
        } else if (indexPath.row == 1) {
            cell.titleLabel.text = NSLocalizedString(@"My Favour", nil);
            cell.leftImageView.image = [UIImage imageNamed:@"icon_star"];
        } else if (indexPath.row == 2) {
            cell.titleLabel.text = NSLocalizedString(@"Others", nil);
            cell.leftImageView.image = [UIImage imageNamed:@"icon_info"];
        }
        
        return cell;
    } else {
        return nil;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @" ";
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 100;
    } else if (indexPath.section == 1) {
        return 44;
    }
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if (indexPath.section == 0) {//个人信息
        GCUserInfoViewController *userInfoViewController = [[GCUserInfoViewController alloc] init];
        userInfoViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:userInfoViewController animated:YES];
    } else if (indexPath.section == 1) {//我的主题
        if (indexPath.row == 0) {
            GCMyThreadViewController *userThreadViewController = [[GCMyThreadViewController alloc] init];
            userThreadViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:userThreadViewController animated:YES];
        } else if (indexPath.row == 1) {//我的收藏
            GCMyFavThreadViewController *myFavThreadViewController = [[GCMyFavThreadViewController alloc] init];
            myFavThreadViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:myFavThreadViewController animated:YES];
        } else if (indexPath.row == 2) {//其它
            GCMineOtherViewController *mineOtherViewController = [[GCMineOtherViewController alloc] init];
            mineOtherViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:mineOtherViewController animated:YES];
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 100)];
    view.backgroundColor = [UIColor GCVeryLightGrayBackgroundColor];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 28, ScreenWidth, 0.5)];
    line.backgroundColor = [UIColor GCGrayLineColor];
    [view addSubview:line];
    
    return view;
}

#pragma mark - Private Methods

- (void)configureView {
    [self.view addSubview:self.tableView];
}

- (void)configureNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshView) name:kGCNOTIFICATION_LOGINSUCCESS object:nil];
}

#pragma mark - Event Response

- (void)refreshView {
    self.username = [[NSUserDefaults standardUserDefaults] stringForKey:kGCLOGINNAME];
    [self.tableView reloadData];
}

#pragma mark - Getters

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)];
        _tableView.backgroundColor = [UIColor GCVeryLightGrayBackgroundColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.bounces = NO;
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

//- (UIView *)tableFooterView {
//    if (!_tableFooterView) {
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 100)];
//        UIButton *button = [UIView createButton:CGRectMake(15, 28, ScreenWidth - 30, 44)
//                                                 text:@"注销账号"
//                                               target:self
//                                               action:@selector(logOutAction)];
//        button.backgroundColor = [UIColor GCRedColor];
//        button.layer.cornerRadius = 5;
//        
//        [view addSubview:button];
//    }
//    return _tableFooterView;
//}

@end
