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

@property (nonatomic, strong) NSMutableArray *data;

@end

@implementation GCMyThreadViewController


#pragma mark - life cycle

- (instancetype)init {
    if (self = [super init]) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    self.title = NSLocalizedString(@"My Theme", nil);
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureBlock];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"GCUserThreadCell";
    GCMyThreadCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[GCMyThreadCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
    GCMyThreadModel *model = [self.data objectAtIndex:indexPath.row];
    controller.tid = model.tid;
    [self.navigationController pushViewController:controller animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Private Methods

- (void)configureBlock {
    @weakify(self);
    self.refreshBlock = ^{
        @strongify(self);
        [GCNetworkManager getMyThreadSuccess:^(GCMyThreadArray *array) {
            self.data = array.data;
            [self.rowHeightArray removeAllObjects];
            for (GCMyThreadModel *model in self.data) {
                [self.rowHeightArray addObject: [NSNumber numberWithFloat:[GCMyThreadCell getCellHeightWithModel:model]]];
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
