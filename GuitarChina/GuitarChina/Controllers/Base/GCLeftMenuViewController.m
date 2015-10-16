//
//  GCLeftMenuViewController.m
//  GuitarChina
//
//  Created by 陈大捷 on 15/8/30.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCLeftMenuViewController.h"
#import "GCNavigationController.h"
#import "GCHotThreadViewController.h"
#import "GCForumIndexViewController.h"
#import "GCMineViewController.h"
#import "GCSettingViewController.h"
#import "GCMoreViewController.h"
#import "GCLeftMenuCell.h"

#define AvatarImageViewSize 80
#define HeaderViewHeightWhenLogin 160
#define HeaderViewHeightWhenNotLogin 170

@interface GCLeftMenuViewController () <UITableViewDataSource, UITableViewDelegate> {
    NSInteger selectedIndex;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UIView *separatorLine;
@property (nonatomic, strong) UIButton *loginButton;

@property (nonatomic, strong) GCHotThreadViewController *hotThreadViewController;
@property (nonatomic, strong) GCForumIndexViewController *forumIndexViewController;
@property (nonatomic, strong) GCMineViewController *mineViewController;
@property (nonatomic, strong) GCSettingViewController *settingViewController;
@property (nonatomic, strong) GCMoreViewController *moreViewController;

@property (nonatomic, copy) NSArray *titleArray;
@property (nonatomic, copy) NSArray *imageArray;

@end

@implementation GCLeftMenuViewController

#pragma mark - life cycle

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        selectedIndex = 0;
        
        _titleArray = @[NSLocalizedString(@"Hot Thread", nil),
                        NSLocalizedString(@"Forum", nil),
                        NSLocalizedString(@"Mine", nil),
                        NSLocalizedString(@"Setting", nil),
                        NSLocalizedString(@"More", nil)];
        _imageArray = @[@"icon_hotthread", @"icon_forum", @"icon_mine", @"icon_setting", @"icon_more"];
    }
    return self;
}

- (void)loadView {
    [super loadView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.tableView];
    [self updateFrame];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Public Methods

- (void)configureFirstViewController:(UIViewController *)controller {
    self.hotThreadViewController = (GCHotThreadViewController *)controller;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex {
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"GCLeftMenuCell";
    GCLeftMenuCell *cell = (GCLeftMenuCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[GCLeftMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if (DeviceiPhone) {
        cell.leftImageViewOffsetX = (ScreenWidth / 2 + LeftSideMenuOffsetCenterXIniPhone) / 2 - AvatarImageViewSize / 2;
    } else {
        cell.leftImageViewOffsetX = (ScreenWidth / 2 + LeftSideMenuOffsetCenterXIniPad) / 2 - AvatarImageViewSize / 2;
    }
    cell.titleLabel.text = self.titleArray[indexPath.row];
    cell.leftImageView.image = [[UIImage imageNamed:self.imageArray[indexPath.row]] imageWithTintColor:[UIColor blackColor]];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (selectedIndex == indexPath.row) {
        [self.sideMenuViewController hideMenuViewController];
        return;
    }
    selectedIndex = indexPath.row;
    switch (indexPath.row) {
        case 0:
            [self.sideMenuViewController setContentViewController:[[GCNavigationController alloc] initWithRootViewController:self.hotThreadViewController] animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;
            
        case 1:
            [self.sideMenuViewController setContentViewController:[[GCNavigationController alloc] initWithRootViewController:self.forumIndexViewController] animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;
            
        case 2:
            [self.sideMenuViewController setContentViewController:[[GCNavigationController alloc] initWithRootViewController:self.mineViewController] animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;
            
        case 3:
            [self.sideMenuViewController setContentViewController:[[GCNavigationController alloc] initWithRootViewController:self.settingViewController] animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;
            
        case 4:
            [self.sideMenuViewController setContentViewController:[[GCNavigationController alloc] initWithRootViewController:self.moreViewController] animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;
            
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

#pragma mark - Private Methods

- (void)loginAction:(id)sender {
    
}

- (void)updateFrame {
    //判断是否有登录
    if (/* DISABLES CODE */ (NO)) {
        self.headerView.frame = CGRectMake(0, 0, ScreenWidth, HeaderViewHeightWhenLogin);
        self.loginButton.frame = CGRectZero;
    } else {
        self.headerView.frame = CGRectMake(0, 0, ScreenWidth, HeaderViewHeightWhenNotLogin);
    }
    if (DeviceiPhone) {
        self.avatarImageView.frame = CGRectMake((ScreenWidth / 2 + LeftSideMenuOffsetCenterXIniPhone) / 2 - AvatarImageViewSize / 2, 50, AvatarImageViewSize, AvatarImageViewSize);
        self.tableView.frame = CGRectMake(0, self.headerView.frame.size.height, ScreenWidth / 2 + LeftSideMenuOffsetCenterXIniPhone, ScreenHeight);
    } else {
        self.avatarImageView.frame = CGRectMake((ScreenWidth / 2 + LeftSideMenuOffsetCenterXIniPad) / 2 - AvatarImageViewSize / 2, 50, AvatarImageViewSize, AvatarImageViewSize);
        self.tableView.frame = CGRectMake(0, self.headerView.frame.size.height, ScreenWidth / 2 + LeftSideMenuOffsetCenterXIniPad, ScreenHeight);
    }
    if (YES) {
        self.loginButton.frame = CGRectMake(0, self.avatarImageView.center.y + AvatarImageViewSize / 2, self.tableView.frame.size.width, 40);
    }
    self.separatorLine.frame = CGRectMake(15, self.headerView.frame.size.height - 1, self.tableView.frame.size.width - 30, 1);
}

#pragma mark - Getters

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.opaque = NO;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.backgroundView = nil;
        _tableView.bounces = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectZero];
        
        [_headerView addSubview:self.avatarImageView];
        [_headerView addSubview:self.separatorLine];
        [_headerView addSubview:self.loginButton];
    }
    return _headerView;
}

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [UIView createImageView:CGRectZero
                                       contentMode:UIViewContentModeScaleToFill];
        _avatarImageView.layer.cornerRadius = 5;
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.layer.borderWidth = 1;
        _avatarImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
    return _avatarImageView;
}

- (UIView *)separatorLine {
    if (!_separatorLine) {
        _separatorLine = [UIView createHorizontalLine:0
                                              originX:0
                                              originY:0
                                                color:[UIColor lightGrayColor]];
        _separatorLine.alpha = 0.6;
    }
    return _separatorLine;
}

- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [UIView createButton:CGRectZero
                                       text:NSLocalizedString(@"login", nil)
                                     target:self
                                     action:@selector(loginAction:)];
    }
    return _loginButton;
}

- (GCHotThreadViewController *)hotThreadViewController {
    if (!_hotThreadViewController) {
        _hotThreadViewController = [[GCHotThreadViewController alloc] init];
    }
    return _hotThreadViewController;
}

- (GCForumIndexViewController *)forumIndexViewController {
    if (!_forumIndexViewController) {
        _forumIndexViewController = [[GCForumIndexViewController alloc] init];
    }
    return _forumIndexViewController;
}

- (GCMineViewController *)mineViewController {
    if (!_mineViewController) {
        _mineViewController = [[GCMineViewController alloc] init];
    }
    return _mineViewController;
}

- (GCSettingViewController *)settingViewController {
    if (!_settingViewController) {
        _settingViewController = [[GCSettingViewController alloc] init];
    }
    return _settingViewController;
}

- (GCMoreViewController *)moreViewController {
    if (!_moreViewController) {
        _moreViewController = [[GCMoreViewController alloc] init];
    }
    return _moreViewController;
}

@end
