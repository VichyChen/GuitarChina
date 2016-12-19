//
//  GCSettingViewController.m
//  GuitarChina
//
//  Created by mac on 15/10/28.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCSettingViewController.h"
#import "GCMineCell.h"
#import "GCUserProtocolViewController.h"

@interface GCSettingViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) GCTableViewKit *tableViewKit;

@property (nonatomic, copy) NSArray *array;

@end

@implementation GCSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Setting", nil);
    self.view.backgroundColor = [GCColor backgroundColor];
    
    [self configureView];
}

#pragma mark - Private Methods

- (void)configureView {
    [self.view addSubview:self.tableView];
}

#pragma mark - Event Responses

- (void)logoutAction {
    [UIAlertView bk_showAlertViewWithTitle:NSLocalizedString(@"确定要退出帐号吗？", nil) message:nil cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:@[NSLocalizedString(@"OK", nil)] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [Util clearCookie];
            [NSUD setObject:@"0" forKey:kGCLogin];
            [NSUD setObject:@"" forKey:kGCLoginName];
            [NSUD synchronize];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

#pragma mark - Getters

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)];
        _tableView.tableFooterView = [[UIView alloc] init];
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:UIEdgeInsetsZero];
        }
        
        self.tableViewKit = [[GCTableViewKit alloc] initWithItems:self.array cellType:ConfigureCellTypeClass cellIdentifier:@"GCMineCell"];
        @weakify(self);
        self.tableViewKit.cellForRowBlock = ^(NSIndexPath *indexPath, id item, UITableViewCell *cell) {
            GCMineCell *mineCell = (GCMineCell *)cell;
            NSDictionary *dictionary = item;
            mineCell.titleLabel.text = dictionary[@"title"];
        };
        self.tableViewKit.heightForRowBlock = ^(NSIndexPath *indexPath, id item) {
            if (indexPath.row == self.array.count - 1 && [[NSUD stringForKey:kGCLogin] isEqualToString:@"0"]) {
                return 0.0;
            } else {
                return 44.0;
            }
        };
        self.tableViewKit.didSelectCellBlock = ^(NSIndexPath *indexPath, id item) {
            @strongify(self);
            switch (indexPath.row) {
                case 0:
                    [Util openAppInAppStore:AppleID];
                    break;
                    
                case 1:
                    [self logoutAction];
                    break;
            }
        };
        [self.tableViewKit configureTableView:_tableView];
    }
    return _tableView;
}

- (NSArray *)array {
    if (!_array) {
        _array = @[@{@"image" : @"", @"title" : [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"CurrentVersion:", nil), [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]]}, @{@"image" : @"icon_law", @"title" :NSLocalizedString(@"Logout Account", nil)}];
    }
    return _array;
}

@end
