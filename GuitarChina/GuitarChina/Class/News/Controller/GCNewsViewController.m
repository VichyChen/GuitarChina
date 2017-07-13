//
//  GCNewsViewController.m
//  GuitarChina
//
//  Created by mac on 17/1/30.
//  Copyright © 2017年 陈大捷. All rights reserved.
//

#import "GCNewsViewController.h"
#import "GCNewsListCell.h"
#import "GCNewsModel.h"
#import "HMSegmentedControl.h"
#import "GCNewsRecommendViewController.h"
#import "GCNewsCatViewController.h"

@interface GCNewsViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) HMSegmentedControl *segmentedControl;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) GCNewsRecommendViewController *newsRecommendViewController;
@property (nonatomic, strong) GCNewsCatViewController *newsCatViewController;

@end

@implementation GCNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    [self configureView];

    [self.newsRecommendViewController beginRefresh];
}

- (void)configureView {
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationItem.titleView = self.segmentedControl;
    
    [self.view addSubview:self.scrollView];
    
    self.newsRecommendViewController = [[GCNewsRecommendViewController alloc] init];
    @weakify(self);
    self.newsRecommendViewController.refreshBlock = ^{
        @strongify(self);
        [self getNews];
    };
    self.newsRecommendViewController.view.frame = CGRectMake(0, 0, ScreenWidth, self.scrollView.frame.size.height);
   
    self.newsCatViewController = [[GCNewsCatViewController alloc] init];
    self.newsCatViewController.view.frame = CGRectMake(ScreenWidth, 0, ScreenWidth, self.scrollView.frame.size.height);

    [self addChildViewController:self.newsRecommendViewController];
    [self addChildViewController:self.newsCatViewController];
    
    [self.scrollView addSubview:self.newsRecommendViewController.view];
    [self.scrollView addSubview:self.newsCatViewController.view];
}

#pragma mark - Event Responses

- (void)segmentedControlChangedValue {
    [self.scrollView setContentOffset:CGPointMake(self.segmentedControl.selectedSegmentIndex * ScreenWidth, 0) animated:NO];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger currentPage = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.segmentedControl.selectedSegmentIndex = currentPage;
}

#pragma mark - HTTP

- (void)getNews {
    @weakify(self);
    [GCNetworkManager getNewsSuccess:^(NSData *htmlData) {
        @strongify(self);
        GCNewsRecommendModel *model = [GCHTMLParse parseNews:htmlData];
        [self.newsCatViewController refresh:model.menuArray];
        [self.newsRecommendViewController refresh:model];
    } failure:^(NSError *error) {
        [self.newsRecommendViewController refresh:nil];
    }];
}

#pragma mark - Getters

- (HMSegmentedControl *)segmentedControl {
    if (!_segmentedControl) {
        _segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[[NSString stringWithFormat:@" %@ ", NSLocalizedString(@"First", nil)], [NSString stringWithFormat:@" %@ ", NSLocalizedString(@"Cat", nil)]]];
        _segmentedControl.frame = CGRectMake(0, 0, 120, 44);
        _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
        _segmentedControl.backgroundColor = [UIColor clearColor];
        _segmentedControl.selectionIndicatorColor = [UIColor whiteColor];
        _segmentedControl.selectionIndicatorHeight = 2;
        _segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor],
                                                  NSFontAttributeName : [UIFont systemFontOfSize:17]};
        _segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor],
                                                          NSFontAttributeName : [UIFont systemFontOfSize:17]};
        [_segmentedControl addTarget:self action:@selector(segmentedControlChangedValue) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentedControl;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64 - 48);
        _scrollView.contentSize = CGSizeMake(ScreenWidth * 2, _scrollView.frame.size.height);
        _scrollView.pagingEnabled = YES;
        _scrollView.scrollEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.bounces = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}


@end
