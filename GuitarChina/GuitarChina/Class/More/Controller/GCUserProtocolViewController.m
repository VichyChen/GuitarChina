//
//  GCUserProtocolViewController.m
//  GuitarChina
//
//  Created by mac on 15/10/29.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCUserProtocolViewController.h"
#import "UIView+LayoutHelper.h"

@interface GCUserProtocolViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *label;

@end

@implementation GCUserProtocolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = NSLocalizedString(@"User Protocol", nil);
    self.edgesForExtendedLayout = UIRectEdgeAll;
    
    [self configureView];
}

#pragma mark - Private Methods

- (void)configureView {
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.label];
    [self.label sizeToFit];
    self.scrollView.contentSize = CGSizeMake(ScreenWidth, self.label.frame.size.height + 30);
}

#pragma mark - Getters

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _scrollView.showsVerticalScrollIndicator = YES;
    }
    
    return _scrollView;
}


- (UILabel *)label {
    if (!_label) {        
        _label = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, ScreenWidth - 30, 0)];
        _label.text = [Util getBundleTXTString:@"UserProtocol"];
        _label.font = [UIFont systemFontOfSize:16];
        _label.textColor = [GCColor grayColor1];
        _label.numberOfLines = 0;
        _label.preferredMaxLayoutWidth = ScreenWidth - 30;
    }
    return _label;
}


@end
