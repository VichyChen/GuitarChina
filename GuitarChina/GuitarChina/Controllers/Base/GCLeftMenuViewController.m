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

@interface GCLeftMenuViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) GCHotThreadViewController *hotThreadViewController;
@property (nonatomic, strong) GCForumIndexViewController *forumIndexViewController;
@property (nonatomic, strong) GCMineViewController *mineViewController;
@property (nonatomic, strong) GCSettingViewController *settingViewController;
@property (nonatomic, strong) GCMoreViewController *moreViewController;

@property (nonatomic, assign) NSInteger selectedIndex;

@end

@implementation GCLeftMenuViewController

#pragma mark - life cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _selectedIndex = 0;
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
        cell.selectedBackgroundView = [[UIView alloc] init];
    }
    
    NSArray *titles = @[NSLocalizedString(@"Hot Thread", nil),
                        NSLocalizedString(@"Forum", nil),
                        NSLocalizedString(@"Mine", nil),
                        NSLocalizedString(@"Setting", nil),
                        NSLocalizedString(@"More", nil)];
    //    NSArray *images = @[@"IconHome", @"IconCalendar", @"IconProfile", @"IconSettings", @"IconEmpty"];
    cell.textLabel.text = titles[indexPath.row];
    //    cell.imageView.image = [UIImage imageNamed:images[indexPath.row]];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.selectedIndex == indexPath.row) {
        [self.sideMenuViewController hideMenuViewController];
        return;
    }
    self.selectedIndex = indexPath.row;
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
    return 54;
}

#pragma mark - Getters

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height - 54 * 5) / 2.0f, self.view.frame.size.width, 54 * 5)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.opaque = NO;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.backgroundView = nil;
        _tableView.bounces = NO;
    }
    return _tableView;
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
