//
//  GCMyPromptViewController.m
//  GuitarChina
//
//  Created by mac on 17/1/19.
//  Copyright © 2017年 陈大捷. All rights reserved.
//

#import "GCMyPromptViewController.h"
#import "GCMyPromptCell.h"
#import "GCThreadDetailViewController.h"

@interface GCMyPromptViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) GCTableViewKit *tableViewKit;

@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) NSMutableArray *rowHeightArray;

@end

@implementation GCMyPromptViewController

- (instancetype)init {
    if (self = [super init]) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"我的提醒";
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

- (void)getMyPrompt {
    @weakify(self);
    [GCNetworkManager getMyPromptSuccess:^(NSData *htmlData) {
        @strongify(self);
        
        [NSUD setInteger:0 forKey:kGCNewMyPost];
        [NSUD synchronize];
        [APP.tabBarController updateMorePromptRedCount];

        GCMyPromptArray *array = [GCHTMLParse parseMyPrompt:htmlData];
        self.data = array.data;
        
        self.rowHeightArray = [NSMutableArray array];
        for (GCMyPromptModel *model in self.data) {
            [self.rowHeightArray addObject: [NSNumber numberWithFloat:[GCMyPromptCell getCellHeightWithModel:model]]];
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
        _tableView.separatorHorizontalInset = UIEdgeInsetsMake(0, kMargin, 0, kMargin);

        self.tableViewKit = [[GCTableViewKit alloc] initWithCellType:ConfigureCellTypeClass cellIdentifier:@"GCMyPromptCell"];
        @weakify(self);
        [self.tableViewKit setGetItemsBlock:^NSArray *{
            @strongify(self);
            return self.data;
        }];
        self.tableViewKit.cellForRowBlock = ^(NSIndexPath *indexPath, id item, UITableViewCell *cell) {
            GCMyPromptCell *myPromptCell = (GCMyPromptCell *)cell;
            myPromptCell.model = item;
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
            [self getMyPrompt];
        }];
    }
    return _tableView;
}

@end
