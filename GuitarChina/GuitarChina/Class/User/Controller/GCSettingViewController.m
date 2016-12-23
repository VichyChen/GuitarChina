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
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = NSLocalizedString(@"Setting", nil);
    
    [self configureView];
}

#pragma mark - Private Methods

- (void)configureView {
    [self.view addSubview:self.tableView];
}

#pragma mark - Event Responses

- (void)logoutAction {
    [UIAlertView bk_showAlertViewWithTitle:NSLocalizedString(@"Are you sure you want to exit?", nil) message:nil cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:@[NSLocalizedString(@"OK", nil)] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [Util clearCookie];
            [NSUD setObject:@"0" forKey:kGCLogin];
            [NSUD setObject:@"" forKey:kGCLoginName];
            [NSUD synchronize];
            [self.navigationController popViewControllerAnimated:NO];
            APP.tabBarController.selectedIndex = 0;
        }
    }];
}

#pragma mark - Getters

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)];
        _tableView.backgroundColor = [GCColor backgroundColor];

        UIView *footerView = [[UIView alloc] init];
        
        if ([[NSUD stringForKey:kGCLogin] isEqualToString:@"1"]) {
            footerView.frame = CGRectMake(0, 0, ScreenWidth, 80);
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            button.frame = CGRectMake(0, 20, ScreenWidth, 40);
            button.backgroundColor = [UIColor whiteColor];
            [button setTitleColor:[GCColor redColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:16];
            [button setTitle:NSLocalizedString(@"Logout Account", nil) forState:UIControlStateNormal];
            [button addTarget:self action:@selector(logoutAction) forControlEvents:UIControlEventTouchUpInside];
            [footerView addSubview:button];
        }
        
        _tableView.tableFooterView = footerView;

        
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 13, 0, 0)];
        }
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:UIEdgeInsetsMake(0, 13, 0, 0)];
        }
        
        self.tableViewKit = [[GCTableViewKit alloc] initWithCellType:ConfigureCellTypeClass cellIdentifier:@"GCMineCell"];
        @weakify(self);
        self.tableViewKit.getItemsBlock = ^{
            @strongify(self);
            return self.array;
        };
        self.tableViewKit.cellForRowBlock = ^(NSIndexPath *indexPath, id item, UITableViewCell *cell) {
            GCMineCell *mineCell = (GCMineCell *)cell;
            NSDictionary *dictionary = item;
            mineCell.titleLabel.text = dictionary[@"title"];
        };
        self.tableViewKit.heightForRowBlock = ^(NSIndexPath *indexPath, id item) {
            return 44.0;
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
        _array = @[@{@"image" : @"", @"title" : [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"CurrentVersion:", nil), [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]]}];
    }
    return _array;
}

@end
