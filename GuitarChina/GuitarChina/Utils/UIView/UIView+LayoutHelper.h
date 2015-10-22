//
//  UIView+LayoutHelper.h
//  GuitarChina
//
//  Created by 陈大捷 on 15/9/6.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIView (LayoutHelper)

+ (CGFloat)calculateLabelHeightWithText:(NSString *)text fontSize:(CGFloat)fontSize width:(CGFloat)width;

+ (CGFloat)calculateLabelHeightWithAttributeText:(NSAttributedString *)attributeText rectSize:(CGSize)rectSize;

@end
