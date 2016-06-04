//
//  GCMoreViewController.m
//  GuitarChina
//
//  Created by mac on 15/9/25.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCMoreViewController.h"
#import "GCMoreCell.h"
#import "GCThreadDetailViewController.h"

@interface GCMoreViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *array;

@property (nonatomic, strong) NSDictionary *dictionary;

@end

@implementation GCMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"More", nil);
    self.view.backgroundColor = [UIColor GCBackgroundColor];
    
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
    NSArray *array = [self.dictionary objectForKey:[self.dictionary.allKeys objectAtIndex:section]];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    GCMoreCell *cell = [[GCMoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    //    if (indexPath.section == 0) {
    //        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //        if (indexPath.row == 0) {
    //            cell.titleLabel.text = NSLocalizedString(@"Night Mode", nil);
    //            cell.leftImageView.image = [UIImage imageNamed:@"icon_document"];
    //            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    //            cell.accessoryView = switchView;
    //            switchView.on = [NSUD boolForKey:kGCNIGHTMODE];
    //            [switchView addTarget:self action:@selector(nightModeAction:) forControlEvents:UIControlEventValueChanged];
    //        } else if (indexPath.row == 1) {
    //            cell.titleLabel.text = NSLocalizedString(@"Auto switch Night Mode", nil);
    //            cell.leftImageView.image = [UIImage imageNamed:@"icon_document"];
    //            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    //            cell.accessoryView = switchView;
    //            switchView.on = [NSUD boolForKey:kGCAUTOSWITCHNIGHTMODE];
    //            [switchView addTarget:self action:@selector(autoSwitchNightModeAction:) forControlEvents:UIControlEventValueChanged];
    //        } else if (indexPath.row == 2) {
    //            cell.titleLabel.text = NSLocalizedString(@"2G/3G/4G not load image", nil);
    //            cell.leftImageView.image = [UIImage imageNamed:@"icon_document"];
    //            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    //            cell.accessoryView = switchView;
    //            switchView.on = [NSUD boolForKey:kGCLOADIMAGE];
    //            [switchView addTarget:self action:@selector(loadImageAction:) forControlEvents:UIControlEventValueChanged];
    //        }
    //    } else if (indexPath.section == 1) {
    //        if (indexPath.row == 0) {
    //            cell.titleLabel.text = NSLocalizedString(@"Score", nil);
    //            cell.leftImageView.image = [UIImage imageNamed:@"icon_document"];
    //        } else if (indexPath.row == 1) {
    //            cell.titleLabel.text = NSLocalizedString(@"About GuitarChina", nil);
    //            cell.leftImageView.image = [UIImage imageNamed:@"icon_document"];
    //        } else if (indexPath.row == 2) {
    //            cell.titleLabel.text = NSLocalizedString(@"Version", nil);
    //            cell.leftImageView.image = [UIImage imageNamed:@"icon_document"];
    //            cell.accessoryType = UITableViewCellAccessoryNone;
    //            cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //        }
    //    }
    
    NSString *key = [[self.dictionary allKeys] objectAtIndex:indexPath.section];
    NSArray *array = [self.dictionary objectForKey:key];
    NSDictionary *dictionary = [array objectAtIndex:indexPath.row];
    
    GCMoreCell *cell = [[GCMoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.titleLabel.text = [dictionary objectForKey:@"title"];
    
    NSNumber *enable = [dictionary objectForKey:@"enable"];
    if ([enable boolValue]) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    view.backgroundColor = [UIColor GCBackgroundColor];
    UILabel *label = [UIView createLabel:CGRectMake(15, 0, 200, 40)
                                    text:@""
                                    font:[UIFont systemFontOfSize:16]
                               textColor:[UIColor GCBlueColor]];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, ScreenWidth, 0.5)];
    line.backgroundColor = [UIColor GCSeparatorLineColor];
    [view addSubview:label];
    [view addSubview:line];
    
    label.text = [[self.dictionary allKeys] objectAtIndex:section];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0://吉他中国
                {
                    GCThreadDetailViewController *controller = [[GCThreadDetailViewController alloc] init];
                    controller.hidesBottomBarWhenPushed = YES;
                    controller.tid = @"58664";
                    [self.navigationController pushViewController:controller animated:YES];
                    
                    break;
                }
                case 1://琴国乐器
                {
                    GCThreadDetailViewController *controller = [[GCThreadDetailViewController alloc] init];
                    controller.hidesBottomBarWhenPushed = YES;
                    controller.tid = @"1790525";
                    [self.navigationController pushViewController:controller animated:YES];
                    
                    break;
                }
                case 2://蘑菇音乐
                {
                    GCThreadDetailViewController *controller = [[GCThreadDetailViewController alloc] init];
                    controller.hidesBottomBarWhenPushed = YES;
                    controller.tid = @"2040865";
                    [self.navigationController pushViewController:controller animated:YES];

                    break;
                }
            }
            break;
            
        case 1:
            switch (indexPath.row) {
                case 0://开发信息
                {
                    GCThreadDetailViewController *controller = [[GCThreadDetailViewController alloc] init];
                    controller.hidesBottomBarWhenPushed = YES;
                    controller.tid = @"2036691";
                    [self.navigationController pushViewController:controller animated:YES];
                    
                    break;
                }
                case 1://意见反馈
                {
                    GCThreadDetailViewController *controller = [[GCThreadDetailViewController alloc] init];
                    controller.hidesBottomBarWhenPushed = YES;
                    controller.tid = @"2036853";
                    [self.navigationController pushViewController:controller animated:YES];
                    
                    break;
                }
                case 2://评分
                {
                    [Util openScorePageInAppStore:AppleID];
                    
                    break;
                }
            }
            break;
    }
}

#pragma mark - Event Responses

- (void)nightModeAction:(id)sender {
    UISwitch *switchView = (UISwitch *)sender;
    [NSUD setBool:switchView.on forKey:kGCNIGHTMODE];
    [NSUD synchronize];
    
    if (switchView.on) {
        [DKNightVersionManager nightFalling];
    } else {
        [DKNightVersionManager dawnComing];
    }
}

- (void)autoSwitchNightModeAction:(id)sender {
    UISwitch *switchView = (UISwitch *)sender;
    [NSUD setBool:switchView.on forKey:kGCAUTOSWITCHNIGHTMODE];
    [NSUD synchronize];
}

- (void)loadImageAction:(id)sender {
    UISwitch *switchView = (UISwitch *)sender;
    [NSUD setBool:switchView.on forKey:kGCLOADIMAGE];
    [NSUD synchronize];
}

#pragma mark - Private Methods

- (void)configureView {
    [self.view addSubview:self.tableView];
}

#pragma mark - Getters

- (UITableView *)tableView {
    if (!_tableView) {
        //        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)];
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor GCBackgroundColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

- (NSDictionary *)dictionary {
    if (!_dictionary) {
        NSDictionary *guitarchina = @{@"title" : NSLocalizedString(@"About GuitarChina", nil), @"enable" : @YES };
        NSDictionary *musicInstrument = @{@"title" : NSLocalizedString(@"Musical Instruments", nil), @"enable" : @YES };
        NSDictionary *mushroomMusic = @{@"title" : NSLocalizedString(@"Mushroom Music", nil), @"enable" : @YES };
        
        NSDictionary *developer = @{@"title" : NSLocalizedString(@"Information Development", nil), @"enable" : @YES };
        NSDictionary *feedback = @{@"title" : NSLocalizedString(@"Feedback", nil), @"enable" : @YES };
        NSDictionary *score = @{@"title" : NSLocalizedString(@"To Score", nil), @"enable" : @YES };
        NSDictionary *version = @{@"title" : [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"CurrentVersion:", nil), CurrentVersion], @"enable" : @NO };
        
        _dictionary = @{ NSLocalizedString(@"Official", nil) : @[guitarchina, musicInstrument, mushroomMusic],
                         NSLocalizedString(@"Others", nil) : @[developer, feedback, score, version] };
    }
    return _dictionary;
}

@end
