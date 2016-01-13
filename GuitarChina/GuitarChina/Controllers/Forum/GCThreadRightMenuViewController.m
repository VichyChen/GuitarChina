//
//  GCThreadRightMenuViewController.m
//  GuitarChina
//
//  Created by mac on 15/9/28.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCThreadRightMenuViewController.h"
#import "GCThreadRightMenuCell.h"
#import "GCReplyThreadViewController.h"
#import "GCNavigationController.h"
#import "GCThreadRightMenuCollectionCell.h"
#import "GCReportThreadViewController.h"
#import "GCLoginViewController.h"

#define GCThreadRightMenuCellHeightIniPhone 55
#define GCThreadRightMenuCellHeightIniPad 55

@interface GCThreadRightMenuViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, copy) NSArray *titleArray;
@property (nonatomic, copy) NSArray *imageArray;

@end

@implementation GCThreadRightMenuViewController

#pragma mark - life cycle

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _titleArray = @[NSLocalizedString(@"Reply", nil),
                        NSLocalizedString(@"Favorite", nil),
                        NSLocalizedString(@"Report", nil),
                        NSLocalizedString(@"Open in Safari", nil),
                        NSLocalizedString(@"Copy URL", nil)];
        _imageArray = @[@"icon_edit", @"icon_collect", @"icon_error", @"icon_externallink", @"icon_link"];
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    [self.view addSubview:self.tableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex {
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"GCThreadRightMenuCell";
    GCThreadRightMenuCell *cell = (GCThreadRightMenuCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[GCThreadRightMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.titleLabel.text = self.titleArray[indexPath.row];
    cell.iconImageView.image = [[UIImage imageNamed:self.imageArray[indexPath.row]] imageWithTintColor:[UIColor GCRedColor]];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0: {
            if ([self.uid isEqualToString:@"0"]) {
                [self presentLoginViewController];
            } else {
                [self replyAction];
            }
            [ApplicationDelegate.sideMenuViewController hideMenuViewController];
            
            break;
        }
        case 1:
            if ([self.uid isEqualToString:@"0"]) {
                [self presentLoginViewController];
                [ApplicationDelegate.sideMenuViewController hideMenuViewController];
            } else {
                [self collectAction];
            }

            break;
        case 2:
            [ApplicationDelegate.sideMenuViewController hideMenuViewController];
            [self reportAction];
            
            break;
        case 3:
            [self safariAction];
            [ApplicationDelegate.sideMenuViewController hideMenuViewController];
            
            break;
        case 4:
            [self copyURLAction];
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Copy complete", nil)];
            
            break;
        case 5:
            
            [ApplicationDelegate.sideMenuViewController hideMenuViewController];
            [self shareAction];
            
            break;

        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (iPhone) {
        return GCThreadRightMenuCellHeightIniPad;
    } else {
        return GCThreadRightMenuCellHeightIniPad;
    }
}

#pragma mark - Event Response

- (void)replyAction {
    GCReplyThreadViewController *controller = [[GCReplyThreadViewController alloc] init];
    controller.tid = self.tid;
    controller.formhash = self.formhash;
    GCNavigationController *navigationController = [[GCNavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)collectAction {
    [[GCNetworkManager manager] getCollectionWithTid:self.tid formhash:self.formhash Success:^(NSString *string){
        [SVProgressHUD showSuccessWithStatus:string];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Collect Failure", nil)];
    }];
}

- (void)shareAction {
}

- (void)safariAction {
    [Util openUrlInSafari:GCNETWORKAPI_URL_THREAD(self.tid)];
}

- (void)copyURLAction {
    [Util copyToPasteboard:GCNETWORKAPI_URL_THREAD(self.tid)];
}

- (void)reportAction {
    GCReportThreadViewController *controller = [[GCReportThreadViewController alloc] init];
    controller.tid = self.tid;
    GCNavigationController *navigationController = [[GCNavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark - Private Methods

- (void)presentLoginViewController {
    GCLoginViewController *loginViewController = [[GCLoginViewController alloc] initWithNibName:@"GCLoginViewController" bundle:nil];
    [self presentViewController:loginViewController animated:YES completion:nil];
}

#pragma mark - Getters

- (UITableView *)tableView {
    if (!_tableView) {
        CGRect frame;
        if (iPhone) {
            frame = CGRectMake(ScreenWidth - (ScreenWidth / 2 + LeftSideMenuOffsetCenterXIniPhone), (ScreenHeight - GCThreadRightMenuCellHeightIniPhone * self.titleArray.count) / 2, ScreenWidth / 2 + LeftSideMenuOffsetCenterXIniPhone, GCThreadRightMenuCellHeightIniPhone * self.titleArray.count);
        } else {
            frame = CGRectMake(ScreenWidth - (ScreenWidth / 2 + LeftSideMenuOffsetCenterXIniPad), (ScreenHeight - GCThreadRightMenuCellHeightIniPad * self.titleArray.count) / 2, ScreenWidth / 2 + LeftSideMenuOffsetCenterXIniPad, GCThreadRightMenuCellHeightIniPad * self.titleArray.count);
        }
        _tableView = [[UITableView alloc] initWithFrame:frame];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.bounces = NO;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    }
    return _tableView;
}

@end
