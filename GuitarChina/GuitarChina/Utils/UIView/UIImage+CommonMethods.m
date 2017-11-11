//
//  UIImage+CommonMethods.m
//  GuitarChina
//
//  Created by mac on 16/8/8.
//  Copyright © 2016年 陈大捷. All rights reserved.
//

#import "UIImage+CommonMethods.h"

@implementation UIImage (CommonMethods)

- (UIImage *)imageWithTintColor:(UIColor *)tintColor {
    if (tintColor) {
        UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextTranslateCTM(context, 0, self.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextSetBlendMode(context, kCGBlendModeNormal);
        CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
        CGContextClipToMask(context, rect, self.CGImage);
        [tintColor setFill];
        CGContextFillRect(context, rect);
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage;
    }
    return self;
}

- (UIImage *)compressForWidth:(CGFloat)defineWidth
{
    CGSize imageSize = self.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = (targetWidth / width) * height;
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [self drawInRect:CGRectMake(0,0,targetWidth,  targetHeight)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)cutCircleImage {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    CGContextRef ctr = UIGraphicsGetCurrentContext();
    CGFloat x, y, width, height;
    if (self.size.width > self.size.height) {
        width = height = self.size.height;
        x = (self.size.width - width) / 2;
        y = 0;
    }
    else {
        width = height = self.size.width;
        x = 0;
        y = (self.size.height - height) / 2;
    }
    CGRect rect = CGRectMake(x, y, width, height);
    CGContextAddEllipseInRect(ctr, rect);
    // 裁剪
    CGContextClip(ctr);
    // 将图片画上去
    [self drawInRect:rect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)resize:(CGSize)resize
{
    UIGraphicsBeginImageContextWithOptions(resize, NO, [[UIScreen mainScreen] scale]);
    [self drawInRect:CGRectMake(0, 0, resize.width, resize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage *)cutWithRect:(CGRect)rect {
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(imageRef), CGImageGetHeight(imageRef));
    
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, imageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:imageRef];
    UIGraphicsEndImageContext();
    
    return smallImage;
}


@end
