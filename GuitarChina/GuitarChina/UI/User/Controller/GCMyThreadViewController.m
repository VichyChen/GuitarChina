//
//  GCMyThreadViewController.m
//  GuitarChina
//
//  Created by mac on 15/10/28.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCMyThreadViewController.h"
#import "GCMyThreadCell.h"
#import "GCThreadDetailViewController.h"

@interface GCMyThreadViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) GCTableViewKit *tableViewKit;

@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) NSMutableArray *rowHeightArray;

@end

@implementation GCMyThreadViewController

- (instancetype)init {
    if (self = [super init]) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的主题";
    [self configureView];
    
    [self.tableView headerBeginRefresh];
}

#pragma mark - Private Methods

- (void)configureView {
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self.view addSubview:self.tableView];
}

#pragma mark - HTTP

- (void)getMyThread {
    @weakify(self);
    [GCNetworkManager getMyThreadSuccess:^(GCMyThreadArray *array) {
        @strongify(self);
        self.data = array.data;
        self.rowHeightArray = [NSMutableArray array];
        for (GCMyThreadModel *model in self.data) {
            [self.rowHeightArray addObject: [NSNumber numberWithFloat:[GCMyThreadCell getCellHeightWithModel:model]]];
        }
        [self.tableView reloadData];
        [self.tableView headerEndRefresh];
    } failure:^(NSError *error) {
        @strongify(self);
        [self.tableView headerEndRefresh];
        [SVProgressHUD showErrorWithStatus:@"没有网络连接！"];
    }];
}

#pragma mark - Getters

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigatioinBarHeight)];
        _tableView.backgroundColor = [GCColor backgroundColor];
        [_tableView initFooterView];
        _tableView.separatorLeftInset = 0;

        self.tableViewKit = [[GCTableViewKit alloc] initWithCellType:ConfigureCellTypeClass cellIdentifier:@"GCMyThreadCell"];
        @weakify(self);
        [self.tableViewKit setGetItemsBlock:^NSArray *{
            @strongify(self);
            return self.data;
        }];
        self.tableViewKit.cellForRowBlock = ^(NSIndexPath *indexPath, id item, UITableViewCell *cell) {
            GCMyThreadCell *myThreadCell = (GCMyThreadCell *)cell;
            myThreadCell.model = item;
        };
        self.tableViewKit.heightForRowBlock = ^(NSIndexPath *indexPath, id item) {
            @strongify(self);
            NSNumber *height = [self.rowHeightArray objectAtIndex:indexPath.row];
            return (CGFloat)[height floatValue];
        };
        self.tableViewKit.didSelectCellBlock = ^(NSIndexPath *indexPath, id item) {
            @strongify(self);
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

            GCThreadDetailViewController *controller = [[GCThreadDetailViewController alloc] init];
            GCMyThreadModel *model = item;
            controller.tid = model.tid;
            [self.navigationController pushViewController:controller animated:YES];
        };
        [self.tableViewKit configureTableView:_tableView];
        
        [_tableView setHeaderRefreshBlock:^{
            @strongify(self);
            [self getMyThread];
        }];
    }
    return _tableView;
}

@end
