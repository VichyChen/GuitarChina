//
//  GCThreadViewController.m
//  GuitarChina
//
//  Created by 陈大捷 on 15/9/4.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCThreadViewController.h"
#import "RESideMenu.h"
#import "GCThreadReplyCell.h"
#import "GCThreadHeaderView.h"
#import "GCThreadRightMenuViewController.h"
#import "GCLeftMenuViewController.h"
#import "KxMenu.h"

@interface GCThreadViewController () <UIWebViewDelegate>

@property (nonatomic, strong) GCThreadHeaderView *threadHeaderView;

@property (nonatomic, strong) NSMutableArray *data;

@property (nonatomic, strong) RESideMenu *sideMenuViewController;

@end

@implementation GCThreadViewController

#pragma mark - life cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.pageIndex = 1;
        self.pageSize = 20;
        
        self.rowHeightArray = [NSMutableArray array];
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    self.title = @"帖子详情";
    self.view.backgroundColor = [UIColor whiteColor];
    [self configureView];
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 25, 25);
    [leftButton setAdjustsImageWhenHighlighted:YES];
    UIImage *image = [UIImage imageNamed:@"icon_ellipsis"];
    [leftButton setImage:[image imageWithTintColor:[UIColor FontColor]] forState:UIControlStateNormal];
    [leftButton setImage:[image imageWithTintColor:[UIColor LightFontColor]] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(rightBarButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.rightBarButtonItem = barItem;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureBlock];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //    self.sideMenuViewController = ApplicationDelegate.sideMenuViewController;
    //    self.sideMenuViewController.rightMenuViewController = ApplicationDelegate.rightMenuViewController;
    //    self.sideMenuViewController.leftMenuViewController = nil;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //    RESideMenu *sideMenuViewController = ApplicationDelegate.sideMenuViewController;
    //    sideMenuViewController.rightMenuViewController = nil;
    //    self.sideMenuViewController.leftMenuViewController = ApplicationDelegate.leftMenuViewController;
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
    GCThreadDetailPostModel *model = [self.data objectAtIndex:indexPath.row];
    //    cell.indexPath = indexPath;
    //    cell.messageWebViewHeight = [[self.rowHeightArray objectAtIndex:indexPath.row] floatValue];
    //    NSLog(@"indexPath.row  %ld", indexPath.row);
    
    //    NSNumber *num = [self.rowHeightArray objectAtIndex:indexPath.row];
    //    if ([num floatValue] == 0) {
    [cell setModel:model];
    if (cell.messageWebView.superview) {
        [cell.messageWebView removeFromSuperview];
    }
    
    cell.messageWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    cell.messageWebView.dataDetectorTypes = UIDataDetectorTypeLink;
    cell.messageWebView.scrollView.scrollEnabled = NO;
    cell.messageWebView.tag = indexPath.row;
    cell.messageWebView.delegate = self;
    [cell.messageWebView loadHTMLString:model.message baseURL:nil];
    cell.messageWebView.frame = CGRectMake(5, 40, ScreenWidth - 10, [[self.rowHeightArray objectAtIndex:indexPath.row] floatValue]);
    [cell.contentView addSubview:cell.messageWebView];
    NSLog(@"%.f", [[self.rowHeightArray objectAtIndex:indexPath.row] floatValue]);
    
    //    } else {
    //        cell.authorLabel.text = model.author;
    //        cell.datelineLabel.text = model.dateline;
    //        cell.numberLabel.text = model.number;
    //        cell.messageWebView.delegate = nil;
    //
    //        [cell.messageWebView loadHTMLString:model.message baseURL:nil];
    //    }
    
    //    cell.ReloadAction = ^(NSIndexPath *path, CGFloat messageWebViewHeight) {
    //        NSLog(@"NSIndexPath *path  %ld", path.row);
    //        NSLog(@"%.f", messageWebViewHeight);
    //
    //        if ([[self.rowHeightArray objectAtIndex:path.row] floatValue] == 0) {
    //
    //            [self.rowHeightArray replaceObjectAtIndex:path.row withObject:[NSNumber numberWithFloat:messageWebViewHeight]];
    //            [self.tableView beginUpdates];
    //            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:path, nil] withRowAnimation:UITableViewRowAnimationNone];
    //            [self.tableView endUpdates];
    //        } else {
    //
    //        }
    //    };
    
    return cell;
}


#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if ([self.rowHeightArray[webView.tag] floatValue] != 0){
        return;
    }
    CGFloat f = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
    
    [self.rowHeightArray replaceObjectAtIndex:webView.tag withObject:[NSNumber numberWithFloat:f]];
    
//    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:webView.tag inSection:0], nil] withRowAnimation:UITableViewRowAnimationAutomatic];
//    [self.tableView endUpdates];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *height = [self.rowHeightArray objectAtIndex:indexPath.row];
    //    NSLog(@"heightForRowAtIndexPath height = %.f, row = %ld", [height floatValue], indexPath.row);
    return [height floatValue] + 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Event Response

- (void)rightBarButtonClickAction:(id)sender {
    NSArray *menuItems = @[
                           [KxMenuItem menuItem:NSLocalizedString(@"Reply", nil)
                                          image:nil
                                         target:nil
                                         action:@selector(replyAction:)],
                           
                           [KxMenuItem menuItem:NSLocalizedString(@"Collect", nil)
                                          image:[UIImage imageNamed:@"action_icon"]
                                         target:self
                                         action:@selector(collectAction:)],
                           
                           [KxMenuItem menuItem:NSLocalizedString(@"Share", nil)
                                          image:nil
                                         target:self
                                         action:@selector(shareAction:)],
                           
                           [KxMenuItem menuItem:NSLocalizedString(@"Report", nil)
                                          image:[UIImage imageNamed:@"reload"]
                                         target:self
                                         action:@selector(reportAction:)],
                           
                           [KxMenuItem menuItem:NSLocalizedString(@"Open in Safari", nil)
                                          image:[UIImage imageNamed:@"search_icon"]
                                         target:self
                                         action:@selector(safariAction:)],
                           
                           [KxMenuItem menuItem:NSLocalizedString(@"Copy url", nil)
                                          image:[UIImage imageNamed:@"home_icon"]
                                         target:self
                                         action:@selector(copyUrlAction:)],
                           ];
    
    for (KxMenuItem *item in menuItems) {
        item.alignment = NSTextAlignmentCenter;
    }
    
    [KxMenu showMenuInView:self.view
                  fromRect:CGRectMake(ScreenWidth - 50, 20, 44, 44)
                 menuItems:menuItems];
}

- (void)replyAction:(id)sender {
}

- (void)collectAction:(id)sender {
}

- (void)shareAction:(id)sender {
}

- (void)reportAction:(id)sender {
}

- (void)safariAction:(id)sender {
}

- (void)copyUrlAction:(id)sender {
}

#pragma mark - Private Methods

- (void)configureView {
    if (self.forumThreadModel) {
        [self.threadHeaderView setForumThreadModel:self.forumThreadModel];
    } else {
        [self.threadHeaderView setHotThreadModel:self.hotThreadModel];
    }
    self.tableView.tableHeaderView = self.threadHeaderView;
}

- (void)configureBlock {
    @weakify(self);
    self.refreshBlock = ^{
        @strongify(self);
        [[GCNetworkManager manager] getViewThreadWithThreadID:self.tid pageIndex:self.pageIndex pageSize:self.pageSize Success:^(GCThreadDetailModel *model) {
            if (self.pageIndex == 1) {
                self.data = model.postlist;
                [self.rowHeightArray removeAllObjects];
                for (GCThreadDetailPostModel *model in self.data) {
                    //                    [self.rowHeightArray addObject: [NSNumber numberWithFloat:[GCThreadReplyCell getCellHeightWithModel:model]]];
                    [self.rowHeightArray addObject:[NSNumber numberWithFloat:0]];
                }
                
                [self.tableView reloadData];
                [self endRefresh];
            } else {
                int startCount = (int)self.data.count;
                for (GCThreadDetailPostModel *item in model.postlist) {
                    [self.data addObject:item];
                    //                    [self.rowHeightArray addObject: [NSNumber numberWithFloat:[GCThreadReplyCell getCellHeightWithModel:item]]];
                    [self.rowHeightArray addObject:[NSNumber numberWithFloat:0]];
                }
                int endCount = (int)self.data.count;
                NSMutableArray *array = [NSMutableArray array];
                for (int i = startCount; i < endCount; i++) {
                    [array addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                }
                [self.tableView beginUpdates];
                NSLog(@"numberOfRowsInSection: %d", [self tableView:self.tableView numberOfRowsInSection:0]);
                
                NSLog(@"%d", self.data.count);
                [self.tableView insertRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationAutomatic];
                [self.tableView endUpdates];
                [self endFetchMore];
                
                
                //                    [self.tableView reloadData];
                //                [self endFetchMore];
            }
            
        } failure:^(NSError *error) {
            
        }];
    };
}

#pragma mark - Getters

- (GCThreadHeaderView *)threadHeaderView {
    if (!_threadHeaderView) {
        _threadHeaderView = [[GCThreadHeaderView alloc] initWithFrame:CGRectZero];
    }
    return _threadHeaderView;
}

@end
