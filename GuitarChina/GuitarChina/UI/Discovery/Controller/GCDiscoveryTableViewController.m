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
#import "GCHTMLParse.h"
#import "GCForumDisplayViewController.h"
#import "GCSearchViewController.h"
#import "GCProfileViewController.h"

@interface GCDiscoveryTableViewController () <UITableViewDataSource, UITableViewDelegate>

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
    
    [self.tableView headerBeginRefresh];
}

- (void)refresh {
    [self.tableView headerBeginRefresh];
}

#pragma mark - Private Methods

- (void)configureView {    
    [self.view addSubview:self.tableView];
}

#pragma mark - HTTP

- (void)getDiscovery {
    void (^successBlock)(NSData *htmlData) = ^(NSData *htmlData) {
        GCGuideThreadArray *array = [GCHTMLParse parseGuideThread:htmlData];
        
        if (self.pageIndex == 1) {
            self.data = array.data;
            self.rowHeightArray = [NSMutableArray array];
            for (GCGuideThreadModel *model in self.data) {
                [self.rowHeightArray addObject: [NSNumber numberWithFloat:[GCDiscoveryCell getCellHeightWithModel:model]]];
            }

#if FREEVERSION
            /*
            //ad
            if (self.discoveryTableViewType != GCDiscoveryTableViewTypeDigest) {
                GDTNativeExpressAdView *adView1 = [APP.nativeExpressAdManagerArray[0] getAd:(100 * (self.discoveryTableViewType + 1)) + 1];
                int index1 = (int)(8 + (arc4random() % (15 - 8 + 1)));
                if (adView1 && self.data.count > index1) {
                    [self.data insertObject:adView1 atIndex:index1];
                    [self.rowHeightArray insertObject:[NSNumber numberWithFloat:0] atIndex:index1];
                }
                
                GDTNativeExpressAdView *adView2 = [APP.nativeExpressAdManagerArray[0] getAd:(100 * (self.discoveryTableViewType + 1)) + 2];
                int index2 = (int)(25 + (arc4random() % (35 - 25 + 1)));
                if (adView2 && self.data.count > index2) {
                    [self.data insertObject:adView2 atIndex:index2];
                    [self.rowHeightArray insertObject:[NSNumber numberWithFloat:0] atIndex:index2];
                }
            }
             */
#endif

        }
        else {
            for (GCGuideThreadModel *model in array.data) {
                [self.data addObject:model];
                [self.rowHeightArray addObject: [NSNumber numberWithFloat:[GCDiscoveryCell getCellHeightWithModel:model]]];
            }
        }
        
        if (array.data.count < 40) {
            [self.tableView noticeNoMoreData];
        }
        
        [self.tableView reloadData];
        [self.tableView headerEndRefresh];
        [self.tableView footerEndRefresh];

        [GCStatistics event:GCStatisticsEventDiscovery extra:@{ @"index" : [NSString stringWithFormat:@"%ld", self.discoveryTableViewType]}];
    };
    void (^failureBlock)() = ^{
        [SVProgressHUD showErrorWithStatus:@"没有网络连接！"];
        [self.tableView headerEndRefresh];
    };
    
    switch (self.discoveryTableViewType) {
        case GCDiscoveryTableViewTypeNew:
        {
            [GCNetworkManager getGuideNewWithPageIndex:self.pageIndex success:^(NSData *htmlData) {
                successBlock(htmlData);
            } failure:^(NSError *error) {
                failureBlock();
            }];
            break;
        }
            
        case GCDiscoveryTableViewTypeNewThread:
        {
            [GCNetworkManager getGuideNewThreadWithPageIndex:self.pageIndex success:^(NSData *htmlData) {
                successBlock(htmlData);
            } failure:^(NSError *error) {
                failureBlock();
            }];
            break;
        }
            
        case GCDiscoveryTableViewTypeHot:
        {
            [GCNetworkManager getGuideHotWithPageIndex:self.pageIndex success:^(NSData *htmlData) {
                successBlock(htmlData);
            } failure:^(NSError *error) {
                failureBlock();
            }];
            break;
        }
            
        case GCDiscoveryTableViewTypeDigest:
        {
            [GCNetworkManager getGuideDigestWithPageIndex:self.pageIndex success:^(NSData *htmlData) {
                successBlock(htmlData);
            } failure:^(NSError *error) {
                failureBlock();
            }];
            break;
        }
    }
}

#pragma mark - Getters

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.data[indexPath.row] isKindOfClass:[UIView class]]) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        if (!cell) {
            [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
            cell.clipsToBounds = YES;
        }
        for (int i = 1; i <= 4; i++) {
            UIView *subView = (UIView *)[cell.contentView viewWithTag:(100 * (self.discoveryTableViewType + 1)) + i];
            if ([subView superview]) {
                [subView removeFromSuperview];
            }
        }
        [cell.contentView addSubview:self.data[indexPath.row]];

        return cell;
    }
    else {
        GCDiscoveryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GCDiscoveryCell"];
        if (!cell) {
            [tableView registerClass:[GCDiscoveryCell class] forCellReuseIdentifier:@"GCDiscoveryCell"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"GCDiscoveryCell"];
        }
        GCGuideThreadModel *model = (GCGuideThreadModel *)self.data[indexPath.row];
        cell.model = model;
        @weakify(self);
        cell.forumButtonBlock = ^{
            @strongify(self);
            GCForumDisplayViewController *controller = [[GCForumDisplayViewController alloc] init];
            controller.title = model.forum;
            controller.fid = model.fid;
            [self.navigationController pushViewController:controller animated:YES];
        };
        cell.avatarImageViewBlock = ^{
            @strongify(self);
            GCProfileViewController *controller = [[GCProfileViewController alloc] init];
            controller.uid = model.authorid;
            [self.navigationController pushViewController:controller animated:YES];
        };

        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.data[indexPath.row] isKindOfClass:[UIView class]]) {
        if (((GDTNativeExpressAdView *)self.data[indexPath.row]).isReady) {
            return ((GDTNativeExpressAdView *)self.data[indexPath.row]).frame.size.height;
        }
        else {
            return 0;
        }
    }
    else {
        NSNumber *height = [self.rowHeightArray objectAtIndex:indexPath.row];
        return (CGFloat)[height floatValue];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GCThreadDetailViewController *controller = [[GCThreadDetailViewController alloc] init];
    GCGuideThreadModel *model = [self.data objectAtIndex:indexPath.row];
    controller.tid = model.tid;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - Getters

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigatioinBarHeight - 40 - kTabBarHeight);
        _tableView.separatorHorizontalInset = UIEdgeInsetsMake(0, kMargin, 0, kMargin);
        [_tableView initFooterView];
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        self.tableViewKit = [[GCTableViewKit alloc] initWithCellType:ConfigureCellTypeClass cellIdentifier:@"GCDiscoveryCell"];
        @weakify(self);
//        [self.tableViewKit setGetItemsBlock:^NSArray *{
//            @strongify(self);
//            return self.data;
//        }];
//        self.tableViewKit.cellForRowBlock = ^(NSIndexPath *indexPath, id item, UITableViewCell *cell) {
//            @strongify(self);
//            GCDiscoveryCell *discoveryCell = (GCDiscoveryCell *)cell;
//            GCGuideThreadModel *model = (GCGuideThreadModel *)item;
//            discoveryCell.model = model;
//            discoveryCell.forumButtonBlock = ^{
//                @strongify(self);
//                GCForumDisplayViewController *controller = [[GCForumDisplayViewController alloc] init];
//                controller.title = model.forum;
//                controller.fid = model.fid;
//                [self.navigationController pushViewController:controller animated:YES];
//            };
//            discoveryCell.avatarImageViewBlock = ^{
//                @strongify(self);
//                GCProfileViewController *controller = [[GCProfileViewController alloc] init];
//                controller.uid = model.authorid;
//                [self.navigationController pushViewController:controller animated:YES];
//            };
//        };
//        self.tableViewKit.heightForRowBlock = ^(NSIndexPath *indexPath, id item) {
//            @strongify(self);
//            NSNumber *height = [self.rowHeightArray objectAtIndex:indexPath.row];
//            return (CGFloat)[height floatValue];
//        };
//        self.tableViewKit.didSelectCellBlock = ^(NSIndexPath *indexPath, id item) {
//            @strongify(self);
//            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
//
//            GCThreadDetailViewController *controller = [[GCThreadDetailViewController alloc] init];
//            GCGuideThreadModel *model = [self.data objectAtIndex:indexPath.row];
//            controller.tid = model.tid;
//            [self.navigationController pushViewController:controller animated:YES];
//        };
//        [self.tableViewKit configureTableView:_tableView];
        
        [_tableView setHeaderRefreshBlock:^{
            @strongify(self);
            self.pageIndex = 1;
            [self.tableView resetNoMoreData];
            [self getDiscovery];
            
#if FREEVERSION
            /*
            if (self.discoveryTableViewType != GCDiscoveryTableViewTypeDigest) {
                [APP.nativeExpressAdManagerArray[0] removeAds:@[@((100 * (self.discoveryTableViewType + 1)) + 1),
                                                                @((100 * (self.discoveryTableViewType + 1)) + 2),]];
            }
             */
#endif

        }];
        [_tableView setFooterRefreshBlock:^{
            @strongify(self);
            self.pageIndex++;
            [self getDiscovery];
        }];
    }
    return _tableView;
}

@end
