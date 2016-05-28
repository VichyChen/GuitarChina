//
//  GCSearchViewController.m
//  GuitarChina
//
//  Created by mac on 16/5/27.
//  Copyright © 2016年 陈大捷. All rights reserved.
//

#import "GCSearchViewController.h"
#import "GCThreadDetailViewController.h"
#import "GCSearchCell.h"
#import "GCHistoryCell.h"
#import "MJRefresh.h"

@interface GCSearchViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UITextField *searchTextField;
@property (nonatomic, strong) UITableView *searchTableView;
@property (nonatomic, strong) UITableView *historyTableView;

@property (nonatomic, copy) void (^searchBlock)();
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) NSMutableArray *searchArray;
@property (nonatomic, strong) NSMutableArray *historyArray;

@end

@implementation GCSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configureNavigationBar];
    [self configureView];
    [self configureBlock];
    
    self.historyArray = [NSMutableArray arrayWithArray:[NSUD arrayForKey:kGCSEARCHHISTORY] ? [NSUD arrayForKey:kGCSEARCHHISTORY] : @[]];
    [self.historyTableView reloadData];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.05 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self.searchTextField becomeFirstResponder];
    });
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 0) {
        return self.historyArray.count;
    }
    else {
        return self.searchArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 0) {
        static NSString *identifier = @"GCHistoryCell";
        GCHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[GCHistoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.textLabel.text = self.historyArray[indexPath.row];

        return cell;
    }
    else {
        static NSString *identifier = @"GCSearchCell";
        GCSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[GCSearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        GCSearchModel *model = self.searchArray[indexPath.row];
        cell.textLabel.text = model.subject;
        
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 0) {
        return 44;
    }
    else {
        return 44;
    }
    //    NSNumber *height = [self.rowHeightArray objectAtIndex:indexPath.row];
    //    return [height floatValue];
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//        [cell setSeparatorInset:UIEdgeInsetsZero];
//    }
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//    }
//}
//
//
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 0) {
        [self search:self.historyArray[indexPath.row]];
    }
    else {
        GCThreadDetailViewController *controller = [[GCThreadDetailViewController alloc] init];
        controller.hidesBottomBarWhenPushed = YES;
        GCSearchModel *model = self.searchArray[indexPath.row];
        controller.tid = model.tid;
        [self.navigationController pushViewController:controller animated:YES];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.searchTextField.isEditing) {
        [self.searchTextField endEditing:YES];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField endEditing:YES];
    
    [self search:textField.text];
    
    return YES;
}

#pragma mark - Private Methods

- (void)configureNavigationBar {
    self.navigationItem.rightBarButtonItem = [UIView createBarButtonItem:NSLocalizedString(@"Cancel", nil) target:self action:@selector(closeAction)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor GCDarkGrayFontColor];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16], NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(7, 7, 14, 14)];
    leftImageView.image = [[UIImage imageNamed:@"icon_search"] imageWithTintColor:[UIColor GCDarkGrayFontColor]];
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 26, 28)];
    [leftView addSubview:leftImageView];
    
    self.searchTextField = [UIView createTextField:CGRectMake(0, 0, ScreenWidth, 28) borderStyle:UITextBorderStyleNone text:@"" textColor:[UIColor GCBlackFontColor] placeholder:NSLocalizedString(@"Enter Keywords", nil) textAlignment:NSTextAlignmentLeft];
    self.searchTextField.delegate = self;
    self.searchTextField.font = [UIFont systemFontOfSize:14];
    self.searchTextField.textColor = [UIColor GCDarkGrayFontColor];
    self.searchTextField.backgroundColor = [UIColor GCCellSelectedBackgroundColor];
    self.searchTextField.layer.cornerRadius = 5;
    self.searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.searchTextField.leftViewMode = UITextFieldViewModeAlways;
    self.searchTextField.leftView = leftView;
    self.searchTextField.returnKeyType = UIReturnKeySearch;
    [self.searchTextField addTarget:self action:@selector(searchTextFieldValueChange:) forControlEvents:UIControlEventEditingChanged];
    self.navigationItem.titleView = self.searchTextField;
}

- (void)configureView {
    self.edgesForExtendedLayout = UIRectEdgeNone;

    [self.view addSubview:self.historyTableView];
//    [self.view addSubview:self.searchTableView];
}

- (void)configureBlock {
    self.pageIndex = 1;
    
    @weakify(self);
    self.searchBlock = ^{
        @strongify(self);
        if (self.pageIndex == 1) {
            self.searchTableView.header = ({
                MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                }];
                header.lastUpdatedTimeLabel.hidden = YES;
                header.stateLabel.hidden = YES;
                header;
            });
            self.searchTableView.footer = nil;
            
            [self.searchArray removeAllObjects];
            [self.searchTableView reloadData];
            [self.searchTableView.header beginRefreshing];
        }
        [GCNetworkManager getSearchWithKeyWord:self.searchTextField.text pageIndex:self.pageIndex Success:^(NSData *htmlData) {
            GCSearchArray *searchArray = [GCHTMLParse parseSearch:htmlData];
            if (self.pageIndex == 1) {
                [self.searchArray removeAllObjects];
                self.searchArray = searchArray.datas;
                [self.searchTableView.header endRefreshing];
                self.searchTableView.header = nil;
            }
            else {
                for (int i = 0; i < searchArray.datas.count; i++) {
                    [self.searchArray addObject:searchArray.datas[i]];
                }
            }
            [self.searchTableView reloadData];
            
            if (searchArray.datas.count > 0) {
                self.searchTableView.footer = ({
                    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                        self.pageIndex++;
                        self.searchBlock();
                    }];
                    footer.automaticallyRefresh = NO;
                    footer.refreshingTitleHidden = YES;
                    [footer setTitle:NSLocalizedString(@"Load More", nil) forState:MJRefreshStateIdle];
                    footer;
                });
            }
            else {
                self.searchTableView.footer = nil;
            }

        } failure:^(NSError *error) {
            
        }];
    };
}

- (void)search:(NSString *)text {
    if (text.length > 0) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:[NSUD arrayForKey:kGCSEARCHHISTORY] ? [NSUD arrayForKey:kGCSEARCHHISTORY] : @[]];
        for (int i = 0; i < array.count; i++) {
            if ([array[i] isEqualToString:text]) {
                [array removeObjectAtIndex:i];
                break;
            }
        }
        [array insertObject:text atIndex:0];
        [NSUD setObject:array forKey:kGCSEARCHHISTORY];
        [NSUD synchronize];
        
        self.pageIndex = 1;
        self.searchBlock();
    }
}

#pragma mark - Event Responses

- (void)closeAction {
    [self.searchTextField endEditing:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.25 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

- (void)searchTextFieldValueChange:(UITextField *)TextField {

}

#pragma mark - Getters

- (UITableView *)historyTableView {
    if (!_historyTableView) {
        _historyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)];
        _historyTableView.tag = 0;
        _historyTableView.delegate = self;
        _historyTableView.dataSource = self;
    }
    return _historyTableView;
}

- (UITableView *)searchTableView {
    if (!_searchTableView) {
        _searchTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)];
        _searchTableView.tag = 1;
        _searchTableView.delegate = self;
        _searchTableView.dataSource = self;
    }
    return _searchTableView;
}

- (NSMutableArray *)searchArray {
    if (!_searchArray) {
        _searchArray = [NSMutableArray array];
    }
    return _searchArray;
}

- (NSMutableArray *)historyArray {
    if (!_historyArray) {
        _historyArray = [NSMutableArray array];
    }
    return _historyArray;
}

@end
