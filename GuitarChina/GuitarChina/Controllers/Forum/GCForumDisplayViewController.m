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
#import "GCThreadDetailViewController.h"

@interface GCForumDisplayViewController ()

@property (nonatomic, strong) NSMutableArray *data;

@end

@implementation GCForumDisplayViewController

#pragma mark - life cycle

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.rowHeightArray = [NSMutableArray array];
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
//    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(newThreadAction)];
//    self.navigationItem.rightBarButtonItem = barItem;
    
        self.navigationItem.rightBarButtonItem = [UIView createCustomBarButtonItem:@"icon_edit"
                                                                      normalColor:[UIColor GCFontColor]
                                                                 highlightedColor:[UIColor GCFontColor]
                                                                           target:self
                                                                           action:@selector(newThreadAction)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pageIndex = 1;
    self.pageSize = 20;

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
    static NSString *identifier = @"GCForumDisplayCell";
    GCForumDisplayCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[GCForumDisplayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    GCForumThreadModel *model = [self.data objectAtIndex:indexPath.row];
    [cell setModel:model];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *height = [self.rowHeightArray objectAtIndex:indexPath.row];
    return [height floatValue];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GCThreadDetailViewController *controller = [[GCThreadDetailViewController alloc] init];
    GCForumThreadModel *model = [self.data objectAtIndex:indexPath.row];
    controller.forumThreadModel = model;
    controller.tid = model.tid;
    [self.navigationController pushViewController:controller animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Private Methods

- (void)configureBlock {
    @weakify(self);
    self.refreshBlock = ^{
        @strongify(self);
        [[GCNetworkManager manager] getForumDisplayWithForumID:self.fid pageIndex:self.pageIndex pageSize:self.pageSize Success:^(GCForumDisplayArray *array) {
            if (self.pageIndex == 1) {
                self.data = array.data;
                [self.rowHeightArray removeAllObjects];
                for (GCForumThreadModel *model in self.data) {
                    [self.rowHeightArray addObject: [NSNumber numberWithFloat:[GCForumDisplayCell getCellHeightWithModel:model]]];
                }
                [self.tableView reloadData];
                [self endRefresh];
            } else {
                for (GCForumThreadModel *model in array.data) {
                    [self.data addObject:model];
                    [self.rowHeightArray addObject: [NSNumber numberWithFloat:[GCForumDisplayCell getCellHeightWithModel:model]]];
                }
                [self.tableView reloadData];
                [self endFetchMore];
            }
        } failure:^(NSError *error) {
            
        }];
    };
}

- (void)newThreadAction {
    GCPostThreadViewController *controller = [[GCPostThreadViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}


@end
