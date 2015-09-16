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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    self.hiddenNavigationBarWhenScrollToBottom = NO;
    self.title = NSLocalizedString(@"Forum", nil);
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 25, 25);
    [leftButton setAdjustsImageWhenHighlighted:YES];
    UIImage *image = [UIImage imageNamed:@"icon_hamberger"];
    [leftButton setImage:[image imageWithTintColor:[UIColor FontColor]] forState:UIControlStateNormal];
    [leftButton setImage:[image imageWithTintColor:[UIColor LightFontColor]] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(presentLeftMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = barItem;
    
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
    cell.textLabel.text = forumModel.name;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSNumber *height = [self.dataHeightArray objectAtIndex:indexPath.row];
//    return [height floatValue];
    return 60;
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

#pragma mark - Private Methods

- (void)configureBlock {
    @weakify(self);
    self.refreshBlock = ^{
        @strongify(self);
        [[GCNetworkManager manager] getForumIndexSuccess:^(GCForumIndexArray *array) {
            self.data = array.data;
            [self.rowHeightArray removeAllObjects];
            
            
            [self.tableView reloadData];
            [self endRefresh];
        } failure:^(NSError *error) {
            
        }];
    };
}

@end
