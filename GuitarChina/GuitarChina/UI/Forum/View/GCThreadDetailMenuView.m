//
//  GCThreadDetailMenuView.m
//  GCThreadDetailMenuView
//
//  Created by mac on 15/10/16.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCThreadDetailMenuView.h"

@implementation GCThreadDetailMenuItem

- (instancetype)initWithTitle:(NSString *)title icon:(UIImage *)icon row:(NSInteger)row actionBlock:(ActionBlock)actionBlock{
    if (self == [super init]) {
        _title = title;
        _icon = icon;
        _row = row;
        _actionBlock = actionBlock;
    }
    return self;
}

+ (GCThreadDetailMenuItem *)itemWithTitle:(NSString *)title icon:(UIImage *)icon row:(NSInteger)row actionBlock:(ActionBlock)actionBlock {
    return [[self alloc] initWithTitle:title icon:icon row:(NSInteger)row actionBlock:actionBlock];
}

@end


@interface GCThreadDetailMenuView ()

@property (nonatomic, strong) UIView *transparentView;

@property (nonatomic, assign) CGRect beforeAnimationFrame;
@property (nonatomic, assign) CGRect afterAnimationFrame;

@property (nonatomic, assign) CGFloat menuViewHeight;
@property (nonatomic, assign) CGFloat topScrollViewHeight;
@property (nonatomic, assign) CGFloat bottomScrollViewHeight;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat interval;

@end

@implementation GCThreadDetailMenuView

- (instancetype)initWithRowItems:(NSArray *)rowItems {
    self = [super initWithFrame:CGRectMake(0, 0, ScreenWidth, 0)];
    if (self) {
        _interval = 15;
        if (ScreenWidth == 320) {
            //3.5inch、4inch
            _width = (self.frame.size.width - _interval - 30) / 4;
        } else {
            _width = (self.frame.size.width - _interval) / 5;
        }
        _topScrollViewHeight = _width + _interval / 2 + 20 + 10;
        _bottomScrollViewHeight = _width + _interval / 2 + 30 + 10;
        _menuViewHeight = kNavigatioinBarHeight + _topScrollViewHeight + _bottomScrollViewHeight + 1;
        
        self.frame = CGRectMake(self.frame.origin.x, -_menuViewHeight, self.frame.size.width, _menuViewHeight);
        _beforeAnimationFrame = self.frame;
        _afterAnimationFrame = self.frame;
        
        _transparentView = [[UIView alloc] initWithFrame:CGRectZero];
        _transparentView.backgroundColor = [UIColor blackColor];
        _transparentView.alpha = 0.3f;
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissMenu)];
        [_transparentView addGestureRecognizer:gesture];
        
        _rowItems = rowItems;
        _open = NO;
        
        _textColor = [GCColor grayColor1];
        _separatarColor = [GCColor separatorLineColor];
        _menuColor = [GCColor cellSelectedColor];
        _iconColor = [UIColor whiteColor];
        
        self.backgroundColor = _menuColor;
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    UIScrollView *topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavigatioinBarHeight, self.frame.size.width, self.topScrollViewHeight)];
    topScrollView.backgroundColor = [UIColor clearColor];
    topScrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:topScrollView];
    
    UIView *seperator = [[UIView alloc] initWithFrame:CGRectMake(0, kNavigatioinBarHeight + topScrollView.frame.size.height, self.frame.size.width, 0.5)];
    seperator.backgroundColor = self.separatarColor;
    [self addSubview:seperator];
    
    UIScrollView *bottomScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, seperator.frame.origin.y + seperator.frame.size.height, self.frame.size.width, self.bottomScrollViewHeight)];
    bottomScrollView.backgroundColor = [UIColor clearColor];
    bottomScrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:bottomScrollView];
    
    NSInteger count = 0;
    for (int i = 0; i < self.rowItems.count; i++) {
        GCThreadDetailMenuItem *obj = self.rowItems[i];
        
        if (obj.row == 0) {
            count++;
        }
        
        UIView *itemView = [[UIView alloc] init];
        itemView.backgroundColor = [UIColor clearColor];
        if (obj.row == 0) {
            itemView.frame = CGRectMake(self.interval / 2 + (count - 1) * self.width, 0, self.width, self.topScrollViewHeight);
        } else {
            itemView.frame = CGRectMake(self.interval / 2 + (i - count) * self.width, 0, self.width, self.bottomScrollViewHeight);
        }
        
        UIButton *iconButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 15, self.width - self.interval, self.width - self.interval)];
        iconButton.tag = i;
        iconButton.backgroundColor = self.iconColor;
        iconButton.center = CGPointMake(itemView.frame.size.width / 2, iconButton.center.y);
        iconButton.layer.cornerRadius = 10;
        [iconButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, iconButton.frame.size.width - iconButton.frame.size.width * 0.45, iconButton.frame.size.height - iconButton.frame.size.height * 0.45)];
        imageView.center = iconButton.center;
        imageView.image = obj.icon;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.interval / 4, iconButton.frame.origin.y + iconButton.frame.size.height + self.interval / 2, self.width - self.interval / 2, 20)];
        label.text = obj.title;
        label.numberOfLines = 0;
        label.preferredMaxLayoutWidth = self.width - self.interval / 2;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = self.textColor;
        label.font = [UIFont systemFontOfSize:12];
        if ([label sizeThatFits:label.frame.size].height > 20) {
            [label sizeToFit];
            label.frame = CGRectMake(self.interval / 4, iconButton.frame.origin.y + iconButton.frame.size.height + 10, self.width - self.interval / 2, [label sizeThatFits:label.frame.size].height);
            label.center = CGPointMake(itemView.frame.size.width / 2, label.center.y);
        }
        
        [itemView addSubview:iconButton];
        [itemView addSubview:imageView];
        [itemView addSubview:label];
        
        if (obj.row == 0) {
            [topScrollView addSubview:itemView];
        } else {
            [bottomScrollView addSubview:itemView];
        }
    }
    
    topScrollView.contentSize = CGSizeMake(count * self.width + self.interval <= self.frame.size.width ? self.frame.size.width + 1 : count * self.width + self.interval, self.topScrollViewHeight);
    bottomScrollView.contentSize = CGSizeMake((self.rowItems.count - count) * self.width + self.interval <= self.frame.size.width ? self.frame.size.width + 1 : (self.rowItems.count - count) * self.width + self.interval, self.bottomScrollViewHeight);
}

- (void)showInNavigationController:(UINavigationController *)navigationController {
    [navigationController.view insertSubview:self.transparentView belowSubview:navigationController.navigationBar];
    [navigationController.view insertSubview:self belowSubview:navigationController.navigationBar];
    if (CGRectEqualToRect(self.beforeAnimationFrame, self.afterAnimationFrame)) {
        CGRect tempFrame = self.afterAnimationFrame;
        tempFrame.origin.y += self.menuViewHeight;
        self.afterAnimationFrame = tempFrame;
    }
    self.transparentView.frame = navigationController.view.frame;
    [UIView animateWithDuration:0.4
                          delay:0.0
         usingSpringWithDamping:0.8
          initialSpringVelocity:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         CGRect tempFrame = self.frame;
                         tempFrame.origin.y = self.afterAnimationFrame.origin.y;
                         self.frame = tempFrame;
                     } completion:^(BOOL finished) {
                         self.open = YES;
                     }];
}

- (void)dismissMenu {
    [UIView animateWithDuration:0.3 animations:^{
        CGRect tempFrame = self.frame;
        tempFrame.origin.y = self.beforeAnimationFrame.origin.y;
        self.frame = tempFrame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.transparentView removeFromSuperview];
        self.open = NO;
    }];
}

- (void)buttonTapped:(UIButton *)button {
    GCThreadDetailMenuItem *obj = self.rowItems[button.tag];
    if (obj.actionBlock) {
        obj.actionBlock();
    }
    
    [self dismissMenu];
}

@end
