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

@implementation GCHotThreadViewController


#pragma mark - life cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //        self.pageIndex = 1;
        [self configureBlock];
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    self.title = NSLocalizedString(@"热帖", nil);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Left"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(presentLeftMenuViewController:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)configureBlock {
    __weak typeof(self) weakself = self;
    //    self.refreshBlock = ^{
    //        [[GCNetworkManager manager] getForumDisplayWithForumID:@"128" pageIndex:weakself.pageIndex pageSize:20 Success:^(GCForumDisplayArray *array) {
    //            if (weakself.pageIndex == 1) {
    //                NSLog(@"%ld", weakself.pageIndex);
    //                [weakself endRefresh];
    //            } else {
    //                NSLog(@"%ld", weakself.pageIndex);
    //                [weakself endFetchMore];
    //            }
    //        } failure:^(NSError *error) {
    //
    //        }];
    //    };
    
    self.refreshBlock = ^{
        [[GCNetworkManager manager] getHotThreadSuccess:^(GCHotThreadArray *array) {
            NSLog(@"%ld", weakself.pageIndex);
            [weakself endRefresh];
            
        } failure:^(NSError *error) {
            
        }];
    };
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"111"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"111"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GCThreadViewController *controller = [[GCThreadViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
