//
//  GCMoreViewController.m
//  GuitarChina
//
//  Created by mac on 15/9/25.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCMoreViewController.h"
#import "GCMoreCell.h"

@interface GCMoreViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation GCMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"More", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    } else if (section == 1) {
        return 3;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GCMoreCell *cell = [[GCMoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    if (indexPath.section == 0) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            cell.titleLabel.text = NSLocalizedString(@"Night Mode", nil);
            cell.leftImageView.image = [UIImage imageNamed:@"icon_document"];
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
            cell.accessoryView = switchView;
            switchView.on = [[NSUserDefaults standardUserDefaults] boolForKey:kGCNIGHTMODE];
            [switchView addTarget:self action:@selector(nightModeAction:) forControlEvents:UIControlEventValueChanged];
        } else if (indexPath.row == 1) {
            cell.titleLabel.text = NSLocalizedString(@"Auto switch Night Mode", nil);
            cell.leftImageView.image = [UIImage imageNamed:@"icon_document"];
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
            cell.accessoryView = switchView;
            switchView.on = [[NSUserDefaults standardUserDefaults] boolForKey:kGCAUTOSWITCHNIGHTMODE];
            [switchView addTarget:self action:@selector(autoSwitchNightModeAction:) forControlEvents:UIControlEventValueChanged];
        } else if (indexPath.row == 2) {
            cell.titleLabel.text = NSLocalizedString(@"2G/3G/4G not load image", nil);
            cell.leftImageView.image = [UIImage imageNamed:@"icon_document"];
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
            cell.accessoryView = switchView;
            switchView.on = [[NSUserDefaults standardUserDefaults] boolForKey:kGCLOADIMAGE];
            [switchView addTarget:self action:@selector(loadImageAction:) forControlEvents:UIControlEventValueChanged];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.titleLabel.text = NSLocalizedString(@"Score", nil);
            cell.leftImageView.image = [UIImage imageNamed:@"icon_document"];
        } else if (indexPath.row == 1) {
            cell.titleLabel.text = NSLocalizedString(@"About GuitarChina", nil);
            cell.leftImageView.image = [UIImage imageNamed:@"icon_document"];
        } else if (indexPath.row == 2) {
            cell.titleLabel.text = NSLocalizedString(@"Version", nil);
            cell.leftImageView.image = [UIImage imageNamed:@"icon_document"];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 100)];
    view.backgroundColor = [UIColor GCVeryLightGrayBackgroundColor];
    UILabel *label = [UIView createLabel:CGRectMake(15, 5, 50, 20)
                                    text:@""
                                    font:[UIFont systemFontOfSize:16]
                               textColor:[UIColor GCDeepGrayColor]];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 29.5, ScreenWidth, 0.5)];
    line.backgroundColor = [UIColor GCGrayLineColor];
    [view addSubview:label];
    [view addSubview:line];
    
    if (section == 0) {
        label.text = @"设置";
    } else if (section == 1) {
        label.text = @"关于";
    }
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - Event Response

- (void)nightModeAction:(id)sender {
    UISwitch *switchView = (UISwitch *)sender;
    [[NSUserDefaults standardUserDefaults] setBool:switchView.on forKey:kGCNIGHTMODE];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (switchView.on) {
        [DKNightVersionManager nightFalling];
    } else {
        [DKNightVersionManager dawnComing];
    }
}

- (void)autoSwitchNightModeAction:(id)sender {
    UISwitch *switchView = (UISwitch *)sender;
    [[NSUserDefaults standardUserDefaults] setBool:switchView.on forKey:kGCAUTOSWITCHNIGHTMODE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)loadImageAction:(id)sender {
    UISwitch *switchView = (UISwitch *)sender;
    [[NSUserDefaults standardUserDefaults] setBool:switchView.on forKey:kGCLOADIMAGE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Private Methods

- (void)configureView {
    [self.view addSubview:self.tableView];
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

@end
