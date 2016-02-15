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

@property (nonatomic, strong) NSMutableArray *data;

@end

@implementation GCForumIndexViewController

#pragma mark - life cycle

- (void)loadView {
    [super loadView];
    
    self.hiddenNavigationBarWhenScrollToBottom = NO;
    
//    self.autoBeginRefresh = NO;
    self.title = NSLocalizedString(@"Forum", nil);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureBlock];
    
//    self.data = [[NSUserDefaults standardUserDefaults] objectForKey:kGCFORUMINDEXDICTIONARY];
//    [self.tableView reloadData];
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 35)];
    view.backgroundColor = [UIColor GCBackgroundColor];
    GCForumGroupModel *model = [self.data objectAtIndex:section];
    UILabel *label = [UIView createLabel:CGRectMake(15, 0, ScreenWidth, 35) text:[NSString stringWithFormat:@"%@", model.name] font:[UIFont boldSystemFontOfSize:16] textColor:[UIColor GCBlueColor]];
    [view addSubview:label];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *heightArray = [self.rowHeightDictionary objectForKey:[NSNumber numberWithInteger:indexPath.section]];
    NSNumber *number = [heightArray objectAtIndex:indexPath.row];
    return [number floatValue];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GCForumDisplayViewController *controller = [[GCForumDisplayViewController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    GCForumGroupModel *forumGroupModel = [self.data objectAtIndex:indexPath.section];
    GCForumModel *forumModel = [forumGroupModel.forums objectAtIndex:indexPath.row];
    controller.title = forumModel.name;
    controller.fid = forumModel.fid;
    [self.navigationController pushViewController:controller animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Private Methods

- (void)configureBlock {
    @weakify(self);
    self.refreshBlock = ^{
        @strongify(self);
        [[GCNetworkManager manager] getForumIndexSuccess:^(GCForumIndexArray *array) {
            self.data = array.data;
//            [[NSUserDefaults standardUserDefaults] setObject:self.data forKey:kGCFORUMINDEXDICTIONARY];
//            [[NSUserDefaults standardUserDefaults] synchronize];
            
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
            [self endRefresh];
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"No network connection!", nil)];
        }];
    };
}

@end
