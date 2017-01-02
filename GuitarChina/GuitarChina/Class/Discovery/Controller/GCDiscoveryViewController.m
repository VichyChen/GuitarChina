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
#import "GCAdBannerView.h"

@interface GCDiscoveryViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *controllerArray;

@property (nonatomic, strong) HMSegmentedControl *segmentedControl;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) GCAdBannerView *bannner;

@end

@implementation GCDiscoveryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Home", nil);
    
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
    [self.scrollView setContentOffset:CGPointMake(self.segmentedControl.selectedSegmentIndex * ScreenWidth, 0) animated:NO];
    [self loadViewController:self.segmentedControl.selectedSegmentIndex];
}

- (void)searchAction {
    GCSearchViewController *controller = [[GCSearchViewController alloc] init];
    GCNavigationController *navigationController = [[GCNavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:navigationController animated:NO completion:^{
        
    }];
}

#pragma mark - Private Methods

- (void)configureView {
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, 0, 100, 44);
    label.text = NSLocalizedString(@"GuitarChina", nil);
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:18];
    self.navigationItem.titleView = label;
    
    [self.view addSubview:self.segmentedControl];
    [self.view addSubview:self.scrollView];
//    if (kIsFree) {
//        [self.view addSubview:self.bannner];
//    }
    
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
    
    hot.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64 - self.segmentedControl.frame.size.height - 48);
    [self.scrollView addSubview:hot.view];
}

//延迟加载tableview
- (void)loadViewController:(NSInteger)index {
    if (![self.controllerArray containsObject:[NSNumber numberWithInteger:index]] && index >= 0) {
        [self.controllerArray addObject:[NSNumber numberWithInteger:index]];
        GCDiscoveryTableViewController *controller = (GCDiscoveryTableViewController *)[self.childViewControllers objectAtIndex:index];
        controller.view.frame = CGRectMake(ScreenWidth * index, 0, ScreenWidth, ScreenHeight - 64 - self.segmentedControl.frame.size.height - 48);
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
        _segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[[NSString stringWithFormat:@" %@ ", NSLocalizedString(@"Hottest", nil)], [NSString stringWithFormat:@" %@ ", NSLocalizedString(@"Newest", nil)], [NSString stringWithFormat:@" %@ ", NSLocalizedString(@"Sofa", nil)], [NSString stringWithFormat:@" %@ ", NSLocalizedString(@"Essence", nil)]]];
        _segmentedControl.frame = CGRectMake(0, 64, ScreenWidth, 40);
        _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationNone;
        _segmentedControl.backgroundColor = [GCColor cellSelectedColor];
        _segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : [GCColor grayColor1],
                                                  NSFontAttributeName : [UIFont systemFontOfSize:15]};
        _segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [GCColor redColor],
                                                          NSFontAttributeName : [UIFont systemFontOfSize:15]};
        [_segmentedControl addTarget:self action:@selector(segmentedControlChangedValue) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentedControl;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = CGRectMake(0, 64 + self.segmentedControl.frame.size.height, ScreenWidth, ScreenHeight - 64 - self.segmentedControl.frame.size.height - 48);
        _scrollView.contentSize = CGSizeMake(ScreenWidth * 4, ScreenHeight - 64 - self.segmentedControl.frame.size.height - 48);
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

- (GCAdBannerView *)bannner {
    if (!_bannner) {
        _bannner = [[GCAdBannerView alloc] initWithRootViewController:self countDown:100.0];
        _bannner.frame = CGRectMake(0, ScreenHeight - 48 - 50, ScreenWidth, 50);
    }
    return _bannner;
}

@end
