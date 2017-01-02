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

@interface GCSearchViewController ()

@property (nonatomic, strong) UITextField *searchTextField;

@property (nonatomic, strong) UITableView *searchTableView;
@property (nonatomic, strong) GCTableViewKit *searchTableViewKit;
@property (nonatomic, strong) UITableView *historyTableView;
@property (nonatomic, strong) GCTableViewKit *historyTableViewKit;

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
    
    [self configureNavigationBar];
    [self configureView];
    [self configureBlock];
    
    self.historyBlock();
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.05 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self.searchTextField becomeFirstResponder];
    });
}

- (void)dealloc {
    NSLog(@"GCSearchViewController dealloc");
}

#pragma mark - Private Methods

- (void)configureNavigationBar {
    UIBarButtonItem *flexSpaceButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    flexSpaceButton.width = -10;
    
    UIBarButtonItem *closeButton = [UIView createBarButtonItem:NSLocalizedString(@"Cancel", nil) target:self action:@selector(closeAction)];
    closeButton.tintColor = [UIColor whiteColor];
    [closeButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16], NSFontAttributeName, nil] forState:UIControlStateNormal];

    self.navigationItem.rightBarButtonItems = @[flexSpaceButton, closeButton];
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
    UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(6, 6, 16, 16)];
    leftImageView.image = [[UIImage imageNamed:@"icon_search"] imageWithTintColor:[GCColor grayColor2]];
    [leftView addSubview:leftImageView];
    
    self.searchTextField = [UIView createTextField:CGRectMake(0, 0, ScreenWidth, 28) borderStyle:UITextBorderStyleNone text:@"" textColor:[GCColor fontColor] placeholder:NSLocalizedString(@"Enter Keywords", nil) textAlignment:NSTextAlignmentLeft];
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
    @weakify(self);
    self.searchTextField.bk_shouldReturnBlock = ^(UITextField *textField) {
        @strongify(self);
        [textField endEditing:YES];
        if (textField.text.length > 0) {
            [self showView:GCSearchViewTypeSearch];
            [self search:textField.text];
        }
        return YES;
    };
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
            
            self.searchArray = [NSMutableArray array];
            [self.searchTableView reloadData];
            [self.searchTableView.header beginRefreshing];
        }
        [GCNetworkManager getSearchWithKeyWord:self.searchTextField.text pageIndex:self.pageIndex Success:^(NSData *htmlData) {
            @strongify(self);
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
                self.searchArray = searchArray.datas;
                
                self.searchRowHeightArray = [NSMutableArray array];
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
                        @strongify(self);
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
        
//        if (kIsFree) {
//            [APP.adInterstitial presentFromViewController:self];
//        }
        
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
        _historyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _historyTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
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
        
        self.historyTableViewKit = [[GCTableViewKit alloc] initWithSystem];
        @weakify(self);
        self.historyTableViewKit.numberOfRowsInSectionBlock = ^(NSInteger section) {
            return (NSInteger)1;
        };
        self.historyTableViewKit.cellForRowAtIndexPathBlock = ^(NSIndexPath *indexPath) {
            @strongify(self);
            GCHistoryCell *cell = [[GCHistoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GCHistoryCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell configure:self.historyArray];
            cell.didSelectButtonBlock = ^(NSInteger index){
                @strongify(self);
                self.searchTextField.text = self.historyArray[index];
                [self showView:GCSearchViewTypeSearch];
                [self search:self.historyArray[indexPath.row]];
            };
            
            return cell;
        };
        self.historyTableViewKit.heightForRowAtIndexPathBlock = ^(NSIndexPath *indexPath) {
            @strongify(self);
            return [GCHistoryCell getCellHeightWithArray:self.historyArray].height;
        };
        [self.historyTableViewKit configureTableView:_historyTableView];
    }
    return _historyTableView;
}

- (UITableView *)searchTableView {
    if (!_searchTableView) {
        _searchTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)];
        _searchTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        if ([_searchTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_searchTableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        if ([_searchTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_searchTableView setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
        _searchTableView.tableFooterView = footerView;
        
        self.searchTableViewKit = [[GCTableViewKit alloc] initWithCellType:ConfigureCellTypeClass cellIdentifier:@"GCSearchCell"];
        @weakify(self);
        self.searchTableViewKit.getItemsBlock = ^{
            @strongify(self);
            return self.searchArray;
        };
        self.searchTableViewKit.cellForRowBlock = ^(NSIndexPath *indexPath, id item, UITableViewCell *cell) {
            GCSearchCell *searchCell = (GCSearchCell *)cell;
            GCSearchModel *model = item;
            searchCell.model = model;
        };
        self.searchTableViewKit.heightForRowBlock = ^(NSIndexPath *indexPath, id item) {
            @strongify(self);
            NSNumber *height = [self.searchRowHeightArray objectAtIndex:indexPath.row];
            return (CGFloat)[height floatValue];
        };
        self.searchTableViewKit.didSelectCellBlock = ^(NSIndexPath *indexPath, id item) {
            @strongify(self);
            [self.searchTextField endEditing:YES];
            GCThreadDetailViewController *controller = [[GCThreadDetailViewController alloc] init];
            GCSearchModel *model = item;
            controller.tid = model.tid;
            [self.navigationController pushViewController:controller animated:YES];
        };
        [self.searchTableViewKit configureTableView:_searchTableView];
    }
    return _searchTableView;
}

@end
