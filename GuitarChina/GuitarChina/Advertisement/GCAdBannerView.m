//
//  GCAdBannerView.m
//  GuitarChina
//
//  Created by mac on 16/12/28.
//  Copyright © 2016年 陈大捷. All rights reserved.
//

#import "GCAdBannerView.h"
#import "GDTMobBannerView.h"

@interface GCAdBannerView() <GDTMobBannerViewDelegate>

@property (nonatomic, strong) GDTMobBannerView *gdtBannerView;

@end

@implementation GCAdBannerView

- (instancetype)initWithRootViewController:(UIViewController *)viewController {
    if (self = [super init]) {
        self.clipsToBounds = YES;
        [self configureView:viewController];
    }
    return self;
}

- (instancetype)initWithRootViewController:(UIViewController *)viewController countDown:(CGFloat)countDown {
    if (self = [super init]) {
        self.clipsToBounds = YES;
        [self configureView:viewController];
        [self setupCountDown:countDown];
    }
    return self;
}

- (void)dealloc {
    NSLog(@"GCAdBannerView dealloc");
}

- (void)configureView:(UIViewController *)viewController {
    self.gdtBannerView = [[GDTMobBannerView alloc] initWithFrame:CGRectMake((kScreenWidth - GDTMOB_AD_SUGGEST_SIZE_320x50.width) / 2, 0, GDTMOB_AD_SUGGEST_SIZE_320x50.width, GDTMOB_AD_SUGGEST_SIZE_320x50.height) appkey:kGDTAppKey  placementId:kGDTBannerPlacementID];
    self.gdtBannerView.delegate = self;
    self.gdtBannerView.interval = 30;
    self.gdtBannerView.currentViewController = viewController;
    self.gdtBannerView.showCloseBtn = NO;
    [self addSubview:self.gdtBannerView];
    [self.gdtBannerView loadAdAndShow];
}

- (void)setupCountDown:(CGFloat)countDown {
    CGFloat delayInSeconds = countDown;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    @weakify(self);
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        @strongify(self);
        if (self.beginRemoveFromSuperviewBlock) {
            self.beginRemoveFromSuperviewBlock();
        }
        [UIView animateWithDuration:0.5 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
            if (self.endRemoveFromSuperviewBlock) {
                self.endRemoveFromSuperviewBlock();
            }
        }];
    });
}

#pragma mark - GDTMobBannerViewDelegate

- (void)bannerViewDidReceived {
    [GCStatistics event:GCStatisticsEventGDTBannerShow extra:nil];
    if (self.loadRequestCompleteBlock) {
        self.loadRequestCompleteBlock();
    }
}

- (void)bannerViewFailToReceived:(NSError *)error {

}

- (void)bannerViewClicked {
    [GCStatistics event:GCStatisticsEventGDTBannerClick extra:nil];
}

@end
