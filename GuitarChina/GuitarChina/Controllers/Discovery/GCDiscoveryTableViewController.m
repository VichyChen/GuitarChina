//
//  GCDiscoveryTableViewController.m
//  GuitarChina
//
//  Created by 陈大捷 on 16/4/10.
//  Copyright © 2016年 陈大捷. All rights reserved.
//

#import "GCDiscoveryTableViewController.h"
#import "GCDiscoveryCell.h"
#import "GCGuideThreadModel.h"
#import "GCThreadDetailViewController.h"
#import "MJRefresh.h"
#import "GCParseHTML.h"
#import "GCForumDisplayViewController.h"

@interface GCDiscoveryTableViewController ()

@property (nonatomic, copy) void (^refreshBlock)();

@end

@implementation GCDiscoveryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureBlock];
    
    [self configureView];
    
    self.pageIndex = 1;
    [self.tableView.header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"GCDiscoveryCell";
    GCDiscoveryCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[GCDiscoveryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    GCGuideThreadModel *model = [self.data objectAtIndex:indexPath.row];
    cell.model = model;
    @weakify(self);
    cell.forumButtonBlock = ^{
        @strongify(self);
        GCForumDisplayViewController *controller = [[GCForumDisplayViewController alloc] init];
        controller.hidesBottomBarWhenPushed = YES;
        controller.title = model.forum;
        controller.fid = model.fid;
        [self.navigationController pushViewController:controller animated:YES];
    };
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *height = [self.rowHeightArray objectAtIndex:indexPath.row];
    return [height floatValue];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GCThreadDetailViewController *controller = [[GCThreadDetailViewController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    GCGuideThreadModel *model = [self.data objectAtIndex:indexPath.row];
    controller.tid = model.tid;
    [self.navigationController pushViewController:controller animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Private Methods

- (void)configureView {
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc] init];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)configureBlock {
    @weakify(self);
    self.refreshBlock = ^{
        @strongify(self);
    
        void (^successBlock)(NSData *htmlData) = ^(NSData *htmlData) {
            GCGuideThreadArray *array = [GCParseHTML parseGuideThread:htmlData];
            self.data = array.data;
            if (self.pageIndex == 1) {
                [self.rowHeightArray removeAllObjects];
            }
            for (GCGuideThreadModel *model in self.data) {
                [self.rowHeightArray addObject: [NSNumber numberWithFloat:[GCDiscoveryCell getCellHeightWithModel:model]]];
            }
            [self.tableView reloadData];
            [self.tableView.header endRefreshing];
            [self.tableView.footer endRefreshing];
        };
        void (^failureBlock)() = ^{
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"No Network Connection", nil)];
            [self.tableView.header endRefreshing];
            [self.tableView.footer endRefreshing];
        };

        switch (self.discoveryTableViewType) {
            case GCDiscoveryTableViewTypeHot:
            {
                [[GCNetworkManager manager] getGuideHotSuccessWithPageIndex:self.pageIndex success:^(NSData *htmlData) {
                    successBlock(htmlData);
                } failure:^(NSError *error) {
                    failureBlock();
                }];
                break;
            }
            
            case GCDiscoveryTableViewTypeNew:
            {
                [[GCNetworkManager manager] getGuideNewSuccessWithPageIndex:self.pageIndex success:^(NSData *htmlData) {
                    successBlock(htmlData);
                } failure:^(NSError *error) {
                    failureBlock();
                }];
                break;
            }
            
            case GCDiscoveryTableViewTypeSofa:
            {
                [[GCNetworkManager manager] getGuideSofaSuccessWithPageIndex:self.pageIndex success:^(NSData *htmlData) {
                    successBlock(htmlData);
                } failure:^(NSError *error) {
                    failureBlock();
                }];
                break;
            }
            
            case GCDiscoveryTableViewTypeDigest:
            {
                [[GCNetworkManager manager] getGuideDigestSuccessWithPageIndex:self.pageIndex success:^(NSData *htmlData) {
                    successBlock(htmlData);
                } failure:^(NSError *error) {
                    failureBlock();
                }];
                break;
            }
        }
    };
}

#pragma mark - Getters

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64 - 40 - 44);
        self.tableView.header = ({
            MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                self.pageIndex = 1;
                self.refreshBlock();
            }];
            header.lastUpdatedTimeLabel.hidden = YES;
            header.stateLabel.hidden = YES;
            header;
        });
        
        if (self.pageIndex == 1) {
            self.tableView.footer = ({
                MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                    self.pageIndex++;
                    self.refreshBlock();
                }];
                footer.automaticallyRefresh = NO;
                footer.refreshingTitleHidden = YES;
                [footer setTitle:NSLocalizedString(@"Load More", nil) forState:MJRefreshStateIdle];
                footer;
            });
        }
    }
    return _tableView;
}

- (NSMutableArray *)rowHeightArray {
    if (!_rowHeightArray) {
        _rowHeightArray = [NSMutableArray array];
    }
    return _rowHeightArray;
}

@end
