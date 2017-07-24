//
//  GCForumIndexViewController.m
//  GuitarChina
//
//  Created by 陈大捷 on 15/9/4.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCForumIndexViewController.h"
#import "GCForumDisplayViewController.h"
#import "GCForumIndexCell.h"

@interface GCForumIndexViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) GCTableViewKit *tableViewKit;

@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) NSMutableDictionary *rowHeightDictionary;

@end

@implementation GCForumIndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Forum", nil);
    [self configureView];
    
    @weakify(self);
    [GCNetworkCache getForumIndex:^(GCForumIndexArray *array) {
        @strongify(self);
        self.data = array.data;
        //增加最近浏览分类
        //最近浏览记录
        GCForumGroupModel *forumGroupModel = [self getForumBrowseRecord:array];
        if (forumGroupModel) {
            [self.data insertObject:forumGroupModel atIndex:0];
        }
        //计算高度
        [self calculateRowHeight];
        [self.tableView reloadData];
    }];

    [self.tableView headerBeginRefresh];
    
    [GCStatistics event:GCStatisticsEventForumIndex extra:nil];
}

#pragma mark - Private Methods

- (void)configureView {
    [self.view addSubview:self.tableView];
}

- (void)calculateRowHeight {
    self.rowHeightDictionary = [NSMutableDictionary dictionary];
    for (int i = 0; i < self.data.count; i++) {
        GCForumGroupModel *model = (GCForumGroupModel *)self.data[i];
        NSMutableArray *heightArray = [NSMutableArray array];
        for (GCForumModel *forumModel in model.forums) {
            [heightArray addObject: [NSNumber numberWithFloat:[GCForumIndexCell getCellHeightWithModel:forumModel]]];
        }
        [self.rowHeightDictionary setObject:heightArray forKey:[NSNumber numberWithInt:i]];
    }
}

- (GCForumGroupModel *)getForumBrowseRecord:(GCForumIndexArray *)array {
    NSArray *browseArray = [NSUD arrayForKey:kGCForumBrowseRecord] ? [NSUD arrayForKey:kGCForumBrowseRecord] : @[];
    if (browseArray.count > 0) {
        GCForumGroupModel *forumGroupModel = [[GCForumGroupModel alloc] init];
        forumGroupModel.fid = @"0";
        forumGroupModel.name = @"最近浏览";
        forumGroupModel.forums = [NSMutableArray arrayWithArray:browseArray];
        for (GCForumGroupModel *tempForumGroupModel in array.data) {
            for (GCForumModel *tempForumModel in tempForumGroupModel.forums) {
                if ([browseArray containsObject:tempForumModel.fid]) {
                    for (int i = 0; i < browseArray.count; i++) {
                        if ([browseArray[i] isEqualToString:tempForumModel.fid]) {
                            [forumGroupModel.forums replaceObjectAtIndex:i withObject:[tempForumModel copy]];
                            break;
                        }
                    }
                }
            }
        }
        return forumGroupModel;
    } else {
        return nil;
    }
}

#pragma mark - HTTP

- (void)getForumIndex {
    [GCNetworkManager getForumIndexSuccess:^(GCForumIndexArray *array) {
        self.data = array.data;
        
        //增加最近浏览分类
        //最近浏览记录
        GCForumGroupModel *forumGroupModel = [self getForumBrowseRecord:array];
        if (forumGroupModel) {
            [self.data insertObject:forumGroupModel atIndex:0];
        }
        //计算高度
        [self calculateRowHeight];
        
        [self.tableView reloadData];
        [self.tableView headerEndRefresh];
    } failure:^(NSError *error) {
        [self.tableView headerEndRefresh];
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"No Network Connection", nil)];
    }];
}

#pragma mark - Getters

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
        @weakify(self);
        [_tableView setHeaderRefreshBlock:^{
            @strongify(self);
            [self getForumIndex];
        }];

        self.tableViewKit = [[GCTableViewKit alloc] initWithSystem];
        self.tableViewKit.numberOfSectionsInTableViewBlock = ^{
            @strongify(self);
            return (NSInteger)self.data.count;
        };
        self.tableViewKit.numberOfRowsInSectionBlock = ^(NSInteger section) {
            @strongify(self);
            GCForumGroupModel *model = [self.data objectAtIndex:section];
            return (NSInteger)model.forums.count;
        };
        self.tableViewKit.cellForRowAtIndexPathBlock = ^(NSIndexPath *indexPath) {
            @strongify(self);
            static NSString *identifier = @"GCForumIndexCell";
            GCForumIndexCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[GCForumIndexCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            GCForumGroupModel *forumGroupModel = [self.data objectAtIndex:indexPath.section];
            GCForumModel *forumModel = [forumGroupModel.forums objectAtIndex:indexPath.row];
            cell.model = forumModel;
            
            return cell;
        };
        self.tableViewKit.heightForRowAtIndexPathBlock = ^CGFloat(NSIndexPath *indexPath) {
            @strongify(self);
            NSArray *heightArray = [self.rowHeightDictionary objectForKey:[NSNumber numberWithInteger:indexPath.section]];
            NSNumber *number = [heightArray objectAtIndex:indexPath.row];
            
            return number.floatValue;
        };
        self.tableViewKit.viewForHeaderInSectionBlock = ^(NSInteger section) {
            @strongify(self);
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
            view.backgroundColor = [UIColor whiteColor];
            GCForumGroupModel *model = [self.data objectAtIndex:section];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, ScreenWidth, 40)];
            label.text = [NSString stringWithFormat:@"%@", model.name];
            label.font = [UIFont systemFontOfSize:16];
            label.textColor = [GCColor blueColor];

            [view addSubview:label];
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, ScreenWidth, 0.5)];
            lineView.backgroundColor = [GCColor separatorLineColor];
            [view addSubview:lineView];
            
            return view;
        };
        self.tableViewKit.heightForHeaderInSectionBlock = ^CGFloat(NSInteger section) {
            return 40.0f;
        };
        self.tableViewKit.viewForFooterInSectionBlock = ^(NSInteger section) {
            return [[UIView alloc] init];
        };
        self.tableViewKit.heightForFooterInSectionBlock = ^CGFloat(NSInteger section) {
            return 0.01f;
        };
        self.tableViewKit.didSelectRowAtIndexPathBlock = ^(NSIndexPath *indexPath) {
            @strongify(self);
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

            GCForumDisplayViewController *controller = [[GCForumDisplayViewController alloc] init];
            GCForumGroupModel *forumGroupModel = [self.data objectAtIndex:indexPath.section];
            GCForumModel *forumModel = [forumGroupModel.forums objectAtIndex:indexPath.row];
            controller.title = forumModel.name;
            controller.fid = forumModel.fid;
            controller.threads = forumModel.threads;
            controller.posts = forumModel.posts;
            controller.todayposts = forumModel.todayposts;
            [self.navigationController pushViewController:controller animated:YES];
            
            //记录论坛浏览记录
            NSMutableArray *array = [NSMutableArray arrayWithArray:([NSUD arrayForKey:kGCForumBrowseRecord] ? [NSUD arrayForKey:kGCForumBrowseRecord] : @[])];
            for (int i = 0; i < array.count; i++) {
                if (array[i] == forumModel.fid) {
                    //移除原有浏览记录
                    [array removeObjectAtIndex:i];
                    break;
                }
            }
            [array insertObject:forumModel.fid atIndex:0];
            array = [NSMutableArray arrayWithArray:[array subarrayWithRange:NSMakeRange(0, array.count >= 5 ? 5 : array.count)]];
            [NSUD setObject:array forKey:kGCForumBrowseRecord];
            [NSUD synchronize];
        };
        [self.tableViewKit configureTableView:_tableView];
    }
    return _tableView;
}

@end
