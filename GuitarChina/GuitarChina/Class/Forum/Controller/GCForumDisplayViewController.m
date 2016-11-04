//
//  GCForumDisplayViewController.m
//  GuitarChina
//
//  Created by 陈大捷 on 15/9/4.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCForumDisplayViewController.h"
#import "GCForumDisplayCell.h"
#import "GCPostThreadViewController.h"
#import "GCThreadDetailViewController.h"
#import "GCNavigationController.h"
#import "GCLoginViewController.h"

@interface GCForumDisplayViewController ()

@property (nonatomic, assign) BOOL loaded;
@property (nonatomic, strong) NSMutableArray *data;

@end

@implementation GCForumDisplayViewController

#pragma mark - life cycle

- (void)loadView {
    [super loadView];
    
    self.loaded = false;
    self.uid = 0;
    self.pageIndex = 1;
    self.pageSize = 20;

    self.navigationItem.rightBarButtonItem = [UIView createCustomBarButtonItem:@"icon_edit"
                                                                   normalColor:[UIColor whiteColor]
                                                              highlightedColor:[GCColor grayColor4]
                                                                        target:self
                                                                        action:@selector(newThreadAction)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureBlock];
    [self configureNotification];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kGCNotificationLoginSuccess object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"GCForumDisplayCell";
    GCForumDisplayCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[GCForumDisplayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    GCForumThreadModel *model = [self.data objectAtIndex:indexPath.row];
    [cell setModel:model];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *height = [self.rowHeightArray objectAtIndex:indexPath.row];
    return [height floatValue];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GCThreadDetailViewController *controller = [[GCThreadDetailViewController alloc] init];
    GCForumThreadModel *model = [self.data objectAtIndex:indexPath.row];
    controller.tid = model.tid;
    [self.navigationController pushViewController:controller animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Notification

- (void)configureNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAction) name:kGCNotificationLoginSuccess object:nil];
}

#pragma mark - Private Methods

- (void)configureBlock {
    @weakify(self);
    self.refreshBlock = ^{
        @strongify(self);
        [GCNetworkManager getForumDisplayWithForumID:self.fid pageIndex:self.pageIndex pageSize:self.pageSize success:^(GCForumDisplayArray *array) {
            self.loaded = true;
            self.uid = array.member_uid;
            self.formhash = array.formhash;
            self.threadTypes = array.threadTypes;
            
            if (!self.threadTypes || self.threadTypes.count == 0) {
                self.navigationItem.rightBarButtonItem = nil;
            }
            
            if (self.pageIndex == 1) {
                self.data = array.data;
                [self.rowHeightArray removeAllObjects];
                for (GCForumThreadModel *model in self.data) {
                    [self.rowHeightArray addObject: [NSNumber numberWithFloat:[GCForumDisplayCell getCellHeightWithModel:model]]];
                }
                [self.tableView reloadData];
                [self endRefresh];
            } else {
                for (GCForumThreadModel *model in array.data) {
                    [self.data addObject:model];
                    [self.rowHeightArray addObject: [NSNumber numberWithFloat:[GCForumDisplayCell getCellHeightWithModel:model]]];
                }
                [self.tableView reloadData];
                [self endFetchMore];
            }
        } failure:^(NSError *error) {
            [self endRefresh];
            [self endFetchMore];
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"No Network Connection", nil)];
        }];
    };
}

- (void)refreshAction {
    self.loaded = false;
    APP.tabBarController.selectedIndex = 1;
    [self beginRefresh];
}

- (void)newThreadAction {
    if (self.loaded == YES) {
        if ([self.uid isEqualToString:@"0"]) {
            GCLoginViewController *loginViewController = [[GCLoginViewController alloc] initWithNibName:@"GCLoginViewController" bundle:nil];
            [self presentViewController:loginViewController animated:YES completion:nil];
        }
        else if (!self.threadTypes || self.threadTypes.count == 0) {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"GuitarChina Interface Error", nil)];
        }
        else {
            GCPostThreadViewController *controller = [[GCPostThreadViewController alloc] initWithNibName:@"GCPostThreadViewController" bundle:[NSBundle mainBundle]];
            controller.fid = self.fid;
            controller.formhash = self.formhash;
            controller.threadTypes = self.threadTypes;
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
}


@end
