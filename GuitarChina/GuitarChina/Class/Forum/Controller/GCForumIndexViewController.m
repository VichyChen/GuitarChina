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
    
    self.autoBeginRefresh = YES;
    self.title = NSLocalizedString(@"Forum", nil);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureBlock];
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
    UILabel *label = [UIView createLabel:CGRectMake(15, 0, ScreenWidth, 35)
                                    text:[NSString stringWithFormat:@"%@", model.name]
                                    font:[UIFont systemFontOfSize:16]
                               textColor:[UIColor GCBlueColor]];
    [view addSubview:label];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
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
    
    //记录论坛浏览记录
    NSMutableArray *array = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:kFORUMBROWSERECORD]];
    for (int i = 0; i < array.count; i++) {
        if (array[i] == forumModel.fid) {
            //移除原有浏览记录
            [array removeObjectAtIndex:i];
            break;
        }
    }
    [array insertObject:forumModel.fid atIndex:0];
    array = [NSMutableArray arrayWithArray:[array subarrayWithRange:NSMakeRange(0, array.count >= 5 ? 5 : array.count)]];
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:kFORUMBROWSERECORD];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Private Methods

- (void)configureBlock {
    @weakify(self);
    self.refreshBlock = ^{
        @strongify(self);
        [GCNetworkManager getForumIndexSuccess:^(GCForumIndexArray *array) {
            self.data = array.data;
            
            //增加最近浏览分类
            //最近浏览记录
            NSArray *browseArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:kFORUMBROWSERECORD]];
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
//                                    ((GCForumModel *)forumGroupModel.forums[i]).todayposts = @"0";
                                    break;
                                }
                            }
                        }
                    }
                }
                [self.data insertObject:forumGroupModel atIndex:0];
            }
            
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
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"No Network Connection", nil)];
        }];
    };
}

@end
