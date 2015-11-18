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

- (instancetype)initWithTitle:(NSString *)title icon:(UIImage *)icon {
    self = [super init];
    if (self == nil) return nil;
    _title = title;
    _icon = icon;
    return self;
}

+ (DOPNavbarMenuItem *)ItemWithTitle:(NSString *)title icon:(UIImage *)icon {
    return [[self alloc] initWithTitle:title icon:icon];
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

- (instancetype)initWithFirstRowItems:(NSArray *)firstRowItems
                       SecondRowItems:(NSArray *)secondRowItems {
    self = [super initWithFrame:CGRectMake(0, 0, ScreenWidth, 0)];
    if (self == nil) return nil;
//    self.alpha = 0.5f;
    _firstRowItems = firstRowItems;
    _secondRowItems = secondRowItems;
    
    _open = NO;
    //    self.dop_height = (_numberOfRow+1) * rowHeight;
    self.dop_height = 300;
    self.dop_y = -self.dop_height;
    _beforeAnimationFrame = self.frame;
    _afterAnimationFrame = self.frame;
    self.backgroundColor = [UIColor colorWithRed:0.906f green:0.906f blue:0.906f alpha:1.00f];
    _background = [[UIView alloc] initWithFrame:CGRectZero];
    _background.backgroundColor = [UIColor lightGrayColor];
    _background.alpha = 0.5f;
    UITouchGestureRecognizer *gr = [[UITouchGestureRecognizer alloc] initWithTarget:self action:@selector(dismissMenu)];
    [_background addGestureRecognizer:gr];
    _textColor = [UIColor grayColor];
    _separatarColor = [UIColor lightGrayColor];
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    //    CGFloat buttonWidth = self.dop_width/self.maximumNumberInRow;
    CGFloat buttonWidth = ScreenWidth / 4;
    CGFloat buttonHeight = rowHeight;
    
    UIScrollView *scrollView1 = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, 120)];
    scrollView1.backgroundColor = [UIColor clearColor];
    scrollView1.contentSize = CGSizeMake(self.firstRowItems.count * 72 + 14, 120);
    scrollView1.pagingEnabled = NO;
    scrollView1.showsHorizontalScrollIndicator = NO;
    [self addSubview:scrollView1];
    
    UIView *seperator = [[UIView alloc] initWithFrame:CGRectMake(10, 185, ScreenWidth - 20, 1)];
    seperator.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:seperator];
    
    UIScrollView *scrollView2 = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 186, ScreenWidth, 120)];
    scrollView2.backgroundColor = [UIColor clearColor];
    scrollView2.contentSize = CGSizeMake(self.secondRowItems.count * 72 + 14, 120);
    scrollView2.pagingEnabled = NO;
    scrollView2.showsHorizontalScrollIndicator = NO;
    [self addSubview:scrollView2];
    
    [self.firstRowItems enumerateObjectsUsingBlock:^(DOPNavbarMenuItem *obj, NSUInteger idx, BOOL *stop) {
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(7 + idx * 72, 0, 72, 120);
        view.tag = idx;
        view.backgroundColor = [UIColor clearColor];
        [scrollView1 addSubview:view];
        
        UIView *iconView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 56, 56)];
        iconView.backgroundColor = [UIColor whiteColor];
        iconView.center = CGPointMake(view.frame.size.width / 2, view.frame.size.height / 2 - 15);
        iconView.layer.cornerRadius = 10;
        [view addSubview:iconView];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        imageView.backgroundColor = [UIColor clearColor];
        imageView.center = CGPointMake(iconView.frame.size.width / 2, iconView.frame.size.height / 2);
        [iconView addSubview:imageView];

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 56 + 25, 75, 20)];
        label.text = obj.title;
        label.numberOfLines = 0;
        label.preferredMaxLayoutWidth = 75;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = self.textColor;
        label.font = [UIFont systemFontOfSize:13];
        [view addSubview:label];
        if ([label sizeThatFits:label.frame.size].height > 20) {
            [label sizeToFit];
            label.center = CGPointMake(view.frame.size.width / 2, view.frame.size.height / 2 + 38);
        }

        //        [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
       
    }];
    
    [self.secondRowItems enumerateObjectsUsingBlock:^(DOPNavbarMenuItem *obj, NSUInteger idx, BOOL *stop) {
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(7 + idx * 72, 0, 72, 120);
        view.tag = idx;
        view.backgroundColor = [UIColor clearColor];
        [scrollView2 addSubview:view];
        
        UIView *iconView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 56, 56)];
        iconView.backgroundColor = [UIColor whiteColor];
        iconView.center = CGPointMake(view.frame.size.width / 2, view.frame.size.height / 2 - 16);
        iconView.layer.cornerRadius = 10;
        [view addSubview:iconView];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        imageView.backgroundColor = [UIColor clearColor];
        imageView.center = CGPointMake(iconView.frame.size.width / 2, iconView.frame.size.height / 2);
        [iconView addSubview:imageView];
        
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 56 + 25, 75, 20)];
        label.text = obj.title;
        label.numberOfLines = 0;
        label.preferredMaxLayoutWidth = 75;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = self.textColor;
        label.font = [UIFont systemFontOfSize:13];
        [view addSubview:label];
        if ([label sizeThatFits:label.frame.size].height > 20) {
            [label sizeToFit];
            label.center = CGPointMake(view.frame.size.width / 2, view.frame.size.height / 2 + 38);
        }
       
    }];
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
    [UIView animateWithDuration:0.5
                          delay:0.0
         usingSpringWithDamping:0.6
          initialSpringVelocity:1.0
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
        [UIView animateWithDuration:0.2 animations:^{
            self.dop_y += 20;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                self.dop_y = self.beforeAnimationFrame.origin.y;
            } completion:^(BOOL finished) {
                completion();
            }];
        }];
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
    [self dismissMenu];
}
@end
