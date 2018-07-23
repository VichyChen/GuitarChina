//
//  GCDiscoveryViewController.m
//  GuitarChina
//
//  Created by 陈大捷 on 16/4/10.
//  Copyright © 2016年 陈大捷. All rights reserved.
//

#import "GCDiscoveryViewController.h"
#import "HMSegmentedControl.h"
#import "GCDiscoveryTableViewController.h"
#import "GCNavigationController.h"
#import "GCSearchViewController.h"
#import "GCDiscoveryPromptProView.h"

@interface GCDiscoveryViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *controllerArray;

@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property (nonatomic, strong) UIView *separatorView;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation GCDiscoveryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"首页";
    
    self.navigationItem.rightBarButtonItem = [UIView createCustomBarButtonItem:@"icon_search"
                                                                     normalColor:[UIColor whiteColor]
                                                                highlightedColor:[UIColor whiteColor]
                                                                          target:self
                                                                          action:@selector(searchAction)];
    
    [self configureView];
}

#pragma mark - UIScrollViewDelegate

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger currentPage = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.segmentedControl.selectedSegmentIndex = currentPage == -1 ? 0 : currentPage;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger currentPage = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.segmentedControl.selectedSegmentIndex = currentPage;
    [self loadViewController:currentPage];
}

#pragma mark - Event Responses

- (void)segmentedControlChangedValue {
    [self.scrollView setContentOffset:CGPointMake(self.segmentedControl.selectedSegmentIndex * kScreenWidth, 0) animated:NO];
    [self loadViewController:self.segmentedControl.selectedSegmentIndex];
}

- (void)searchAction {
    GCSearchViewController *controller = [[GCSearchViewController alloc] init];
    [self.navigationController pushViewController:controller animated:NO];
}

#pragma mark - Private Methods

- (void)configureView {
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, 0, 100, 44);
#if FREEVERSION
    label.text = @"吉他中国";
#else
    label.text = @"吉他中国Pro";
#endif
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:18];
    self.navigationItem.titleView = label;
    
    [self.view addSubview:self.segmentedControl];
    [self.view addSubview:self.separatorView];
    [self.view addSubview:self.scrollView];
    
    GCDiscoveryTableViewController *hot = [[GCDiscoveryTableViewController alloc] init];
    hot.discoveryTableViewType = GCDiscoveryTableViewTypeHot;
    GCDiscoveryTableViewController *new = [[GCDiscoveryTableViewController alloc] init];
    new.discoveryTableViewType = GCDiscoveryTableViewTypeNew;
    GCDiscoveryTableViewController *sofa = [[GCDiscoveryTableViewController alloc] init];
    sofa.discoveryTableViewType = GCDiscoveryTableViewTypeSofa;
    GCDiscoveryTableViewController *digest = [[GCDiscoveryTableViewController alloc] init];
    digest.discoveryTableViewType = GCDiscoveryTableViewTypeDigest;
    
    [self addChildViewController:hot];
    [self addChildViewController:new];
    [self addChildViewController:sofa];
    [self addChildViewController:digest];
    
    hot.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigatioinBarHeight - self.segmentedControl.frame.size.height - kTabBarHeight);
    [self.scrollView addSubview:hot.view];
    
    //提示无广告版
#if FREEVERSION
    if ([NSUD integerForKey:kGCFirstPromptPro] == 0) {
        GCDiscoveryPromptProView *promptProView = [[GCDiscoveryPromptProView alloc] initWithFrame:CGRectMake(0,kScreenHeight - kTabBarHeight - 88, kScreenWidth, 88)];
        [self.view addSubview:promptProView];
    }
#else

#endif
}

//延迟加载tableview
- (void)loadViewController:(NSInteger)index {
    if (![self.controllerArray containsObject:[NSNumber numberWithInteger:index]] && index >= 0) {
        [self.controllerArray addObject:[NSNumber numberWithInteger:index]];
        GCDiscoveryTableViewController *controller = (GCDiscoveryTableViewController *)[self.childViewControllers objectAtIndex:index];
        controller.view.frame = CGRectMake(kScreenWidth * index, 0, kScreenWidth, kScreenHeight - kNavigatioinBarHeight - self.segmentedControl.frame.size.height - kTabBarHeight);
        [self.scrollView addSubview:controller.view];
    }
}

#pragma mark - Getters

- (NSMutableArray *)controllerArray {
    if (!_controllerArray) {
        _controllerArray = [NSMutableArray arrayWithCapacity:4];
        [_controllerArray addObject:@0];
    }
    return _controllerArray;
}

- (HMSegmentedControl *)segmentedControl {
    if (!_segmentedControl) {
        _segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[[NSString stringWithFormat:@" %@ ", @"最热"], [NSString stringWithFormat:@" %@ ", @"最新"], [NSString stringWithFormat:@" %@ ", @"抢沙发"], [NSString stringWithFormat:@" %@ ", @"精华"]]];
        _segmentedControl.frame = CGRectMake(0, kNavigatioinBarHeight, kScreenWidth, 40);
        _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationNone;
        _segmentedControl.backgroundColor = [UIColor whiteColor];
        _segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : [GCColor grayColor1],
                                                  NSFontAttributeName : [UIFont systemFontOfSize:15]};
        _segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [GCColor redColor],
                                                          NSFontAttributeName : [UIFont systemFontOfSize:15]};
        [_segmentedControl addTarget:self action:@selector(segmentedControlChangedValue) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentedControl;
}

- (UIView *)separatorView {
    if (!_separatorView) {
        _separatorView = [[UIView alloc] init];
        _separatorView.frame = CGRectMake(0, _segmentedControl.frame.origin.y + _segmentedControl.frame.size.height, kScreenWidth, 0.5);
        _separatorView.backgroundColor = [GCColor separatorLineColor];
    }
    return _separatorView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = CGRectMake(0, kNavigatioinBarHeight + self.segmentedControl.frame.size.height + self.separatorView.frame.size.height, kScreenWidth, kScreenHeight - kNavigatioinBarHeight - self.segmentedControl.frame.size.height - kTabBarHeight);
        _scrollView.contentSize = CGSizeMake(kScreenWidth * 4, kScreenHeight - kNavigatioinBarHeight - self.segmentedControl.frame.size.height - kTabBarHeight);
        _scrollView.pagingEnabled = YES;
        _scrollView.scrollEnabled = YES;
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.bounces = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

@end
