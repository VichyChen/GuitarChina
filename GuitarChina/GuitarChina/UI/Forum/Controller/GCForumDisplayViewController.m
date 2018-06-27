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
#import "GCNewPostThreadViewController.h"
#import "GCNewPostThreadViewController.h"
#import "GCThreadDetailViewController.h"
#import "GCNavigationController.h"
#import "GCLoginViewController.h"
#import "GCProfileViewController.h"

@interface GCForumDisplayViewController ()

@property (nonatomic, assign) BOOL loaded;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) GCTableViewKit *tableViewKit;

@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) NSMutableArray *rowHeightArray;

@end

@implementation GCForumDisplayViewController

- (instancetype)init {
    if (self = [super init]) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.loaded = false;
    self.uid = 0;
    self.pageIndex = 1;
    self.pageSize = 20;

    self.navigationItem.rightBarButtonItem = [UIView createCustomBarButtonItem:@"icon_edit"
                                                                   normalColor:[UIColor whiteColor]
                                                              highlightedColor:[GCColor grayColor4]
                                                                        target:self
                                                                        action:@selector(newThreadAction)];

    [self configureView];
    [self configureNotification];
    
    [self.tableView headerBeginRefresh];
    
    [GCStatistics event:GCStatisticsEventForumDisplay extra:@{ @"forumName" : self.title}];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kGCNotificationLoginSuccess object:nil];
}

#pragma mark - Notification

- (void)configureNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAction) name:kGCNotificationLoginSuccess object:nil];
}

#pragma mark - Private Methods

- (void)configureView {
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self.view addSubview:self.tableView];
}

#pragma mark - Event Response

- (void)refreshAction {
    self.loaded = false;
    APP.tabBarController.selectedIndex = 1;
    [self.tableView headerBeginRefresh];
}

- (void)newThreadAction {
    if (self.loaded == YES) {
        if ([self.uid isEqualToString:@"0"]) {
            GCLoginViewController *loginViewController = [[GCLoginViewController alloc] initWithNibName:@"GCLoginViewController" bundle:nil];
            GCNavigationController *navigationController = [[GCNavigationController alloc] initWithRootViewController:loginViewController];
            [self presentViewController:navigationController animated:YES completion:nil];
        } else {
            GCNewPostThreadViewController *controller = [[GCNewPostThreadViewController alloc] init];
            controller.fid = self.fid;
            controller.formhash = self.formhash;
            if (self.threadTypes.count > 0) {
                if ([self.threadTypes isKindOfClass:[NSArray class]]) {
                    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
                    for (int i = 0; i < self.threadTypes.count; i++) {
                        [dictionary setObject:((NSArray *)self.threadTypes)[i] forKey:[NSString stringWithFormat:@"%d", i]];
                    }
                    controller.threadTypes = dictionary;
                } else {
                    controller.threadTypes = self.threadTypes;
                }
            }
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
}

#pragma mark - HTTP

- (void)getForumDisplay {
    @weakify(self);
    [GCNetworkManager getForumDisplayWithForumID:self.fid pageIndex:self.pageIndex pageSize:self.pageSize success:^(GCForumDisplayArray *array) {
        @strongify(self);
        self.loaded = true;
        self.uid = array.member_uid;
        self.formhash = array.formhash;
        self.threadTypes = array.threadTypes;
        
        if (self.pageIndex == 1) {
            self.data = array.data;
            self.rowHeightArray = [NSMutableArray array];
            for (GCForumThreadModel *model in self.data) {
                [self.rowHeightArray addObject: [NSNumber numberWithFloat:[GCForumDisplayCell getCellHeightWithModel:model]]];
            }
            [self.tableView headerEndRefresh];
        } else {
            for (GCForumThreadModel *model in array.data) {
                [self.data addObject:model];
                [self.rowHeightArray addObject: [NSNumber numberWithFloat:[GCForumDisplayCell getCellHeightWithModel:model]]];
            }
            [self.tableView footerEndRefresh];
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        @strongify(self);
        [self.tableView headerEndRefresh];
        [self.tableView footerEndRefresh];
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"No Network Connection", nil)];
    }];
}

#pragma mark - Getters

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.frame = CGRectMake(0, kNavigatioinBarHeight, ScreenWidth, ScreenHeight - kNavigatioinBarHeight);
        _tableView.separatorLeftInset = 0;
//        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(13, 0, ScreenWidth, 44)];
//        label.font = [UIFont systemFontOfSize:15];
//        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] init];
//        [string appendAttributedString:[[NSAttributedString alloc] initWithString:@"XXX"
//                                                                       attributes:
//                                         @{NSFontAttributeName:[UIFont systemFontOfSize:12.f],
//                                           (id)kCTForegroundColorAttributeName:(id)[UIColor redColor].CGColor,
//                                           NSBackgroundColorAttributeName:[UIColor blueColor]}]];
//        [string appendAttributedString:[[NSAttributedString alloc] initWithString:self.threads attributes:@{}]];
//        [string appendAttributedString:[[NSAttributedString alloc] initWithString:@" | 回复:" attributes:@{}]];
//        [string appendAttributedString:[[NSAttributedString alloc] initWithString:self.posts attributes:@{}]];
//        [string appendAttributedString:[[NSAttributedString alloc] initWithString:@" | 今日:" attributes:@{}]];
//        [string appendAttributedString:[[NSAttributedString alloc] initWithString:self.todayposts attributes:@{}]];
//        label.attributedText = string;
//        [headerView addSubview:label];
//        _tableView.tableHeaderView = headerView;

        [_tableView initFooterView];
        
        self.tableViewKit = [[GCTableViewKit alloc] initWithCellType:ConfigureCellTypeClass cellIdentifier:@"GCForumDisplayCell"];
        @weakify(self);
        [self.tableViewKit setGetItemsBlock:^NSArray *{
            @strongify(self);
            return self.data;
        }];
        self.tableViewKit.cellForRowBlock = ^(NSIndexPath *indexPath, id item, UITableViewCell *cell) {
            @strongify(self);
            GCForumDisplayCell *forumDisplayCell = (GCForumDisplayCell *)cell;
            GCForumThreadModel *forumThreadModel = (GCForumThreadModel *)item;
            forumDisplayCell.model = forumThreadModel;
            forumDisplayCell.avatarImageViewBlock = ^{
                @strongify(self);
                GCProfileViewController *controller = [[GCProfileViewController alloc] init];
                controller.uid = forumThreadModel.authorid;
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
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

            GCThreadDetailViewController *controller = [[GCThreadDetailViewController alloc] init];
            GCForumThreadModel *model = [self.data objectAtIndex:indexPath.row];
            controller.tid = model.tid;
            [self.navigationController pushViewController:controller animated:YES];
        };
        [self.tableViewKit configureTableView:_tableView];
        
        [_tableView setHeaderRefreshBlock:^{
            @strongify(self);
            self.pageIndex = 1;
            [self getForumDisplay];
        }];
        [_tableView setFooterRefreshBlock:^{
            @strongify(self);
            self.pageIndex++;
            [self getForumDisplay];
        }];
    }
    return _tableView;
}

@end
