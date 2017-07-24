//
//  UITableView+Extention.h
//  GuitarChina
//
//  Created by mac on 2017/7/24.
//  Copyright © 2017年 陈大捷. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UITableView (Extension)

@property (nonatomic, assign) CGFloat leftSeparatorInset;
@property (nonatomic, assign) CGFloat rightSeparatorInset;
@property (nonatomic, assign) UIEdgeInsets horizontalSeparatorInset;

- (void)initHeaderView;
- (void)initFooterView;

- (void)initHeaderViewWithFrame:(CGRect)frame;
- (void)initFooterViewWithFrame:(CGRect)frame;

- (void)initHeaderViewWithFrame:(CGRect)frame backgroundColor:(UIColor *)backgroundColor;
- (void)initFooterViewWithFrame:(CGRect)frame backgroundColor:(UIColor *)backgroundColor;

@end
