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

static NSInteger rowHeight = 100;
static CGFloat titleFontSize = 15.0;

@interface DOPNavbarMenu ()

@property (strong, nonatomic) UIView *background;
@property (assign, nonatomic) CGRect beforeAnimationFrame;
@property (assign, nonatomic) CGRect afterAnimationFrame;

@end

@implementation DOPNavbarMenu

- (instancetype)initWithRowItems:(NSArray *)rowItems {
    self = [super initWithFrame:CGRectMake(0, 0, ScreenWidth, 0)];
    if (self == nil) return nil;

    _rowItems = rowItems;
    
    _open = NO;
    self.dop_height = 300;
    self.dop_y = -self.dop_height;
    _beforeAnimationFrame = self.frame;
    _afterAnimationFrame = self.frame;

    _background = [[UIView alloc] initWithFrame:CGRectZero];
    _background.backgroundColor = [UIColor blackColor];
    _background.alpha = 0.3f;
    UITouchGestureRecognizer *gr = [[UITouchGestureRecognizer alloc] initWithTarget:self action:@selector(dismissMenu)];
    [_background addGestureRecognizer:gr];
    
    _textColor = [UIColor grayColor];
    _separatarColor = [UIColor lightGrayColor];
    _iconColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor colorWithRed:0.922f green:0.922f blue:0.922f alpha:1.00f];

    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

//    NSInteger count = 0;
//    for (DOPNavbarMenuItem *obj in self.rowItems) {
//        if (obj.row == 0) {
//            count++;
//        }
//    }
    
    UIScrollView *scrollView1 = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, 120)];
    scrollView1.backgroundColor = [UIColor clearColor];
//    scrollView1.contentSize = CGSizeMake(count * 72 + 14, 120);
    scrollView1.showsHorizontalScrollIndicator = NO;
    [self addSubview:scrollView1];
    
    UIView *seperator = [[UIView alloc] initWithFrame:CGRectMake(0, 175, ScreenWidth, 0.5)];
    seperator.backgroundColor = self.separatarColor;
    [self addSubview:seperator];
    
    UIScrollView *scrollView2 = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 176, ScreenWidth, 120)];
    scrollView2.backgroundColor = [UIColor clearColor];
//    scrollView2.contentSize = CGSizeMake((self.rowItems.count - count) * 72 + 14, 120);
    scrollView2.showsHorizontalScrollIndicator = NO;
    [self addSubview:scrollView2];

    NSInteger count = 0;

    for (int i = 0; i < self.rowItems.count; i++) {
        DOPNavbarMenuItem *obj = self.rowItems[i];
        
        if (obj.row == 0) {
            count++;
        }
        
        UIView *view = [[UIView alloc] init];
        if (obj.row == 0) {
            view.frame = CGRectMake(7 + (count - 1) * 80, 0, 80, 120);
        } else {
            view.frame = CGRectMake(7 + (i - count) * 80, 0, 80, 120);
        }
        view.backgroundColor = [UIColor clearColor];
        
        UIButton *iconButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 65, 65)];
        iconButton.tag = i;
        iconButton.backgroundColor = self.iconColor;
        iconButton.center = CGPointMake(view.frame.size.width / 2, view.frame.size.height / 2 - 15);
        iconButton.layer.cornerRadius = 10;
        [iconButton setImage:obj.icon forState:UIControlStateNormal];
        [iconButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:iconButton];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 56 + 25, 75, 20)];
        label.text = obj.title;
        label.numberOfLines = 0;
        label.preferredMaxLayoutWidth = 75;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = self.textColor;
        label.font = [UIFont systemFontOfSize:12];
        [view addSubview:label];
        if ([label sizeThatFits:label.frame.size].height > 20) {
            [label sizeToFit];
            label.center = CGPointMake(view.frame.size.width / 2, view.frame.size.height / 2 + 38);
        }
        
        if (obj.row == 0) {
            [scrollView1 addSubview:view];
        } else {
            [scrollView2 addSubview:view];
        }
    }
    scrollView1.contentSize = CGSizeMake(count * 80 + 14 < ScreenWidth ? ScreenWidth + 1 : count * 80 + 15, 120);
    scrollView2.contentSize = CGSizeMake((self.rowItems.count - count) * 80 + 14 < ScreenWidth ? ScreenWidth + 1 : (self.rowItems.count - count) * 80 + 14, 120);
    
//     [self.rowItems enumerateObjectsUsingBlock:^(DOPNavbarMenuItem *obj, NSUInteger idx, BOOL *stop) {
//           }];
    
//    [self.secondRowItems enumerateObjectsUsingBlock:^(DOPNavbarMenuItem *obj, NSUInteger idx, BOOL *stop) {
//        UIView *view = [[UIView alloc] init];
//        view.frame = CGRectMake(7 + idx * 72, 0, 72, 120);
//        view.tag = idx;
//        view.backgroundColor = [UIColor clearColor];
//        [scrollView2 addSubview:view];
//        
//        UIButton *iconButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 56, 56)];
//        iconButton.backgroundColor = self.iconColor;
//        iconButton.center = CGPointMake(view.frame.size.width / 2, view.frame.size.height / 2 - 15);
//        iconButton.layer.cornerRadius = 10;
//        [iconButton setImage:obj.icon forState:UIControlStateNormal];
//        [view addSubview:iconButton];
//        
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 56 + 25, 75, 20)];
//        label.text = obj.title;
//        label.numberOfLines = 0;
//        label.preferredMaxLayoutWidth = 75;
//        label.textAlignment = NSTextAlignmentCenter;
//        label.textColor = self.textColor;
//        label.font = [UIFont systemFontOfSize:13];
//        [view addSubview:label];
//        if ([label sizeThatFits:label.frame.size].height > 20) {
//            [label sizeToFit];
//            label.center = CGPointMake(view.frame.size.width / 2, view.frame.size.height / 2 + 38);
//        }
//       
//    }];
}

- (void)showInNavigationController:(UINavigationController *)nvc {
    [nvc.view insertSubview:self.background belowSubview:nvc.navigationBar];
    [nvc.view insertSubview:self belowSubview:nvc.navigationBar];
    if (CGRectEqualToRect(self.beforeAnimationFrame, self.afterAnimationFrame)) {
        CGRect tmp = self.afterAnimationFrame;
        //        tmp.origin.y += ([UIApplication sharedApplication].statusBarFrame.size.height+nvc.navigationBar.dop_height+rowHeight*self.numberOfRow);
        tmp.origin.y += 300;
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
