//
//  GCProfileViewController.m
//  GuitarChina
//
//  Created by mac on 16/12/30.
//  Copyright © 2016年 陈大捷. All rights reserved.
//

#import "GCProfileViewController.h"
#import "GCProfileModel.h"
#import "GCProfileCell.h"

@interface GCProfileViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) GCTableViewKit *tableViewKit;

@property (nonatomic, strong) NSArray *array;

@property (nonatomic, strong) GCProfileModel *model;

@end

@implementation GCProfileViewController

- (instancetype)init {
    if (self = [super init]) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"个人资料";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self configureView];
    
    [self getProfile];
}

- (void)dealloc {
    NSLog(@"GCProfileViewController dealloc");
}

#pragma mark - Private Methods

- (void)configureView {
    [self.view addSubview:self.tableView];
}

#pragma mark - HTTP

- (void)getProfile {
    [GCNetworkManager getProfileWithUID:self.uid success:^(NSData *htmlData) {
        self.model = [GCHTMLParse parseProfile:htmlData];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"没有网络连接！"];
    }];
}

#pragma mark - Getters

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigatioinBarHeight) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [GCColor backgroundColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorLeftInset = 0;
        [_tableView initHeaderView];

        self.tableViewKit = [[GCTableViewKit alloc] initWithSystem];
        @weakify(self);
        self.tableViewKit.numberOfSectionsInTableViewBlock = ^NSInteger{
            @strongify(self);
            if (self.model) {
                return self.array.count;
            } else {
                return 0;
            }
        };
        self.tableViewKit.numberOfRowsInSectionBlock = ^NSInteger(NSInteger section) {
            @strongify(self);
            NSArray *array = self.array[section];
            return array.count;
        };
        self.tableViewKit.cellForRowAtIndexPathBlock = ^(NSIndexPath *indexPath) {
            @strongify(self);
            GCProfileCell *cell = [[GCProfileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GCProfileCell"];
            
            NSArray *array = self.array[indexPath.section];
            NSDictionary *dictionary = array[indexPath.row];
            NSInteger type = [dictionary[@"type"] integerValue];
            cell.selectionStyle = [dictionary[@"enable"] boolValue] == YES ? UITableViewCellSelectionStyleDefault : UITableViewCellSelectionStyleNone;
            switch (type) {
                case 0:
                    cell.state = GCProfileCellStateHeader;
                    [cell.avatorImageView sd_setImageWithURL:[NSURL URLWithString:GCNetworkAPI_URL_MiddleAvatarImage(self.uid)] placeholderImage:DefaultAvator];
                    cell.titleLabel.text = dictionary[@"username"];
                    cell.descriptionLabel.text = dictionary[@"userGroup"];
                    
                    break;
                    
                case 1:
                    cell.state = GCProfileCellStateTitleArrow;
                    cell.titleLabel.text = dictionary[@"title"];
                    
                    break;
                    
                case 2:
                    cell.state = GCProfileCellStateTitleValue;
                    cell.titleLabel.text = dictionary[@"title"];
                    cell.valueLabel.text = dictionary[@"value"];

                    break;
            }
            
            return cell;
        };
        self.tableViewKit.heightForRowAtIndexPathBlock = ^CGFloat(NSIndexPath *indexPath) {
            @strongify(self);
            NSArray *array = self.array[indexPath.section];
            NSDictionary *dictionary = array[indexPath.row];
            return [dictionary[@"rowHeight"] floatValue];
        };
        self.tableViewKit.viewForHeaderInSectionBlock = ^(NSInteger section) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 13)];
            return view;
        };
        self.tableViewKit.heightForHeaderInSectionBlock = ^CGFloat(NSInteger section) {
            return 13.0f;
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

            NSArray *array = self.array[indexPath.section];
            NSDictionary *dictionary = array[indexPath.row];
            void (^block)(void) = dictionary[@"block"];
            if (block) {
                block();
            }
        };
        [self.tableViewKit configureTableView:_tableView];
    }
    return _tableView;
}

- (NSArray *)array {
    NSArray *section0 = @[@{@"type" : @0,
                            @"image" : @"",
                            @"username" : self.model.username ? self.model.username : @"",
                            @"userGroup" : self.model.userGroup ? self.model.userGroup : @"",
                            @"enable" : @NO,
                            @"rowHeight" : @80,
                            @"block" : ^{}}];
    NSArray *section1 = @[@{@"type" : @2,
                            @"title" : self.model.threadCount ? self.model.threadCount : @"",
                            @"value" : @"",
                            @"enable" : @NO,
                            @"rowHeight" : @44,
                            @"block" : ^{}},
                          @{@"type" : @2,
                            @"title" : self.model.replyCount ? self.model.replyCount : @"",
                            @"value" : @"",
                            @"enable" : @NO,
                            @"rowHeight" : @44,
                            @"block" : ^{}}];
    NSMutableArray *section2 = [NSMutableArray array];
    for (NSDictionary *dictionary in self.model.state) {
        [section2 addObject:@{@"type" : @2,
                              @"title" : dictionary[@"key"],
                              @"value" : dictionary[@"value"],
                              @"enable" : @NO,
                              @"rowHeight" : @44,
                              @"block" : ^{}}];
    }
    return @[section0, section1, section2];
}

@end
