//
//  GCNewsRecommendViewController.m
//  GuitarChina
//
//  Created by mac on 2017/7/7.
//  Copyright © 2017年 陈大捷. All rights reserved.
//

#import "GCNewsRecommendViewController.h"
#import "GCNewsDetailViewController.h"
#import "GCNewsRecommendCell.h"
#import "GCNewsRecommendCarouselCell.h"

@interface GCNewsRecommendViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) GCTableViewKit *tableViewKit;

@property (nonatomic, strong) GCNewsRecommendModel *model;
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) NSMutableDictionary *rowHeightDictionary;

@end

@implementation GCNewsRecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureView];
}

- (void)configureView {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.view addSubview:self.tableView];
}

- (void)beginRefresh {
    [self.tableView headerBeginRefresh];
}

- (void)endRefresh {
    [self.tableView headerEndRefresh];
}

- (void)refresh:(GCNewsRecommendModel *)model {
    self.model = model;
    
    self.rowHeightDictionary = [NSMutableDictionary dictionary];
    for (int i = 0; i < self.model.moduleArray.count; i++) {
        GCNewsModuleModel *moduleModel = (GCNewsModuleModel *)self.model.moduleArray[i];
        NSMutableArray *heightArray = [NSMutableArray array];
        for (int j = 0; j < moduleModel.postArray.count; j++) {
            [heightArray addObject: [NSNumber numberWithFloat:[GCNewsRecommendCell getCellHeightWithModel:moduleModel.postArray[j] index:j]]];
        }
        [self.rowHeightDictionary setObject:heightArray forKey:[NSNumber numberWithInt:i]];
    }

    [self.tableView reloadData];
    [self.tableView headerEndRefresh];
}

#pragma mark - Getters

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigatioinBarHeight - kTabBarHeight) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor whiteColor];
        [_tableView initHeaderView];
        [_tableView initFooterView];
        _tableView.separatorHorizontalInset = UIEdgeInsetsMake(0, kMargin, 0, kMargin);

        @weakify(self);
        [_tableView setHeaderRefreshBlock:^{
            @strongify(self);
            if (self.refreshBlock) {
                self.refreshBlock();
            }
        }];
        
        self.tableViewKit = [[GCTableViewKit alloc] initWithSystem];
        self.tableViewKit.numberOfSectionsInTableViewBlock = ^NSInteger{
            @strongify(self);
            if (self.model) {
                return 1 + self.model.moduleArray.count;
            }
            else {
                return 0;
            }
        };
        self.tableViewKit.numberOfRowsInSectionBlock = ^NSInteger(NSInteger section) {
            @strongify(self);
            if (section == 0) {
                return 1;
            }
            else {
                GCNewsModuleModel *model = self.model.moduleArray[section - 1];
                return model.postArray.count;
            }
        };
        self.tableViewKit.cellForRowAtIndexPathBlock = ^UITableViewCell*(NSIndexPath *indexPath) {
            @strongify(self);
            if (indexPath.section == 0) {
                GCNewsRecommendCarouselCell *newsRecommendCarouselCell = [self.tableView dequeueReusableCellWithIdentifier:@"GCNewsRecommendCarouselCell"];
                if (!newsRecommendCarouselCell) {
                    newsRecommendCarouselCell = [[GCNewsRecommendCarouselCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GCNewsRecommendCarouselCell"];
                }
                NSArray *carouselArray = self.model.carouselArray;
                
                NSMutableArray *imgArray = [NSMutableArray array];
                NSMutableArray *titleArray = [NSMutableArray array];
                for (GCNewsModulePostModel *model in carouselArray) {
                    [imgArray addObject:model.img];
                    [titleArray addObject:model.content];
                }
                newsRecommendCarouselCell.imgScrollView.imageURLStringsGroup = imgArray;
                newsRecommendCarouselCell.imgScrollView.titlesGroup = titleArray;
                newsRecommendCarouselCell.didSelectItemBlock = ^(NSInteger index) {
                    @strongify(self);
                    GCNewsDetailViewController *controller = [[GCNewsDetailViewController alloc] init];
                    controller.pid = ((GCNewsModulePostModel *)carouselArray[index]).pid;
                    [self.navigationController pushViewController:controller animated:YES];
                };
                
                return newsRecommendCarouselCell;
            }
            else {
                GCNewsRecommendCell *newsRecommendCell = [self.tableView dequeueReusableCellWithIdentifier:@"GCNewsRecommendCell"];
                if (!newsRecommendCell) {
                    newsRecommendCell = [[GCNewsRecommendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GCNewsRecommendCell"];
                }
                GCNewsModuleModel *model = self.model.moduleArray[indexPath.section - 1];
                GCNewsModulePostModel *postModel = model.postArray[indexPath.row];
                [newsRecommendCell setModel:postModel index:indexPath.row];
                
                return newsRecommendCell;
            }
        };
        self.tableViewKit.heightForRowAtIndexPathBlock = ^CGFloat(NSIndexPath *indexPath) {
            @strongify(self);
            if (indexPath.section == 0) {
                return kScreenWidth * 0.6;
            }
            else {
                NSArray *heightArray = [self.rowHeightDictionary objectForKey:[NSNumber numberWithInteger:indexPath.section - 1]];
                NSNumber *number = [heightArray objectAtIndex:indexPath.row];
                return number.floatValue;
            }
        };
        self.tableViewKit.viewForHeaderInSectionBlock = ^(NSInteger section) {
            @strongify(self);
            if (section == 0) {
                return [[UIView alloc] init];
            }
            else {
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
                view.backgroundColor = [UIColor whiteColor];
                
                UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
                grayView.backgroundColor = [GCColor backgroundColor];
                [view addSubview:grayView];
                
                GCNewsModuleModel *model = self.model.moduleArray[section - 1];
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, kScreenWidth, 40)];
                label.text = [NSString stringWithFormat:@"%@", model.name];
                label.font = [UIFont systemFontOfSize:16];
                label.textColor = [GCColor blueColor];
                
                [view addSubview:label];
                
                return view;
            }
        };
        self.tableViewKit.heightForHeaderInSectionBlock = ^CGFloat(NSInteger section) {
            if (section == 0) {
                return 0.01;
            }
            else {
                return 50;
            }
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
            
            if (indexPath.section == 0) {

            }
            else {
                GCNewsModuleModel *model = self.model.moduleArray[indexPath.section - 1];
                GCNewsModulePostModel *postModel = model.postArray[indexPath.row];

                GCNewsDetailViewController *controller = [[GCNewsDetailViewController alloc] init];
                controller.pid = postModel.pid;
                [self.navigationController pushViewController:controller animated:YES];
            }
        };
        [self.tableViewKit configureTableView:_tableView];
    }
    return _tableView;
}


@end
