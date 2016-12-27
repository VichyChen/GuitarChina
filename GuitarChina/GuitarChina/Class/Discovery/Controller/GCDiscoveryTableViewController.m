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
#import "GCHTMLParse.h"
#import "GCForumDisplayViewController.h"
#import "GCSearchViewController.h"

@interface GCDiscoveryTableViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) GCTableViewKit *tableViewKit;

@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) NSMutableArray *rowHeightArray;
@property (nonatomic, assign) NSInteger pageIndex;

@end

@implementation GCDiscoveryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureView];
    
    [self.tableView.header beginRefreshing];
}

#pragma mark - Private Methods

- (void)configureView {    
    [self.view addSubview:self.tableView];
}

#pragma mark - HTTP

- (void)getDiscovery {
    void (^successBlock)(NSData *htmlData) = ^(NSData *htmlData) {
        GCGuideThreadArray *array = [GCHTMLParse parseGuideThread:htmlData];
        self.data = array.data;
        if (self.pageIndex == 1) {
            self.rowHeightArray = [NSMutableArray array];
        }
        for (GCGuideThreadModel *model in self.data) {
            [self.rowHeightArray addObject: [NSNumber numberWithFloat:[GCDiscoveryCell getCellHeightWithModel:model]]];
        }
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
    };
    void (^failureBlock)() = ^{
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"No Network Connection", nil)];
        [self.tableView.header endRefreshing];
    };
    
    switch (self.discoveryTableViewType) {
        case GCDiscoveryTableViewTypeHot:
        {
            [GCNetworkManager getGuideHotSuccessWithPageIndex:self.pageIndex success:^(NSData *htmlData) {
                successBlock(htmlData);
            } failure:^(NSError *error) {
                failureBlock();
            }];
            break;
        }
            
        case GCDiscoveryTableViewTypeNew:
        {
            [GCNetworkManager getGuideNewSuccessWithPageIndex:self.pageIndex success:^(NSData *htmlData) {
                successBlock(htmlData);
            } failure:^(NSError *error) {
                failureBlock();
            }];
            break;
        }
            
        case GCDiscoveryTableViewTypeSofa:
        {
            [GCNetworkManager getGuideSofaSuccessWithPageIndex:self.pageIndex success:^(NSData *htmlData) {
                successBlock(htmlData);
            } failure:^(NSError *error) {
                failureBlock();
            }];
            break;
        }
            
        case GCDiscoveryTableViewTypeDigest:
        {
            [GCNetworkManager getGuideDigestSuccessWithPageIndex:self.pageIndex success:^(NSData *htmlData) {
                successBlock(htmlData);
            } failure:^(NSError *error) {
                failureBlock();
            }];
            break;
        }
    }
}

#pragma mark - Getters

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64 - 40 - 48);
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 13, 0, 0)];
        }
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:UIEdgeInsetsMake(0, 13, 0, 0)];
        }
        _tableView.tableFooterView = [[UIView alloc] init];

        self.tableViewKit = [[GCTableViewKit alloc] initWithCellType:ConfigureCellTypeClass cellIdentifier:@"GCDiscoveryCell"];
        @weakify(self);
        self.tableViewKit.getItemsBlock = ^{
            @strongify(self);
            return self.data;
        };
        self.tableViewKit.cellForRowBlock = ^(NSIndexPath *indexPath, id item, UITableViewCell *cell) {
            @strongify(self);
            GCDiscoveryCell *discoveryCell = (GCDiscoveryCell *)cell;
            GCGuideThreadModel *model = (GCGuideThreadModel *)item;
            discoveryCell.model = model;
            discoveryCell.forumButtonBlock = ^{
                @strongify(self);
                GCForumDisplayViewController *controller = [[GCForumDisplayViewController alloc] init];
                controller.title = model.forum;
                controller.fid = model.fid;
                [self.navigationController pushViewController:controller animated:YES];
            };
        };
        self.tableViewKit.heightForRowBlock = ^(NSIndexPath *indexPath, id item) {
            @strongify(self);
            NSNumber *height = [self.rowHeightArray objectAtIndex:indexPath.row];
            return (CGFloat)[height floatValue];
        };
        self.tableViewKit.didSelectCellBlock = ^(NSIndexPath *indexPath, id item) {
            @strongify(self);
            GCThreadDetailViewController *controller = [[GCThreadDetailViewController alloc] init];
            GCGuideThreadModel *model = [self.data objectAtIndex:indexPath.row];
            controller.tid = model.tid;
            [self.navigationController pushViewController:controller animated:YES];
        };
        [self.tableViewKit configureTableView:_tableView];
        
        _tableView.header = ({
            MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                self.pageIndex = 1;
                [self getDiscovery];
            }];
            header.lastUpdatedTimeLabel.hidden = YES;
            header.stateLabel.hidden = YES;
            header;
        });
    }
    return _tableView;
}

@end
