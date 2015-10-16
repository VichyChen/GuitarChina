//
//  GCForumIndexViewController.m
//  GuitarChina
//
//  Created by 陈大捷 on 15/9/4.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCForumIndexViewController.h"
#import "RESideMenu.h"
#import "GCForumDisplayViewController.h"
#import "GCForumIndexCell.h"

@interface GCForumIndexViewController ()

@property (nonatomic, strong) NSMutableArray *data;

@end

@implementation GCForumIndexViewController

#pragma mark - life cycle

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.rowHeightDictionary = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    self.hiddenNavigationBarWhenScrollToBottom = NO;
    self.title = NSLocalizedString(@"Forum", nil);
    self.navigationItem.leftBarButtonItem = [UIView createCustomBarButtonItem:@"icon_hamberger"
                                                                  normalColor:[UIColor FontColor]
                                                             highlightedColor:[UIColor redColor]
                                                                       target:self
                                                                       action:@selector(presentLeftMenuViewController:)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureBlock];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.data count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    GCForumGroupModel *model = [self.data objectAtIndex:section];
    return model.name;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    GCForumGroupModel *model = [self.data objectAtIndex:section];
    return [model.forums count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"GCForumIndexCell";
    GCForumIndexCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[GCForumIndexCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    GCForumGroupModel *forumGroupModel = [self.data objectAtIndex:indexPath.section];
    GCForumModel *forumModel = [forumGroupModel.forums objectAtIndex:indexPath.row];
    cell.model = forumModel;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *heightArray = [self.rowHeightDictionary objectForKey:[NSNumber numberWithInteger:indexPath.section]];
    NSNumber *number = [heightArray objectAtIndex:indexPath.row];
    return [number floatValue];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GCForumDisplayViewController *controller = [[GCForumDisplayViewController alloc] init];
    GCForumGroupModel *forumGroupModel = [self.data objectAtIndex:indexPath.section];
    GCForumModel *forumModel = [forumGroupModel.forums objectAtIndex:indexPath.row];
    controller.title = forumModel.name;
    controller.fid = forumModel.fid;
    [self.navigationController pushViewController:controller animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//#pragma mark - UIScrollViewDelegate
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    [super scrollViewDidScroll:scrollView];
//
//    if (scrollView == self.tableView)
//    {
//        CGFloat sectionHeaderHeight = 120;
//        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
//            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
//        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
//            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
//        }
//    }
//}

#pragma mark - Private Methods

- (void)configureBlock {
    @weakify(self);
    self.refreshBlock = ^{
        @strongify(self);
        [[GCNetworkManager manager] getForumIndexSuccess:^(GCForumIndexArray *array) {
            self.data = array.data;
            [self.rowHeightDictionary removeAllObjects];
            for (int i = 0; i < self.data.count; i++) {
                GCForumGroupModel *model = (GCForumGroupModel *)self.data[i];
                NSMutableArray *heightArray = [NSMutableArray array];
                for (GCForumModel *forumModel in model.forums) {
                    [heightArray addObject: [NSNumber numberWithFloat:[GCForumIndexCell getCellHeightWithModel:forumModel]]];
                }
                [self.rowHeightDictionary setObject:heightArray forKey:[NSNumber numberWithInt:i]];
            }
            
            [self.tableView reloadData];
            [self endRefresh];
        } failure:^(NSError *error) {
            
        }];
    };
}

@end
