//
//  GCOfficialViewController.m
//  GuitarChina
//
//  Created by mac on 16/12/17.
//  Copyright © 2016年 陈大捷. All rights reserved.
//

#import "GCOfficialViewController.h"
#import "GCOfficialCell.h"
#import "GCThreadDetailViewController.h"
#import "GCWebViewController.h"

@interface GCOfficialViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) GCTableViewKit *tableViewKit;

@property (nonatomic, copy) NSArray *array;

@end

@implementation GCOfficialViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = NSLocalizedString(@"Official", nil);
    [self configureView];
}

- (void)configureView {
    [self.view addSubview:self.tableView];
}

#pragma mark - Getters

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _tableView.backgroundColor = [GCColor backgroundColor];
        _tableView.tableFooterView = [[UIView alloc] init];
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 13, 0, 0)];
        }
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:UIEdgeInsetsMake(0, 13, 0, 0)];
        }

        self.tableViewKit = [[GCTableViewKit alloc] initWithCellType:ConfigureCellTypeClass cellIdentifier:@"GCOfficialCell"];
        @weakify(self);
        self.tableViewKit.getItemsBlock = ^{
            @strongify(self);
            return self.array;
        };
        self.tableViewKit.cellForRowBlock = ^(NSIndexPath *indexPath, id item, UITableViewCell *cell) {
            GCOfficialCell *officialCell = (GCOfficialCell *)cell;
            NSDictionary *dictionary = item;
            officialCell.leftImageView.image = [UIImage imageNamed:dictionary[@"image"]];
            officialCell.titleLabel.text = dictionary[@"title"];
            officialCell.descriptionLabel.text = dictionary[@"description"];
        };
        self.tableViewKit.heightForRowBlock = ^CGFloat(NSIndexPath *indexPath, id item) {
            return 76.0f;
        };
        self.tableViewKit.didSelectCellBlock = ^(NSIndexPath *indexPath, id item) {
            @strongify(self);
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

            NSDictionary *dictionary = item;
            if ([dictionary[@"type"] isEqualToString:@"0"]) {
                GCThreadDetailViewController *controller = [[GCThreadDetailViewController alloc] init];
                controller.tid = dictionary[@"id"];
                [self.navigationController pushViewController:controller animated:YES];
            } else if ([dictionary[@"type"] isEqualToString:@"1"]) {
                GCWebViewController *controller = [[GCWebViewController alloc] init];
                controller.title = dictionary[@"title"];
                controller.urlString = dictionary[@"id"];
                [self.navigationController pushViewController:controller animated:YES];
            }
        };
        [self.tableViewKit configureTableView:_tableView];
    }
    return _tableView;
}

- (NSArray *)array {
    if (!_array) {
        _array = @[@{@"image" : @"official_guitarchina", @"title" : @"吉他中国", @"description" : @"吉他中国-华语第一吉他世界！", @"type" : @"0", @"id" : @"58664"},
                   @{@"image" : @"official_musical", @"title" : @"琴国乐器", @"description" : @"吉他中国唯一下属专业网络乐器选购平台，中国第一电声乐器在线电子商务平台！", @"type" : @"0", @"id" : @"1790525"},
                   @{@"image" : @"official_mushroom", @"title" : @"蘑菇音乐", @"description" : @"吉他中国旗下致力于现代音乐教育推广的联合机构，中国第一吉他教育在线联盟！", @"type" : @"0", @"id" : @"2040865"},
                   @{@"image" : @"official_taobao", @"title" : @"琴国淘宝", @"description" : @"吉他中国琴国乐器官方唯一淘宝店。", @"type" : @"1", @"id" : @"https://shop33023113.m.taobao.com"},
                   @{@"image" : @"official_weidian", @"title" : @"琴国微店", @"description" : @"吉他中国琴国乐器官方唯一微店。", @"type" : @"1", @"id" : @"https://weidian.com/?userid=374043907&wfr=c"},
                   @{@"image" : @"official_weibo", @"title" : @"官方微博", @"description" : @"吉他中国新浪官方微博@吉他中国，微博互动吉他平台。", @"type" : @"1", @"id" : @"http://weibo.com/84037131"}];
    }
    return _array;
}

@end
