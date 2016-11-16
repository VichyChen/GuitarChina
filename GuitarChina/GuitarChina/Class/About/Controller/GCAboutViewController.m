//
//  GCAboutViewController.m
//  GuitarChina
//
//  Created by mac on 15/9/25.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCAboutViewController.h"
#import "GCAboutCell.h"
#import "GCThreadDetailViewController.h"
#import "GCLoginViewController.h"
#import "GCUserOtherViewController.h"
#import "GCMyThreadViewController.h"
#import "GCMyFavThreadViewController.h"

@interface GCAboutViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *array;

@end

@implementation GCAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"About", nil);
    self.view.backgroundColor = [GCColor backgroundColor];
    self.edgesForExtendedLayout = UIRectEdgeAll;
    
    @weakify(self);
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"icon_setting"] style:UIBarButtonItemStylePlain handler:^(id sender) {
        @strongify(self);
        GCUserOtherViewController *userOtherViewController = [[GCUserOtherViewController alloc] init];
        userOtherViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:userOtherViewController animated:YES];
    }];
    rightBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    [self configureView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.array.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *dictionary = self.array[section];
    NSArray *array = dictionary[[dictionary allKeys][0]];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *array = self.array[indexPath.section][[self.array[indexPath.section] allKeys][0]];
    NSDictionary *dictionary = [array objectAtIndex:indexPath.row];
    
    GCAboutCell *cell = [[GCAboutCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
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
    if (section == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 80)];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 50, 50)];
        imageView.backgroundColor = [GCColor redColor];
        imageView.clipsToBounds = YES;
        imageView.layer.cornerRadius = 8;
        [imageView sd_setImageWithURL:[NSURL URLWithString:GCNETWORKAPI_URL_BIGAVTARIMAGE([NSUD stringForKey:kGCLoginID])]];
        [view addSubview:imageView];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(80, 30, 200, 20);
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [button setTitleColor:[GCColor fontColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        if ([[NSUD stringForKey:kGCLogin] isEqualToString:@"1"]) {
            [button setTitle:[NSUD stringForKey:kGCLoginName] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:16];
        } else {
            [button setTitle:@"未登录" forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:15];
        }

        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 79.5, ScreenWidth, 0.5)];
        line.backgroundColor = [GCColor separatorLineColor];
        [view addSubview:line];
        
        return view;
    } else {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
        view.backgroundColor = [GCColor backgroundColor];
        UILabel *label = [UIView createLabel:CGRectMake(15, 0, 200, 40)
                                        text:@""
                                        font:[UIFont systemFontOfSize:16]
                                   textColor:[GCColor blueColor]];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, ScreenWidth, 0.5)];
        line.backgroundColor = [GCColor separatorLineColor];
        [view addSubview:label];
        [view addSubview:line];
        
        NSDictionary *dictionary = self.array[section];
        label.text = [dictionary allKeys][0];
        
        return view;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 80;
    } else {
        return 40;
    }
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
                case 0://我的主题
                {
                    if ([[NSUD stringForKey:kGCLogin] isEqualToString:@"1"]) {
                        GCMyThreadViewController *userThreadViewController = [[GCMyThreadViewController alloc] init];
                        userThreadViewController.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:userThreadViewController animated:YES];
                    } else {
                        [self loginAction];
                    }
                    break;
                }
                case 1://我的收藏
                {
                    if ([[NSUD stringForKey:kGCLogin] isEqualToString:@"1"]) {
                        GCMyFavThreadViewController *myFavThreadViewController = [[GCMyFavThreadViewController alloc] init];
                        myFavThreadViewController.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:myFavThreadViewController animated:YES];
                    } else {
                        [self loginAction];
                    }
                    break;
                }
            }
            break;
            
        case 1:
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
            
        case 2:
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
    [NSUD setBool:switchView.on forKey:kGCNightMode];
    [NSUD synchronize];
    
    if (switchView.on) {
        [DKNightVersionManager nightFalling];
    } else {
        [DKNightVersionManager dawnComing];
    }
}

- (void)autoSwitchNightModeAction:(id)sender {
    UISwitch *switchView = (UISwitch *)sender;
    [NSUD setBool:switchView.on forKey:kGCAutoSwitchNightMode];
    [NSUD synchronize];
}

- (void)loadImageAction:(id)sender {
    UISwitch *switchView = (UISwitch *)sender;
    [NSUD setBool:switchView.on forKey:kGCLoadImage];
    [NSUD synchronize];
}

- (void)loginAction {
    if (![[NSUD stringForKey:kGCLogin] isEqualToString:@"1"]) {
        GCLoginViewController *loginViewController = [[GCLoginViewController alloc] initWithNibName:@"GCLoginViewController" bundle:nil];
        @weakify(self);
        loginViewController.loginSuccessBlock = ^{
            @strongify(self);
            [self.tableView reloadData];
        };
        GCNavigationController *navigationController = [[GCNavigationController alloc] initWithRootViewController:loginViewController];
        [self presentViewController:navigationController animated:YES completion:nil];
    }
}

#pragma mark - Private Methods

- (void)configureView {
    [self.view addSubview:self.tableView];
}

#pragma mark - Getters

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [GCColor backgroundColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = YES;
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

- (NSArray *)array {
    if (!_array) {
        NSDictionary *myTheme = @{@"title" : NSLocalizedString(@"My Theme", nil), @"enable" : @YES };
        NSDictionary *myFavour = @{@"title" : NSLocalizedString(@"My Favour", nil), @"enable" : @YES };

        NSDictionary *guitarchina = @{@"title" : NSLocalizedString(@"GuitarChina", nil), @"enable" : @YES };
        NSDictionary *musicInstrument = @{@"title" : NSLocalizedString(@"Musical Instruments", nil), @"enable" : @YES };
        NSDictionary *mushroomMusic = @{@"title" : NSLocalizedString(@"Mushroom Music", nil), @"enable" : @YES };
        NSDictionary *guitarChinaTaobao = @{@"title" : NSLocalizedString(@"Taobao", nil), @"enable" : @YES };
        NSDictionary *guitarChinaWeixin = @{@"title" : NSLocalizedString(@"WechatShop", nil), @"enable" : @YES };
        NSDictionary *weibo = @{@"title" : NSLocalizedString(@"Weibo", nil), @"enable" : @YES };
        NSDictionary *weixin = @{@"title" : NSLocalizedString(@"Wechat", nil), @"enable" : @YES };

        NSDictionary *developer = @{@"title" : NSLocalizedString(@"Information Development", nil), @"enable" : @YES };
        NSDictionary *feedback = @{@"title" : NSLocalizedString(@"Feedback", nil), @"enable" : @YES };
        NSDictionary *score = @{@"title" : NSLocalizedString(@"To Score", nil), @"enable" : @YES };
        NSDictionary *version = @{@"title" : [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"CurrentVersion:", nil), [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]], @"enable" : @NO };
        
        NSDictionary *meDictionary = @{NSLocalizedString(@"Me", nil) : @[myTheme, myFavour] };
        NSDictionary *officialDictionary = @{ NSLocalizedString(@"Official", nil) : @[guitarchina, musicInstrument, mushroomMusic, guitarChinaTaobao, guitarChinaWeixin, weibo, weixin] };
        NSDictionary *othersDictionary = @{ NSLocalizedString(@"Others", nil) : @[developer, feedback, score, version] };
        
        _array = @[meDictionary, officialDictionary, othersDictionary];
    }
    
    return _array;
}

@end
