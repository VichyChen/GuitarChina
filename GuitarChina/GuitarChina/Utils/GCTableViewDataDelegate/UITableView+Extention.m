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

- (CGFloat)separatorLeftInset {
    return self.separatorInset.left;
}

- (void)setSeparatorLeftInset:(CGFloat)separatorLeftInset {
    if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
        [self setSeparatorInset:UIEdgeInsetsMake(self.separatorInset.top,
                                                 separatorLeftInset,
                                                 self.separatorInset.bottom,
                                                 self.separatorInset.right)];
    }
}

- (CGFloat)separatorRightInset {
    return self.separatorInset.right;
}

- (void)setSeparatorRightInset:(CGFloat)separatorRightInset {
    if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
        [self setSeparatorInset:UIEdgeInsetsMake(self.separatorInset.top,
                                                 self.separatorInset.left,
                                                 self.separatorInset.bottom,
                                                 separatorRightInset)];
    }
}

- (UIEdgeInsets)separatorHorizontalInset {
    return UIEdgeInsetsMake(0, self.separatorInset.left, 0, self.separatorInset.right);
}

- (void)setSeparatorHorizontalInset:(UIEdgeInsets)separatorHorizontalInset {
    if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
        [self setSeparatorInset:UIEdgeInsetsMake(self.separatorInset.top,
                                                 separatorHorizontalInset.left,
                                                 self.separatorInset.bottom,
                                                 separatorHorizontalInset.right)];
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
