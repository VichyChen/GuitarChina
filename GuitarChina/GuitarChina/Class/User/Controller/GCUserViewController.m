//
//  GCUserViewController.m
//  GuitarChina
//
//  Created by mac on 15/9/25.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCUserViewController.h"
#import "GCMineHeaderCell.h"
#import "GCMineCell.h"
#import "GCUserOtherViewController.h"
#import "GCUserInfoViewController.h"
#import "GCMyThreadViewController.h"
#import "GCMyFavThreadViewController.h"
#import "GCUserProtocolViewController.h"

@interface GCUserViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation GCUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Me", nil);
    self.view.backgroundColor = [UIColor GCBackgroundColor];
    
    self.userID = [NSUD stringForKey:kGCLoginID];
    self.username = [NSUD stringForKey:kGCLoginName];
    self.userLevel = [NSUD stringForKey:kGCLoginLevel];
    
    [self configureView];
    [self configureNotification];
    //    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 100)];
    //    UIButton *button = [UIView createButton:CGRectMake(15, 28, ScreenWidth - 30, 44)
    //                                       text:@"注销账号"
    //                                     target:self
    //                                     action:@selector(logOutAction)];
    //    button.backgroundColor = [UIColor GCLightGrayFontColor];
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kGCNotificationLoginSuccess object:nil];
}

#pragma mark - Notification

- (void)configureNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshView) name:kGCNotificationLoginSuccess object:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 4;
    } else if (section == 2) {
        return 0;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        GCMineHeaderCell *cell = [[GCMineHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.userLabel.text = self.username;
        cell.levelLabel.text = self.userLevel;
        [cell.avatarImage sd_setImageWithURL:[NSURL URLWithString:GCNETWORKAPI_URL_BIGAVTARIMAGE(self.userID)]
                            placeholderImage:nil
                                     options:SDWebImageRetryFailed];
        
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
            cell.titleLabel.text = NSLocalizedString(@"User Protocol", nil);
            cell.leftImageView.image = [UIImage imageNamed:@"icon_star"];
        } else if (indexPath.row == 3) {
            cell.titleLabel.text = NSLocalizedString(@"Logout Account", nil);
            cell.leftImageView.image = [UIImage imageNamed:@"icon_star"];
        }
        
        return cell;
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            GCMineCell *cell = [[GCMineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.titleLabel.text = NSLocalizedString(@"Others", nil);
            cell.leftImageView.image = [UIImage imageNamed:@"icon_info"];
            
            return cell;
        }
    }
    
    return nil;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    return @" ";
//}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 28)];
    view.backgroundColor = [UIColor GCBackgroundColor];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 28, ScreenWidth, 0.5)];
    line.backgroundColor = [UIColor GCSeparatorLineColor];
    [view addSubview:line];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 28;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 100;
    }
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {//个人信息
        //        GCUserInfoViewController *userInfoViewController = [[GCUserInfoViewController alloc] init];
        //        userInfoViewController.hidesBottomBarWhenPushed = YES;
        //        [self.navigationController pushViewController:userInfoViewController animated:YES];
    } else if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0://我的主题
            {
                GCMyThreadViewController *userThreadViewController = [[GCMyThreadViewController alloc] init];
                userThreadViewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:userThreadViewController animated:YES];
            }
                break;
                
            case 1://我的收藏
            {
                GCMyFavThreadViewController *myFavThreadViewController = [[GCMyFavThreadViewController alloc] init];
                myFavThreadViewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:myFavThreadViewController animated:YES];
            }
                break;
                
            case 2://用户协议
            {
                GCUserProtocolViewController *userProtocolViewController = [[GCUserProtocolViewController alloc] init];
                userProtocolViewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:userProtocolViewController animated:YES];
            }
                break;
                
            case 3://注销
                [self logoutAction];
                
                break;
        }
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {//其它
            GCUserOtherViewController *userOtherViewController = [[GCUserOtherViewController alloc] init];
            userOtherViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:userOtherViewController animated:YES];
        }
    }
}

#pragma mark - Private Methods

- (void)configureView {
    [self.view addSubview:self.tableView];
}

#pragma mark - Event Responses

- (void)refreshView {
    self.userID = [NSUD stringForKey:kGCLoginID];
    self.username = [NSUD stringForKey:kGCLoginName];
    self.userLevel = [NSUD stringForKey:kGCLoginLevel];
    [self.tableView reloadData];
}

- (void)logoutAction {
    [Util clearCookie];
    APP.tabBarController.selectedIndex = 0;
    [NSUD setObject:@"0" forKey:kGCLogin];
    [NSUD setObject:@"" forKey:kGCLoginName];
    [NSUD synchronize];
    //    [[NSNotificationCenter defaultCenter] postNotificationName:kGCNotificationLoginSuccess object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Getters

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor GCBackgroundColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
