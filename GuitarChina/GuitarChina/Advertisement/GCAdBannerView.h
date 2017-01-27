//
//  GCAdBannerView.h
//  GuitarChina
//
//  Created by mac on 16/12/28.
//  Copyright © 2016年 陈大捷. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GCAdBannerView : UIView

@property (nonatomic, copy) void(^beginRemoveFromSuperviewBlock)(void);
@property (nonatomic, copy) void(^endRemoveFromSuperviewBlock)(void);

- (instancetype)initWithRootViewController:(UIViewController *)viewController;

- (instancetype)initWithRootViewController:(UIViewController *)viewController countDown:(CGFloat)countDown;

@end
