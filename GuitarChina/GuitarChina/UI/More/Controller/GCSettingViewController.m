//
//  GCSettingViewController.m
//  GuitarChina
//
//  Created by mac on 15/10/28.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCSettingViewController.h"
#import "GCSettingCell.h"
#import "GCUserProtocolViewController.h"

@interface GCSettingViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) GCTableViewKit *tableViewKit;

@property (nonatomic, copy) NSArray *array;

@end

@implementation GCSettingViewController

- (instancetype)init {
    if (self = [super init]) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

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
            [NSUD setInteger:0 forKey:kGCNewMyPost];
            [NSUD synchronize];
            [self.navigationController popViewControllerAnimated:NO];
            [APP.tabBarController updateMorePromptRedCount];
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
        
        _tableView.separatorLeftInset = 13;

        self.tableViewKit = [[GCTableViewKit alloc] initWithCellType:ConfigureCellTypeClass cellIdentifier:@"GCSettingCell"];
        @weakify(self);
        [self.tableViewKit setGetItemsBlock:^NSArray *{
            @strongify(self);
            return self.array;
        }];
        self.tableViewKit.cellForRowBlock = ^(NSIndexPath *indexPath, id item, UITableViewCell *cell) {
            @strongify(self);
            GCSettingCell *settingCell = (GCSettingCell *)cell;
            NSDictionary *dictionary = item;
            settingCell.titleLabel.text = dictionary[@"title"];
            settingCell.valueLabel.text = dictionary[@"value"];
            if (indexPath.row == self.array.count - 1) {
                settingCell.accessoryType = UITableViewCellAccessoryNone;
            } else {
                settingCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
        };
        self.tableViewKit.heightForRowBlock = ^CGFloat(NSIndexPath *indexPath, id item) {
            return 44.0f;
        };
        self.tableViewKit.didSelectCellBlock = ^(NSIndexPath *indexPath, id item) {
            @strongify(self);
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

            switch (indexPath.row) {
                case 0:
                    [[SDImageCache sharedImageCache] clearDisk];
                    [self.tableView reloadData];
                    break;
                case 1:
                    [Util openAppInAppStore:AppleID];
                    break;
            }
        };
        [self.tableViewKit configureTableView:_tableView];
    }
    return _tableView;
}

- (NSArray *)array {
    return @[@{@"image" : @"", @"title" : NSLocalizedString(@"Clear Cache", nil), @"value" : [NSString stringWithFormat:@"%.2fMB", [[SDImageCache sharedImageCache] getSize] / 1000.0 / 1000.0]}, @{@"image" : @"", @"title" : [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"CurrentVersion:", nil), [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]],  @"value" : @""}];
}

@end
