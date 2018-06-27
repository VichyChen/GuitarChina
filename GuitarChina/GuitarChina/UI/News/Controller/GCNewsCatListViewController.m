//
//  GCNewsCatListViewController.m
//  GuitarChina
//
//  Created by mac on 2017/7/7.
//  Copyright © 2017年 陈大捷. All rights reserved.
//

#import "GCNewsCatListViewController.h"
#import "GCNewsListCell.h"
#import "GCNewsModel.h"
#import "GCNewsDetailViewController.h"

@interface GCNewsCatListViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) GCTableViewKit *tableViewKit;

@property (nonatomic, strong) GCNewsArray *model;
@property (nonatomic, strong) NSMutableArray *rowHeightArray;
@property (nonatomic, assign) NSInteger pageIndex;

@end

@implementation GCNewsCatListViewController

- (instancetype)init {
    if (self = [super init]) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self configureView];
    
    [self.tableView headerBeginRefresh];
}

- (void)configureView {
    [self.view addSubview:self.tableView];
}

#pragma mark - HTTP

- (void)getNews {
    [GCNetworkManager getNewsWithID:self.catID pageIndex:self.pageIndex success:^(NSData *htmlData) {
        GCNewsArray *newsArray = [GCHTMLParse parseNewsList:htmlData];
        if (self.pageIndex == 1) {
            self.model = newsArray;
            self.rowHeightArray = [NSMutableArray array];
            for (GCNewsModel *model in self.model.newsArray) {
                [self.rowHeightArray addObject: [NSNumber numberWithFloat:[GCNewsListCell getCellHeightWithModel:model]]];
            }
            [self.tableView headerEndRefresh];
        } else {
            for (GCNewsModel *model in newsArray.newsArray) {
                [self.model.newsArray addObject:model];
                [self.rowHeightArray addObject: [NSNumber numberWithFloat:[GCNewsListCell getCellHeightWithModel:model]]];
            }
            [self.tableView footerEndRefresh];
        }
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - Getters

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - kNavigatioinBarHeight);
        _tableView.separatorLeftInset = 13;
        [_tableView initFooterView];
        
        self.tableViewKit = [[GCTableViewKit alloc] initWithCellType:ConfigureCellTypeClass cellIdentifier:@"GCNewsListCell"];
        @weakify(self);
        [self.tableViewKit setGetItemsBlock:^NSArray *{
            @strongify(self);
            return self.model.newsArray;
        }];
        self.tableViewKit.cellForRowBlock = ^(NSIndexPath *indexPath, id item, UITableViewCell *cell) {
            GCNewsListCell *newsCell = (GCNewsListCell *)cell;
            GCNewsModel *model = (GCNewsModel *)item;
            newsCell.model = model;
        };
        self.tableViewKit.heightForRowBlock = ^CGFloat(NSIndexPath *indexPath, id item) {
            @strongify(self);
            NSNumber *height = [self.rowHeightArray objectAtIndex:indexPath.row];
            return (CGFloat)[height floatValue];
        };
        self.tableViewKit.didSelectCellBlock = ^(NSIndexPath *indexPath, id item) {
            @strongify(self);
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        
            GCNewsModel *model = (GCNewsModel *)item;

            GCNewsDetailViewController *controller = [[GCNewsDetailViewController alloc] init];
            controller.pid = model.pid;
            [self.navigationController pushViewController:controller animated:YES];
        };
        [self.tableViewKit configureTableView:_tableView];
        
        [_tableView setHeaderRefreshBlock:^{
            @strongify(self);
            self.pageIndex = 1;
            [self getNews];
        }];

//        [_tableView setFooterRefreshBlock:^{
//            @strongify(self);
//            self.pageIndex++;
//            [self getNews];
//        }];
    }
    return _tableView;
}

@end
