//
//  UIScrollView+Extension.h
//  GuitarChina
//
//  Created by mac on 17/1/3.
//  Copyright © 2017年 陈大捷. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIScrollView (Extension)

@property (nonatomic, copy) void(^headerRefreshBlock)(void);

@property (nonatomic, copy) void(^footerRefreshBlock)(void);

- (void)headerBeginRefresh;
- (void)headerEndRefresh;
- (void)footerBeginRefresh;
- (void)footerEndRefresh;

- (BOOL)isRefreshing;

@end
