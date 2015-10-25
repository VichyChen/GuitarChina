//
//  MJRefreshAutoNormalFooter.m
//  MJRefreshExample
//
//  Created by MJ Lee on 15/4/24.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "MJRefreshAutoNormalFooter.h"
#import "DGActivityIndicatorView.h"

@interface MJRefreshAutoNormalFooter()
@property (weak, nonatomic) DGActivityIndicatorView *loadingView;
@end

@implementation MJRefreshAutoNormalFooter
#pragma mark - 懒加载子控件

- (DGActivityIndicatorView *)loadingView
{
    if (!_loadingView) {
        DGActivityIndicatorView *loadingView = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeBallClipRotate tintColor:[UIColor lightGrayColor] size:25.0f];
        [self addSubview:_loadingView = loadingView];
    }
    return _loadingView;
}

#pragma makr - 重写父类的方法
- (void)prepare
{
    [super prepare];
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    // 圈圈
    CGFloat arrowCenterX = self.mj_w * 0.5;
    if (!self.isRefreshingTitleHidden) {
        arrowCenterX -= 100;
    }
    CGFloat arrowCenterY = self.mj_h * 0.5;
    self.loadingView.center = CGPointMake(arrowCenterX, arrowCenterY);
}

- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState
    
    // 根据状态做事情
    if (state == MJRefreshStateNoMoreData || state == MJRefreshStateIdle) {
        self.loadingView.hidden = YES;
        [self.loadingView stopAnimating];
    } else if (state == MJRefreshStateRefreshing) {
        self.loadingView.hidden = NO;
        [self.loadingView startAnimating];
    }
}

@end
