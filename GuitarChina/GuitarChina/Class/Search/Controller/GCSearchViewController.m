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
#import "GCSearchModel.h"

typedef NS_ENUM(NSInteger, GCSearchViewType) {
    GCSearchViewTypeHistory,
    GCSearchViewTypeSearch,
    GCSearchViewTypeBlank,
};


@interface GCSearchViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UITextField *searchTextField;
@property (nonatomic, strong) UITableView *searchTableView;
@property (nonatomic, strong) UITableView *historyTableView;

@property (nonatomic, copy) void (^searchBlock)();
@property (nonatomic, copy) void (^historyBlock)();
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) NSMutableArray *searchArray;
@property (nonatomic, strong) NSMutableArray *historyArray;
@property (nonatomic, strong) NSMutableArray *searchRowHeightArray;

@end

@implementation GCSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchArray = [NSMutableArray array];
    self.historyArray = [NSMutableArray array];
    self.searchRowHeightArray = [NSMutableArray array];
    
    [self configureNavigationBar];
    [self configureView];
    [self configureBlock];
    
    self.historyBlock();
    
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
        return 1;
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
        [cell configure:self.historyArray];
        @weakify(self);
        cell.didSelectButtonBlock = ^(NSInteger index){
            @strongify(self);
            self.searchTextField.text = self.historyArray[index];
            [self showView:GCSearchViewTypeSearch];
            [self search:self.historyArray[indexPath.row]];
        };

        return cell;
    }
    else {
        static NSString *identifier = @"GCSearchCell";
        GCSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[GCSearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        GCSearchModel *model = self.searchArray[indexPath.row];
        cell.model = model;
        
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 0) {
        return [GCHistoryCell getCellHeightWithArray:self.historyArray].height;
    }
    else {
        NSNumber *height = [self.searchRowHeightArray objectAtIndex:indexPath.row];
        return [height floatValue];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 0) {
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsMake(0, 10, 0, 10)];
        }
    }
    else {
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.searchTextField endEditing:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView.tag == 0) {
        /*
        self.searchTextField.text = self.historyArray[indexPath.row];
        [self showView:GCSearchViewTypeSearch];
        [self search:self.historyArray[indexPath.row]];
         */
    }
    else {
        GCThreadDetailViewController *controller = [[GCThreadDetailViewController alloc] init];
        controller.hidesBottomBarWhenPushed = YES;
        GCSearchModel *model = self.searchArray[indexPath.row];
        controller.tid = model.tid;
        [self.navigationController pushViewController:controller animated:YES];
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
    if (textField.text.length > 0) {
        [self showView:GCSearchViewTypeSearch];
        [self search:textField.text];
    }
    
    return YES;
}

#pragma mark - Private Methods

- (void)configureNavigationBar {
    UIBarButtonItem *flexSpaceButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    flexSpaceButton.width = -10;
    
    UIBarButtonItem *closeButton = [UIView createBarButtonItem:NSLocalizedString(@"Cancel", nil) target:self action:@selector(closeAction)];
    closeButton.tintColor = [UIColor whiteColor];
    [closeButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16], NSFontAttributeName, nil] forState:UIControlStateNormal];

    self.navigationItem.rightBarButtonItems = @[flexSpaceButton, closeButton];
    
    UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(6, 6, 16, 16)];
    leftImageView.image = [[UIImage imageNamed:@"icon_search"] imageWithTintColor:[GCColor grayColor2]];
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
    [leftView addSubview:leftImageView];
    
    self.searchTextField = [UIView createTextField:CGRectMake(0, 0, ScreenWidth, 28) borderStyle:UITextBorderStyleNone text:@"" textColor:[GCColor fontColor] placeholder:NSLocalizedString(@"Enter Keywords", nil) textAlignment:NSTextAlignmentLeft];
    self.searchTextField.delegate = self;
    self.searchTextField.font = [UIFont systemFontOfSize:15];
    self.searchTextField.textColor = [GCColor fontColor];
    self.searchTextField.tintColor = [GCColor redColor];
    self.searchTextField.backgroundColor = [GCColor cellSelectedColor];
    self.searchTextField.layer.cornerRadius = 3;
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
    [self.view addSubview:self.searchTableView];
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
            self.searchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            self.searchTableView.footer = nil;
            
            [self.searchArray removeAllObjects];
            [self.searchTableView reloadData];
            [self.searchTableView.header beginRefreshing];
        }
        [GCNetworkManager getSearchWithKeyWord:self.searchTextField.text pageIndex:self.pageIndex Success:^(NSData *htmlData) {
            NSString *checkString = [GCHTMLParse parseSearchOvertime:htmlData];
            if (checkString.length > 0) {
                [self.searchTableView.header endRefreshing];
                [SVProgressHUD showErrorWithStatus:checkString];
                return;
            }
            GCSearchArray *searchArray = [GCHTMLParse parseSearch:htmlData];
            if (self.pageIndex == 1 && searchArray.datas.count == 0) {
                [self.searchTableView.header endRefreshing];
                [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"对不起，没有找到匹配结果。", nil)];
                return;
            }
            if (self.pageIndex == 1) {
                [self.searchArray removeAllObjects];
                self.searchArray = searchArray.datas;
                
                [self.searchRowHeightArray removeAllObjects];
                for (GCSearchModel *model in searchArray.datas) {
                    [self.searchRowHeightArray addObject:[NSNumber numberWithFloat:[GCSearchCell getCellHeightWithModel:model]]];
                }
                
                [self.searchTableView.header endRefreshing];
                self.searchTableView.header = nil;
            }
            else {
                for (int i = 0; i < searchArray.datas.count; i++) {
                    [self.searchArray addObject:searchArray.datas[i]];
                    [self.searchRowHeightArray addObject:[NSNumber numberWithFloat:[GCSearchCell getCellHeightWithModel:searchArray.datas[i]]]];
                }
            }
            self.searchTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            [self.searchTableView reloadData];
            
            if (searchArray.datas.count == 50) {
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
    
    self.historyBlock = ^{
        @strongify(self);
        self.historyArray = [NSMutableArray arrayWithArray:[NSUD arrayForKey:kGCSearchHistory] ? [NSUD arrayForKey:kGCSearchHistory] : @[]];
        //        if (self.searchTextField.text.length > 0) {
        //            for (int i = (int)self.historyArray.count - 1; i >= 0; i--) {
        //                if (![self.historyArray[i] containString:self.searchTextField.text]) {
        //                    [self.historyArray removeObjectAtIndex:i];
        //                }
        //            }
        //        }
        if (self.historyArray.count == 0) {
            [self showView:GCSearchViewTypeBlank];
        }
        else {
            [self showView:GCSearchViewTypeHistory];
        }
        [self.historyTableView reloadData];
    };
}

- (void)search:(NSString *)text {
    if (text.length > 0) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:[NSUD arrayForKey:kGCSearchHistory] ? [NSUD arrayForKey:kGCSearchHistory] : @[]];
        for (int i = 0; i < array.count; i++) {
            if ([array[i] isEqualToString:text]) {
                [array removeObjectAtIndex:i];
                break;
            }
        }
        [array insertObject:text atIndex:0];
        [NSUD setObject:array forKey:kGCSearchHistory];
        [NSUD synchronize];
        
        self.pageIndex = 1;
        self.searchBlock();
    }
}

- (void)showView:(GCSearchViewType)searchViewType {
    switch (searchViewType) {
        case GCSearchViewTypeHistory:
            self.historyTableView.hidden = NO;
            self.searchTableView.hidden = YES;
            
            break;
            
        case GCSearchViewTypeSearch:
            self.historyTableView.hidden = YES;
            self.searchTableView.hidden = NO;
            
            break;
            
        case GCSearchViewTypeBlank:
            self.historyTableView.hidden = YES;
            self.searchTableView.hidden = YES;
            
            break;
            
        default:
            break;
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
    [self showView:GCSearchViewTypeHistory];
    self.historyBlock();
}

- (void)clearHistory {
    [NSUD setObject:@[] forKey:kGCSearchHistory];
    [NSUD synchronize];
    
    self.historyBlock();
}

#pragma mark - Getters

- (UITableView *)historyTableView {
    if (!_historyTableView) {
        _historyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)];
        _historyTableView.tag = 0;
        _historyTableView.delegate = self;
        _historyTableView.dataSource = self;
        _historyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if ([_historyTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_historyTableView setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
        }
        if ([_historyTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_historyTableView setLayoutMargins:UIEdgeInsetsMake(0, 10, 0, 10)];
        }
        
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
        
        UILabel *label = [UIView createLabel:CGRectMake(13, 0, ScreenWidth - 30, 44) text:NSLocalizedString(@"Search History", nil) font:[UIFont systemFontOfSize:15] textColor:[GCColor grayColor1]];
        [headerView addSubview:label];
        
        _historyTableView.tableHeaderView = headerView;
        
        
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 80)];
        
        UIButton *button = [UIView createButton:CGRectMake(0, 0, ScreenWidth - 60, 40) buttonType:UIButtonTypeSystem text:NSLocalizedString(@"Clean History", nil) target:self action:@selector(clearHistory)];
        button.tintColor = [GCColor redColor];
        button.layer.cornerRadius = 5;
        button.layer.borderColor = [GCColor redColor].CGColor;
        button.layer.borderWidth = 1;
        button.center = footerView.center;
        [footerView addSubview:button];
        
        _historyTableView.tableFooterView = footerView;
    }
    return _historyTableView;
}

- (UITableView *)searchTableView {
    if (!_searchTableView) {
        _searchTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)];
        _searchTableView.tag = 1;
        _searchTableView.delegate = self;
        _searchTableView.dataSource = self;
        
        if ([_searchTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_searchTableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        if ([_searchTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_searchTableView setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
        _searchTableView.tableFooterView = footerView;
    }
    return _searchTableView;
}

@end
