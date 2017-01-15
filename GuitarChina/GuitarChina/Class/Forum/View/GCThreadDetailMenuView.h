//
//  GCThreadDetailMenuView.h
//  GCThreadDetailMenuView
//
//  Created by mac on 15/10/16.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GCThreadDetailMenuItem : NSObject

typedef void(^ActionBlock)(void);

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, copy) ActionBlock actionBlock;

+ (GCThreadDetailMenuItem *)itemWithTitle:(NSString *)title icon:(UIImage *)icon row:(NSInteger)row actionBlock:(ActionBlock)actionBlock;

@end


@class GCThreadDetailMenuView;

@interface GCThreadDetailMenuView : UIView

@property (nonatomic, copy) NSArray *rowItems;
@property (nonatomic, assign) BOOL open;

@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *separatarColor;
@property (nonatomic, strong) UIColor *menuColor;
@property (nonatomic, strong) UIColor *iconColor;

- (instancetype)initWithRowItems:(NSArray *)rowItems;
- (void)showInNavigationController:(UINavigationController *)navigationController;
- (void)dismissMenu;

@end
