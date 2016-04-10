//
//  GCDiscoveryViewController.m
//  GuitarChina
//
//  Created by 陈大捷 on 16/4/10.
//  Copyright © 2016年 陈大捷. All rights reserved.
//

#import "GCDiscoveryViewController.h"
#import "HMSegmentedControl.h"

@interface GCDiscoveryViewController ()

@property (nonatomic, strong) HMSegmentedControl *segmentedControl;

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation GCDiscoveryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Home", nil);
 
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private Methods

- (void)configureView {
    [self.view addSubview:self.segmentedControl];
    [self.view addSubview:self.scrollView];
}

#pragma mark - Event Responses

- (void)segmentedControlChangedValue {

}

#pragma mark - Getters

- (HMSegmentedControl *)segmentedControl {
    if (!_segmentedControl) {
        _segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"最热", @"最新", @"抢沙发", @"精华"]];
        _segmentedControl.frame = CGRectMake(0, 64, ScreenWidth, 40);
        _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationNone;
        _segmentedControl.backgroundColor = [UIColor GCCellSelectedBackgroundColor];
        _segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor GCDarkGrayFontColor],
                                                 NSFontAttributeName : [UIFont systemFontOfSize:15]};
        _segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor GCRedColor],
                                                         NSFontAttributeName : [UIFont systemFontOfSize:16]};
        [_segmentedControl addTarget:self action:@selector(segmentedControlChangedValue) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentedControl;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = CGRectMake(0, 64 + self.segmentedControl.frame.size.height, ScreenWidth, ScreenHeight - 64 - self.segmentedControl.frame.size.height - 48);
        _scrollView.contentSize = CGSizeMake(ScreenWidth * 4, ScreenHeight - 64 - self.segmentedControl.frame.size.height - 48);
        _scrollView.backgroundColor = [UIColor blueColor];
        _scrollView.pagingEnabled = YES;
        _scrollView.scrollEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = YES;
        _scrollView.showsVerticalScrollIndicator = YES;
    }
    return _scrollView;
}



@end
