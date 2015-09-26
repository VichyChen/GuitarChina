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

#define avatarImageViewSize 80

@interface GCLeftMenuViewController () <UITableViewDataSource, UITableViewDelegate> {
    NSInteger selectedIndex;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UIView *separatorLine;

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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
    
    [self.view addSubview:self.tableView];
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
    if (cell == nil) {
        cell = [[GCLeftMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if (DeviceiPhone) {
        cell.leftImageViewOffsetX = (ScreenWidth / 2 + LeftSideMenuOffsetCenterXIniPhone) / 2 - avatarImageViewSize / 2;
    } else {
        cell.leftImageViewOffsetX = (ScreenWidth / 2 + LeftSideMenuOffsetCenterXIniPad) / 2 - avatarImageViewSize / 2;
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

#pragma mark - Getters

- (UITableView *)tableView {
    if (_tableView == nil) {
        CGRect frame;
        if (DeviceiPhone) {
            frame = CGRectMake(0, 0, ScreenWidth / 2 + LeftSideMenuOffsetCenterXIniPhone, ScreenHeight);
        } else {
            frame = CGRectMake(0, 0, ScreenWidth / 2 + LeftSideMenuOffsetCenterXIniPad, ScreenHeight);
        }
        _tableView = [[UITableView alloc] initWithFrame:frame];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.opaque = NO;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.backgroundView = nil;
        _tableView.bounces = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = self.headerView;
    }
    return _tableView;
}

- (UIView *)headerView {
    if (_headerView == nil) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 140)];
        
        [_headerView addSubview:self.avatarImageView];
        [_headerView addSubview:self.separatorLine];
    }
    return _headerView;
}

- (UIImageView *)avatarImageView {
    if (_avatarImageView == nil) {
        CGRect frame;
        if (DeviceiPhone) {
            frame = CGRectMake((ScreenWidth / 2 + LeftSideMenuOffsetCenterXIniPhone) / 2 - avatarImageViewSize / 2, self.headerView.frame.size.height / 2 - 30, avatarImageViewSize, avatarImageViewSize);
        } else {
            frame = CGRectMake((ScreenWidth / 2 + LeftSideMenuOffsetCenterXIniPad) / 2 - avatarImageViewSize / 2, self.headerView.frame.size.height / 2 - 30, avatarImageViewSize, avatarImageViewSize);
        }
        _avatarImageView = [UIView createImageView:frame
                                       contentMode:UIViewContentModeScaleToFill];
        _avatarImageView.layer.cornerRadius = 5;
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.layer.borderWidth = 1;
        _avatarImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
    return _avatarImageView;
}

- (UIView *)separatorLine {
    if (_separatorLine == nil) {
        _separatorLine = [UIView createHorizontalLine:self.tableView.frame.size.width - 20
                                              originX:10
                                              originY:140
                                                color:[UIColor lightGrayColor]];
        _separatorLine.alpha = 0.6;
    }
    return _separatorLine;
}

- (GCHotThreadViewController *)hotThreadViewController {
    if (_hotThreadViewController == nil) {
        _hotThreadViewController = [[GCHotThreadViewController alloc] init];
    }
    return _hotThreadViewController;
}

- (GCForumIndexViewController *)forumIndexViewController {
    if (_forumIndexViewController == nil) {
        _forumIndexViewController = [[GCForumIndexViewController alloc] init];
    }
    return _forumIndexViewController;
}

- (GCMineViewController *)mineViewController {
    if (_mineViewController == nil) {
        _mineViewController = [[GCMineViewController alloc] init];
    }
    return _mineViewController;
}

- (GCSettingViewController *)settingViewController {
    if (_settingViewController == nil) {
        _settingViewController = [[GCSettingViewController alloc] init];
    }
    return _settingViewController;
}

- (GCMoreViewController *)moreViewController {
    if (_moreViewController == nil) {
        _moreViewController = [[GCMoreViewController alloc] init];
    }
    return _moreViewController;
}

@end
