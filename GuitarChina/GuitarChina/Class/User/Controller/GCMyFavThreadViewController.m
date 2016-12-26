//
//  GCMyFavThreadViewController.m
//  GuitarChina
//
//  Created by mac on 15/10/28.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCMyFavThreadViewController.h"
#import "GCForumIndexCell.h"
#import "GCThreadDetailViewController.h"
#import "GCMyFavThreadCell.h"
#import "MJRefresh.h"

@interface GCMyFavThreadViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) GCTableViewKit *tableViewKit;

@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) NSMutableArray *rowHeightArray;

@end

@implementation GCMyFavThreadViewController

- (instancetype)init {
    if (self = [super init]) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"My Favour", nil);
    [self configureView];
    
    [self.tableView.header beginRefreshing];
}

#pragma mark - Private Methods

- (void)configureView {
    [self.view addSubview:self.tableView];
}

#pragma mark - HTTP

- (void)getMyFavThread {
    @weakify(self);
    [GCNetworkManager getMyFavThreadSuccess:^(GCMyFavThreadArray *array) {
        @strongify(self);
        self.data = array.data;
        self.rowHeightArray = [NSMutableArray array];
        for (GCMyFavThreadModel *model in self.data) {
            [self.rowHeightArray addObject:[NSNumber numberWithFloat:[GCMyFavThreadCell getCellHeightWithModel:model]]];
        }
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
    } failure:^(NSError *error) {
        @strongify(self);
        [self.tableView.header endRefreshing];
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"No Network Connection", nil)];
    }];
}

#pragma mark - Getters

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _tableView.backgroundColor = [GCColor backgroundColor];
        _tableView.tableFooterView = [[UIView alloc] init];
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        
        self.tableViewKit = [[GCTableViewKit alloc] initWithCellType:ConfigureCellTypeClass cellIdentifier:@"GCMyFavThreadCell"];
        @weakify(self);
        self.tableViewKit.getItemsBlock = ^{
            @strongify(self);
            return self.data;
        };
        self.tableViewKit.cellForRowBlock = ^(NSIndexPath *indexPath, id item, UITableViewCell *cell) {
            GCMyFavThreadCell *myFavThreadCell = (GCMyFavThreadCell *)cell;
            myFavThreadCell.model = item;
        };
        self.tableViewKit.heightForRowBlock = ^(NSIndexPath *indexPath, id item) {
            @strongify(self);
            NSNumber *height = [self.rowHeightArray objectAtIndex:indexPath.row];
            return (CGFloat)[height floatValue];
        };
        self.tableViewKit.didSelectCellBlock = ^(NSIndexPath *indexPath, id item) {
            @strongify(self);
            GCThreadDetailViewController *controller = [[GCThreadDetailViewController alloc] init];
            GCMyFavThreadModel *model = item;
            controller.tid = model.idfield;
            [self.navigationController pushViewController:controller animated:YES];
        };
        [self.tableViewKit configureTableView:_tableView];
        
        _tableView.header = ({
            @weakify(self);
            MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                @strongify(self);
                [self getMyFavThread];
            }];
            header.lastUpdatedTimeLabel.hidden = YES;
            header.stateLabel.hidden = YES;
            header;
        });
    }
    return _tableView;
}

@end
