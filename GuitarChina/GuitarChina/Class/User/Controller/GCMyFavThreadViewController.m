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

@interface GCMyFavThreadViewController ()

@property (nonatomic, strong) NSMutableArray *data;

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
    self.view.backgroundColor = [UIColor whiteColor];
    [self configureBlock];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"GCMyFavThreadCell";
    GCMyFavThreadCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[GCMyFavThreadCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.model = [self.data objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *height = [self.rowHeightArray objectAtIndex:indexPath.row];
    return [height floatValue];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GCThreadDetailViewController *controller = [[GCThreadDetailViewController alloc] init];
    GCMyFavThreadModel *model = [self.data objectAtIndex:indexPath.row];
    controller.tid = model.idfield;
    [self.navigationController pushViewController:controller animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Private Methods

- (void)configureBlock {
    @weakify(self);
    self.refreshBlock = ^{
        @strongify(self);
        [GCNetworkManager getMyFavThreadSuccess:^(GCMyFavThreadArray *array) {
            self.data = array.data;
            [self.rowHeightArray removeAllObjects];
            for (GCMyFavThreadModel *model in self.data) {
                [self.rowHeightArray addObject: [NSNumber numberWithFloat:[GCMyFavThreadCell getCellHeightWithModel:model]]];
            }
            [self.tableView reloadData];
            [self endRefresh];
        } failure:^(NSError *error) {
            [self endRefresh];
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"No Network Connection", nil)];
        }];
    };
}

@end
