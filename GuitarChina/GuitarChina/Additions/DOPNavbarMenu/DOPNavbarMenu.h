//
//  DOPNavbarMenu.h
//  DOPNavbarMenu
//
//  Created by weizhou on 5/14/15.
//  Copyright (c) 2015 weizhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIGestureRecognizerSubclass.h>
#import "UIView+DOPExtension.h"

@interface UITouchGestureRecognizer : UIGestureRecognizer
@end

@interface DOPNavbarMenuItem : NSObject

typedef void(^Action)(void);

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, copy) Action action;

- (instancetype)initWithTitle:(NSString *)title icon:(UIImage *)icon row:(NSInteger)row actionBlock:(Action)actionBlock;
+ (DOPNavbarMenuItem *)ItemWithTitle:(NSString *)title icon:(UIImage *)icon row:(NSInteger)row actionBlock:(Action)actionBlock;

@end

@class DOPNavbarMenu;
@protocol DOPNavbarMenuDelegate <NSObject>

- (void)didShowMenu:(DOPNavbarMenu *)menu;
- (void)didDismissMenu:(DOPNavbarMenu *)menu;
- (void)didSelectedMenu:(DOPNavbarMenu *)menu atIndex:(NSInteger)index;

@end

@interface DOPNavbarMenu : UIView

@property (nonatomic, copy, readonly) NSArray *rowItems;

@property (nonatomic, assign, getter=isOpen) BOOL open;
@property (weak, nonatomic) id <DOPNavbarMenuDelegate> delegate;

@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *separatarColor;
@property (nonatomic, strong) UIColor *menuColor;
@property (nonatomic, strong) UIColor *iconColor;


- (instancetype)initWithRowItems:(NSArray *)rowItems;
- (void)showInNavigationController:(UINavigationController *)nvc;
- (void)dismissWithAnimation:(BOOL)animation;

@end
