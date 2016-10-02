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

@property (copy, nonatomic) NSString *title;
@property (strong, nonatomic) UIImage *icon;
@property (assign, nonatomic) NSInteger row;
@property (copy, nonatomic) Action action;

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

@property (copy, nonatomic, readonly) NSArray *rowItems;

@property (assign, nonatomic, getter=isOpen) BOOL open;
@property (weak, nonatomic) id <DOPNavbarMenuDelegate> delegate;

@property (strong, nonatomic) UIColor *textColor;
@property (strong, nonatomic) UIColor *separatarColor;
@property (strong, nonatomic) UIColor *menuColor;
@property (strong, nonatomic) UIColor *iconColor;


- (instancetype)initWithRowItems:(NSArray *)rowItems;
- (void)showInNavigationController:(UINavigationController *)nvc;
- (void)dismissWithAnimation:(BOOL)animation;

@end
