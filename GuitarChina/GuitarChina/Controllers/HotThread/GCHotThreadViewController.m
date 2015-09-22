//
//  GCHotThreadViewController.m
//  GuitarChina
//
//  Created by 陈大捷 on 15/9/4.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCHotThreadViewController.h"
#import "RESideMenu.h"
#import "GCThreadViewController.h"
#import "GCHotThreadCell.h"
#import "UIView+CreateRESideMenu.h"

@interface GCHotThreadViewController() {
    NSInteger lastY;
    NSInteger lastC;
}

@property (nonatomic, strong) NSMutableArray *data;

@end

@implementation GCHotThreadViewController

#pragma mark - life cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.rowHeightArray = [NSMutableArray array];
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    self.title = NSLocalizedString(@"Hot Thread", nil);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
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
    
    //    self.navigationController.navigationBar.translucent = YES;
    //    self.tableView.contentInset = UIEdgeInsetsMake(44.0f, 0.0f, 0.0f, 0.0f);
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
    static NSString *identifier = @"GCHotThreadCell";
    GCHotThreadCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[GCHotThreadCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
    GCThreadViewController *controller = [[GCThreadViewController alloc] init];
    GCHotThreadModel *model = [self.data objectAtIndex:indexPath.row];
    controller.hotThreadModel = model;
    controller.tid = model.tid;
    RESideMenu *sideMenuViewController = [UIView createRightRESideMenu:controller];
    [self.navigationController pushViewController:sideMenuViewController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Private Methods

- (void)configureBlock {
    @weakify(self);
    self.refreshBlock = ^{
        @strongify(self);
        [[GCNetworkManager manager] getHotThreadSuccess:^(GCHotThreadArray *array) {
            self.data = array.data;
            [self.rowHeightArray removeAllObjects];
            for (GCHotThreadModel *model in self.data) {
                [self.rowHeightArray addObject: [NSNumber numberWithFloat:[GCHotThreadCell getCellHeightWithModel:model]]];
            }
            [self.tableView reloadData];
            [self endRefresh];
        } failure:^(NSError *error) {
        }];
    };
}

@end
