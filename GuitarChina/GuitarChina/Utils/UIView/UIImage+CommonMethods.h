//
//  UIImage+CommonMethods.h
//  GuitarChina
//
//  Created by mac on 16/8/8.
//  Copyright © 2016年 陈大捷. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage (CommonMethods)

//图片上色
- (UIImage *)imageWithTintColor:(UIColor *)tintColor;

//压缩处理图片
- (UIImage *)compressForWidth:(CGFloat)defineWidth;

//圆角图片
- (UIImage *)cutCircleImage;

- (UIImage *)resize:(CGSize)resize;

//裁剪图片
- (UIImage *)cutWithRect:(CGRect)rect;

@end
