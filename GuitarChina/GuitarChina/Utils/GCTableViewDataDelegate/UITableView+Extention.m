//
//  UITableView+Extention.m
//  GuitarChina
//
//  Created by mac on 2017/7/24.
//  Copyright © 2017年 陈大捷. All rights reserved.
//

#import "UITableView+Extention.h"
#import <objc/runtime.h>

@implementation UITableView (Extension)

- (CGFloat)leftSeparatorInset {
    return self.separatorInset.left;
}

- (void)setLeftSeparatorInset:(CGFloat)leftSeparatorInset {
    if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
        [self setSeparatorInset:UIEdgeInsetsMake(self.separatorInset.top,
                                                 leftSeparatorInset,
                                                 self.separatorInset.bottom,
                                                 self.separatorInset.right)];
    }
}

- (CGFloat)rightSeparatorInset {
    return self.separatorInset.right;
}

- (void)setRightSeparatorInset:(CGFloat)rightSeparatorInset {
    if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
        [self setSeparatorInset:UIEdgeInsetsMake(self.separatorInset.top,
                                                 self.separatorInset.left,
                                                 self.separatorInset.bottom,
                                                 rightSeparatorInset)];
    }
}

- (UIEdgeInsets)horizontalSeparatorInset {
    return UIEdgeInsetsMake(0, self.separatorInset.left, 0, self.separatorInset.right);
}

- (void)setHorizontalSeparatorInset:(UIEdgeInsets)horizontalSeparatorInset {
    if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
        [self setSeparatorInset:UIEdgeInsetsMake(self.separatorInset.top,
                                                 horizontalSeparatorInset.left,
                                                 self.separatorInset.bottom,
                                                 horizontalSeparatorInset.right)];
    }
}

- (void)initHeaderView {
    self.tableHeaderView = [[UIView alloc] init];
}

- (void)initFooterView {
    self.tableFooterView = [[UIView alloc] init];
}

- (void)initHeaderViewWithFrame:(CGRect)frame {
    self.tableHeaderView = [[UIView alloc] initWithFrame:frame];
}

- (void)initFooterViewWithFrame:(CGRect)frame {
    self.tableFooterView = [[UIView alloc] initWithFrame:frame];
}

- (void)initHeaderViewWithFrame:(CGRect)frame backgroundColor:(UIColor *)backgroundColor {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = backgroundColor;
    self.tableHeaderView = view;
}

- (void)initFooterViewWithFrame:(CGRect)frame backgroundColor:(UIColor *)backgroundColor {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = backgroundColor;
    self.tableFooterView = view;
}

@end
