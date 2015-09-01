//
//  HomeViewController.m
//  GuitarChina
//
//  Created by 陈大捷 on 15/8/30.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "HomeViewController.h"
#import "RESideMenu.h"
#import "ForumViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"111";
    self.view.backgroundColor = [UIColor redColor];
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

@end
