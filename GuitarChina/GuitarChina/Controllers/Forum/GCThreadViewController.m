//
//  GCThreadViewController.m
//  GuitarChina
//
//  Created by 陈大捷 on 15/9/4.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCThreadViewController.h"
#import "GCThreadReplyCell.h"

@interface GCThreadViewController ()

@property (nonatomic, strong) NSMutableArray *data;

@end

@implementation GCThreadViewController

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
    
    [self configureBlock];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
