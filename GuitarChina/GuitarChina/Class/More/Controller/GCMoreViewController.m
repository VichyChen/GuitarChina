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
#import "GCLoginViewController.h"
#import "GCSettingViewController.h"
#import "GCMyThreadViewController.h"
#import "GCMyFavThreadViewController.h"
#import "GCMyPromptViewController.h"

@interface GCMoreViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) GCTableViewKit *tableViewKit;

@property (nonatomic, strong) NSArray *array;

@end

@implementation GCMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"More", nil);
    self.edgesForExtendedLayout = UIRectEdgeAll;
    
    [self configureView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

#pragma mark - Private Methods

- (void)configureView {
    [self.view addSubview:self.tableView];
}

#pragma mark - Event Responses

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

#pragma mark - Getters

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [GCColor backgroundColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        self.tableViewKit = [[GCTableViewKit alloc] initWithSystem];
        @weakify(self);
        self.tableViewKit.numberOfSectionsInTableViewBlock = ^{
            @strongify(self);
            return (NSInteger)self.array.count;
        };
        self.tableViewKit.numberOfRowsInSectionBlock = ^(NSInteger section) {
            @strongify(self);
            NSDictionary *dictionary = self.array[section];
            NSArray *array = dictionary[[dictionary allKeys][0]];
            return (NSInteger)array.count;
        };
        self.tableViewKit.cellForRowAtIndexPathBlock = ^(NSIndexPath *indexPath) {
            @strongify(self);
            NSArray *array = self.array[indexPath.section][[self.array[indexPath.section] allKeys][0]];
            NSDictionary *dictionary = [array objectAtIndex:indexPath.row];
            
            GCMoreCell *cell = [[GCMoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.titleLabel.text = [dictionary objectForKey:@"title"];
            [cell.titleLabel sizeToFit];
            
            NSString *redCount = [dictionary objectForKey:@"redCount"];
            if ([redCount integerValue] == 0) {
                cell.redCountLabel.hidden = YES;
            } else {
                cell.redCountLabel.hidden = NO;
                if ([redCount integerValue] > 0) {
                    cell.redCountLabel.text = redCount;
                    cell.redCountLabel.frame = CGRectMake(cell.titleLabel.frame.origin.x + cell.titleLabel.frame.size.width + 20, cell.titleLabel.frame.origin.y, cell.titleLabel.frame.size.height, cell.titleLabel.frame.size.height);
                    cell.redCountLabel.layer.cornerRadius = cell.redCountLabel.frame.size.height / 2;
                } else if ([redCount integerValue] == -1) {
                    cell.redCountLabel.text = @" ";
                    cell.redCountLabel.frame = CGRectMake(cell.titleLabel.frame.origin.x + cell.titleLabel.frame.size.width + 10, cell.titleLabel.frame.origin.y, 8, 8);
                    cell.redCountLabel.layer.cornerRadius = 4;
                }
            }
            
            NSNumber *enable = [dictionary objectForKey:@"enable"];
            if ([enable boolValue]) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            return cell;
        };
        self.tableViewKit.heightForRowAtIndexPathBlock = ^CGFloat(NSIndexPath *indexPath) {
            return 44.0f;
        };
        self.tableViewKit.viewForHeaderInSectionBlock = ^(NSInteger section) {
            @strongify(self);
            if (section == 0) {
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 80)];
                view.backgroundColor = [UIColor whiteColor];
                
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 50, 50)];
                imageView.clipsToBounds = YES;
                imageView.layer.cornerRadius = 8;
                [view addSubview:imageView];
                
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame = CGRectMake(80, 30, 200, 20);
                button.enabled = NO;
                button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                [button setTitleColor:[GCColor fontColor] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:button];
                if ([[NSUD stringForKey:kGCLogin] isEqualToString:@"1"]) {
                    [button setTitle:[NSUD stringForKey:kGCLoginName] forState:UIControlStateNormal];
                    [imageView sd_setImageWithURL:[NSURL URLWithString:GCNetworkAPI_URL_BigAvtarImage([NSUD stringForKey:kGCLoginID])] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
                    button.titleLabel.font = [UIFont systemFontOfSize:16];
                } else {
                    [button setTitle:@"未登录" forState:UIControlStateNormal];
                    button.titleLabel.font = [UIFont systemFontOfSize:15];
                    imageView.image = [UIImage imageNamed:@"default_avatar"];
                }
                
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 79.5, ScreenWidth, 0.5)];
                line.backgroundColor = [GCColor separatorLineColor];
                [view addSubview:line];
                
                @weakify(self);
                [view bk_whenTapped:^{
                    @strongify(self);
                    [self loginAction];
                }];
                
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
        };
        self.tableViewKit.heightForHeaderInSectionBlock = ^CGFloat(NSInteger section) {
            if (section == 0) {
                return 80.0f;
            } else {
                return 40.0f;
            }
        };
        self.tableViewKit.viewForFooterInSectionBlock = ^(NSInteger section) {
            return [[UIView alloc] init];
        };
        self.tableViewKit.heightForFooterInSectionBlock = ^CGFloat(NSInteger section) {
            return 0.01f;
        };
        self.tableViewKit.didSelectRowAtIndexPathBlock = ^(NSIndexPath *indexPath) {
            @strongify(self);
            switch (indexPath.section) {
                case 0:
                    if (![[NSUD stringForKey:kGCLogin] isEqualToString:@"1"]) {
                        [self loginAction];
                    }
                    switch (indexPath.row) {
                        case 0://我的主题
                        {
                            GCMyThreadViewController *userThreadViewController = [[GCMyThreadViewController alloc] init];
                            [self.navigationController pushViewController:userThreadViewController animated:YES];
                            break;
                        }
                        case 1://我的收藏
                        {
                            GCMyFavThreadViewController *myFavThreadViewController = [[GCMyFavThreadViewController alloc] init];
                            [self.navigationController pushViewController:myFavThreadViewController animated:YES];
                            break;
                        }
                        case 2://我的提醒
                        {
                            GCMyPromptViewController * myPromptViewController = [[GCMyPromptViewController alloc] init];
                            [self.navigationController pushViewController:myPromptViewController animated:YES];
                        }
                    }
                    break;
                    
                case 1:
                    switch (indexPath.row) {
                        case 0://开发信息
                        {
                            GCThreadDetailViewController *controller = [[GCThreadDetailViewController alloc] init];
                            controller.tid = @"2036691";
                            [self.navigationController pushViewController:controller animated:YES];
                            
                            break;
                        }
                        case 1://意见反馈
                        {
                            GCThreadDetailViewController *controller = [[GCThreadDetailViewController alloc] init];
                            controller.tid = @"2036853";
                            [self.navigationController pushViewController:controller animated:YES];
                            
                            break;
                        }
                        case 2://评分
                        {
                            [Util openScorePageInAppStore:AppleID];
                            
                            break;
                        }
                        case 3:
                        {
                            GCSettingViewController *userOtherViewController = [[GCSettingViewController alloc] init];
                            [self.navigationController pushViewController:userOtherViewController animated:YES];
                            
                            break;
                        }
                    }
                    break;
            }
        };
        [self.tableViewKit configureTableView:_tableView];
    }
    return _tableView;
}

- (NSArray *)array {
    NSDictionary *myTheme = @{@"title" : NSLocalizedString(@"My Theme", nil), @"enable" : @YES, @"redCount" : @"0" };
    NSDictionary *myFavour = @{@"title" : NSLocalizedString(@"My Favour", nil), @"enable" : @YES, @"redCount" : @"0" };
    NSDictionary *myPromtpt = @{@"title" : NSLocalizedString(@"My Promtpt", nil), @"enable" : @YES, @"redCount" : [NSString stringWithFormat:@"%ld", [NSUD integerForKey:kGCNewMyPost]] };
    
    NSDictionary *developer = @{@"title" : NSLocalizedString(@"Information Development", nil), @"enable" : @YES, @"redCount" : @"0" };
    NSDictionary *feedback = @{@"title" : NSLocalizedString(@"Feedback", nil), @"enable" : @YES, @"redCount" : @"0" };
    NSDictionary *score = @{@"title" : NSLocalizedString(@"To Score", nil), @"enable" : @YES, @"redCount" : @"0" };
    NSDictionary *setting = @{@"title" : NSLocalizedString(@"Setting", nil), @"enable" : @YES, @"redCount" : @"0" };
    
    NSDictionary *meDictionary = @{NSLocalizedString(@"Me", nil) : @[myTheme, myFavour, myPromtpt] };
    NSDictionary *othersDictionary = @{ NSLocalizedString(@"Others", nil) : @[developer, feedback, score, setting] };
    
    return @[meDictionary, othersDictionary];
}

@end
