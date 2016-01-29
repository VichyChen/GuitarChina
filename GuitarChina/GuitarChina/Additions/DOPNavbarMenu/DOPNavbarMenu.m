//
//  DOPNavbarMenu.m
//  DOPNavbarMenu
//
//  Created by weizhou on 5/14/15.
//  Copyright (c) 2015 weizhou. All rights reserved.
//

#import "DOPNavbarMenu.h"

@implementation UITouchGestureRecognizer

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    self.state = UIGestureRecognizerStateRecognized;
}

@end

@implementation DOPNavbarMenuItem

- (instancetype)initWithTitle:(NSString *)title icon:(UIImage *)icon row:(NSInteger)row actionBlock:(Action)actionBlock{
    self = [super init];
    if (self == nil) return nil;
    _title = title;
    _icon = icon;
    _row = row;
    _action = actionBlock;
    return self;
}

+ (DOPNavbarMenuItem *)ItemWithTitle:(NSString *)title icon:(UIImage *)icon row:(NSInteger)row actionBlock:(Action)actionBlock {
    return [[self alloc] initWithTitle:title icon:icon row:(NSInteger)row actionBlock:actionBlock];
}

@end

@interface DOPNavbarMenu ()

//灰色半透明背景
@property (strong, nonatomic) UIView *background;
@property (assign, nonatomic) CGRect beforeAnimationFrame;
@property (assign, nonatomic) CGRect afterAnimationFrame;

@property (assign, nonatomic) CGFloat menuViewHeight;
@property (assign, nonatomic) CGFloat topScrollViewHeight;
@property (assign, nonatomic) CGFloat bottomScrollViewHeight;
@property (assign, nonatomic) CGFloat width;
@property (assign, nonatomic) CGFloat interval;
@property (assign, nonatomic) CGFloat fontSize;

//CGFloat topScrollViewHeight, bottomScrollViewHeight, width, interval, fontSize;
@end

@implementation DOPNavbarMenu

- (instancetype)initWithRowItems:(NSArray *)rowItems {
    if (iPhone) {
        self = [super initWithFrame:CGRectMake(0, 0, ScreenWidth, 0)];
    } else {
        self = [super initWithFrame:CGRectMake(100, 0, ScreenWidth - 200, 0)];
    }
    if (self) {
        
        if (iPhone) {
            _interval = 15;
            if (ScreenWidth == 320) {
                //3.5inch、4inch
                _width = (self.frame.size.width - _interval - 30) / 4;
            } else {
                _width = (self.frame.size.width - _interval) / 5;
            }
            _topScrollViewHeight = _width + _interval / 2 + 20 + 10;
            _bottomScrollViewHeight = _width + _interval / 2 + 30 + 10;
            _fontSize = 12;
        } else {
            //ipad
            _interval = 20;
            _width = (self.frame.size.width - _interval) / 5;
            _topScrollViewHeight = _width + _interval / 2 + 20 + 10;
            _bottomScrollViewHeight = _width + _interval / 2 + 20 + 10;
            _fontSize = 14;
            
            self.layer.cornerRadius = 10;
        }
        
        _menuViewHeight = 64 + _topScrollViewHeight + _bottomScrollViewHeight + 1;
        

        _rowItems = rowItems;
        _open = NO;
        
        self.dop_height = _menuViewHeight;
        self.dop_y = -self.dop_height;
        _beforeAnimationFrame = self.frame;
        _afterAnimationFrame = self.frame;
        
        _background = [[UIView alloc] initWithFrame:CGRectZero];
        _background.backgroundColor = [UIColor blackColor];
        _background.alpha = 0.3f;
        UITouchGestureRecognizer *gr = [[UITouchGestureRecognizer alloc] initWithTarget:self action:@selector(dismissMenu)];
        [_background addGestureRecognizer:gr];
        
        _textColor = [UIColor GCDarkGrayFontColor];
        _separatarColor = [UIColor GCSeparatorLineColor];
        _iconColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor GCCellSelectedBackgroundColor];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    
    UIScrollView *topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, self.frame.size.width, self.topScrollViewHeight)];
    topScrollView.backgroundColor = [UIColor clearColor];
    topScrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:topScrollView];
    
    UIView *seperator = [[UIView alloc] initWithFrame:CGRectMake(0, 64 + topScrollView.frame.size.height + 1, self.frame.size.width, 0.5)];
    seperator.backgroundColor = self.separatarColor;
    [self addSubview:seperator];
    
    UIScrollView *bottomScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, seperator.frame.origin.y + seperator.frame.size.height + 1, self.frame.size.width, self.bottomScrollViewHeight)];
    bottomScrollView.backgroundColor = [UIColor clearColor];
    bottomScrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:bottomScrollView];
    
    NSInteger count = 0;
    
    for (int i = 0; i < self.rowItems.count; i++) {
        DOPNavbarMenuItem *obj = self.rowItems[i];
        
        if (obj.row == 0) {
            count++;
        }
        
        UIView *itemView = [[UIView alloc] init];
        if (obj.row == 0) {
            itemView.frame = CGRectMake(self.interval / 2 + (count - 1) * self.width, 0, self.width, self.topScrollViewHeight);
        } else {
            itemView.frame = CGRectMake(self.interval / 2 + (i - count) * self.width, 0, self.width, self.bottomScrollViewHeight);
        }
        itemView.backgroundColor = [UIColor clearColor];
        
        UIButton *iconButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 15, self.width - self.interval, self.width - self.interval)];
        iconButton.tag = i;
        iconButton.backgroundColor = [UIColor clearColor];
        iconButton.center = CGPointMake(itemView.frame.size.width / 2, iconButton.center.y);
        iconButton.layer.cornerRadius = 10;
//        [iconButton setImage:obj.icon forState:UIControlStateNormal];
        [iconButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *buttonView = [[UIView alloc] initWithFrame:iconButton.frame];
        buttonView.layer.cornerRadius = 10;
        buttonView.backgroundColor = self.iconColor;

        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, iconButton.frame.size.width - iconButton.frame.size.width * 0.45, iconButton.frame.size.height - iconButton.frame.size.height * 0.45)];
        imageView.center = iconButton.center;
//        imageView.backgroundColor = [UIColor whiteColor];
        imageView.image = obj.icon;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [itemView addSubview:buttonView];
        [itemView addSubview:imageView];
        [itemView addSubview:iconButton];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.interval / 4, iconButton.frame.origin.y + iconButton.frame.size.height + self.interval / 2, self.width - self.interval / 2, 20)];
        label.text = obj.title;
        label.numberOfLines = 0;
        label.preferredMaxLayoutWidth = self.width - self.interval / 2;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = self.textColor;
        label.font = [UIFont systemFontOfSize:self.fontSize];
        [itemView addSubview:label];
        if ([label sizeThatFits:label.frame.size].height > 20) {
            [label sizeToFit];
            label.frame = CGRectMake(self.interval / 4, iconButton.frame.origin.y + iconButton.frame.size.height + 10, self.width - self.interval / 2, [label sizeThatFits:label.frame.size].height);
            label.center = CGPointMake(itemView.frame.size.width / 2, label.center.y);
        }
        
        if (obj.row == 0) {
            [topScrollView addSubview:itemView];
        } else {
            [bottomScrollView addSubview:itemView];
        }
    }
    topScrollView.contentSize = CGSizeMake(count * self.width + self.interval <= self.frame.size.width ? self.frame.size.width + 1 : count * self.width + self.interval, self.topScrollViewHeight);
    bottomScrollView.contentSize = CGSizeMake((self.rowItems.count - count) * self.width + self.interval <= self.frame.size.width ? self.frame.size.width + 1 : (self.rowItems.count - count) * self.width + self.interval, self.bottomScrollViewHeight);
}

- (void)showInNavigationController:(UINavigationController *)nvc {
    [nvc.view insertSubview:self.background belowSubview:nvc.navigationBar];
    [nvc.view insertSubview:self belowSubview:nvc.navigationBar];
    if (CGRectEqualToRect(self.beforeAnimationFrame, self.afterAnimationFrame)) {
        CGRect tmp = self.afterAnimationFrame;
        //        tmp.origin.y += ([UIApplication sharedApplication].statusBarFrame.size.height+nvc.navigationBar.dop_height+rowHeight*self.numberOfRow);
        tmp.origin.y += self.menuViewHeight;
        self.afterAnimationFrame = tmp;
    }
    self.background.frame = nvc.view.frame;
    [UIView animateWithDuration:0.4
                          delay:0.0
         usingSpringWithDamping:0.8
          initialSpringVelocity:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.dop_y = self.afterAnimationFrame.origin.y;
                     } completion:^(BOOL finished) {
                         if (self.delegate != nil) {
                             [self.delegate didShowMenu:self];
                         }
                         self.open = YES;
                     }];
}

- (void)dismissWithAnimation:(BOOL)animation {
    void (^completion)(void) = ^void(void) {
        [self removeFromSuperview];
        [self.background removeFromSuperview];
        if (self.delegate != nil) {
            [self.delegate didDismissMenu:self];
        }
        self.open = NO;
    };
    if (animation) {
        //        [UIView animateWithDuration:0.3 animations:^{
        //            self.dop_y += 20;
        //        } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            self.dop_y = self.beforeAnimationFrame.origin.y;
        } completion:^(BOOL finished) {
            completion();
        }];
        //        }];
    } else {
        self.dop_y = self.beforeAnimationFrame.origin.y;
        completion();
    }
}

- (void)dismissMenu {
    [self dismissWithAnimation:YES];
}

- (void)buttonTapped:(UIButton *)button {
    if (self.delegate) {
        [self.delegate didSelectedMenu:self atIndex:button.tag];
    }
    DOPNavbarMenuItem *obj = self.rowItems[button.tag];
    if (obj.action) {
        obj.action();
    }
    
    [self dismissMenu];
}
@end
