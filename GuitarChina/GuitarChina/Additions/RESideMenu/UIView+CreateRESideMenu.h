//
//  UIView+CreateRESideMenu.h
//  GuitarChina
//
//  Created by mac on 15/9/22.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RESideMenu.h"

@interface UIView (CreateRESideMenu)

+ (RESideMenu *)createLeftRESideMenu;

+ (RESideMenu *)createRightRESideMenu:(UIViewController *)contentController;

@end
