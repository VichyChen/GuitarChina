//
//  UIColor+Custom.m
//  GuitarChina
//
//  Created by 陈大捷 on 15/9/4.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "UIColor+Custom.h"

@implementation UIColor (Custom)

+ (UIColor *)GCBackgroundColor {
    return [UIColor colorWithRed:0.984f green:0.984f blue:0.984f alpha:1.00f];
}

//#80888F
+ (UIColor *)GCDeepGrayColor {
    return [UIColor colorWithRed:0.502f green:0.533f blue:0.561f alpha:1.00f];
}

//#E83126
+ (UIColor *)GCRedColor {
    return [UIColor colorWithRed:0.600 green:0.004 blue:0.000 alpha:1.00];
}

+ (UIColor *)GCLightRedColor {
    return [UIColor colorWithRed:0.941f green:0.000f blue:0.017f alpha:1.00f];
}

//#4C85A3
+ (UIColor *)GCBlueColor {
    return [UIColor colorWithRed:0.302f green:0.524f blue:0.639f alpha:1.00f];
}

+ (UIColor *)GCSeparatorLineColor {
    return [UIColor colorWithRed:0.850f green:0.850f blue:0.850f alpha:1.00f];
}

+ (UIColor *)GCBlackFontColor {
    return [UIColor darkTextColor];
}

+ (UIColor *)GCDarkGrayFontColor {
    return [UIColor darkGrayColor];
}

+ (UIColor *)GCLightGrayFontColor {
    return [UIColor colorWithRed:0.668f green:0.673f blue:0.687f alpha:1.00f];
}

+ (UIColor *)GCCellSelectedBackgroundColor {
    return [UIColor colorWithRed:0.945f green:0.945f blue:0.945f alpha:1.00f];
}

+ (UIColor *)UITextFieldPlaceHolderColor {
    return [UIColor colorWithRed:0.780 green:0.780 blue:0.804 alpha:1.00];
}

@end
