//
//  GCThreadViewController.m
//  GuitarChina
//
//  Created by 陈大捷 on 15/9/4.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCThreadViewController.h"
#import "GCThreadReplyCell.h"
#import "GCThreadHeaderView.h"

@interface GCThreadViewController ()

@property (nonatomic, strong) GCThreadHeaderView *threadHeaderView;

@property (nonatomic, strong) NSMutableArray *data;

@end

@implementation GCThreadViewController

#pragma mark - life cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.pageIndex = 1;
        self.pageSize = 20;
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    self.title = @"帖子详情";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configureView];
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
    static NSString *identifier = @"GCThreadReplyCell";
    GCThreadReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[GCThreadReplyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    //    GCForumThreadModel *model = [self.data objectAtIndex:indexPath.row];
    //    cell.textLabel.text = model.subject;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - Private Methods

- (void)configureView {
    //    self.view addSubview:self.threadHeaderView
}

- (void)configureBlock {
    @weakify(self);
    self.refreshBlock = ^{
        @strongify(self);
        [[GCNetworkManager manager] getViewThreadWithThreadID:self.threadID pageIndex:self.pageIndex pageSize:self.pageSize Success:^(GCThreadDetailModel *model) {
            //                        if (self.pageIndex == 1) {
            //                            self.data = array.data;
            //                            //                [self.rowHeightArray removeAllObjects];
            //
            //                            [self.tableView reloadData];
            //                            [self endRefresh];
            //                        } else {
            //                            for (GCForumThreadModel *model in array.data) {
            //                                [self.data addObject:model];
            //                            }
            //
            //                            [self.tableView reloadData];
            //                            [self endFetchMore];
            //                        }
            
        } failure:^(NSError *error) {
            
        }];
    };
}

#pragma mark - Getters

- (GCThreadHeaderView *)threadHeaderView {
    if (_threadHeaderView == nil) {
        _threadHeaderView = [[GCThreadHeaderView alloc] init];
    }
    return _threadHeaderView;
}

@end
