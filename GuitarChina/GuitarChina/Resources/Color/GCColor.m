//
//  GCColor.m
//  GuitarChina
//
//  Created by mac on 16/5/30.
//  Copyright © 2016年 陈大捷. All rights reserved.
//

#import "GCColor.h"

@implementation GCColor

+ (UIColor *)backgroundColor {
    return [UIColor whiteColor];
}

+ (UIColor *)fontColor {
    return [UIColor colorWithRed:0.196 green:0.196 blue:0.196 alpha:1.00];
}

//#E83126
+ (UIColor *)redColor {
    return [UIColor colorWithRed:0.600 green:0.004 blue:0.000 alpha:1.00];
}

//#4C85A3
+ (UIColor *)blueColor {
    return [UIColor colorWithRed:0.302f green:0.524f blue:0.639f alpha:1.00f];
}

+ (UIColor *)cellSelectedColor {
    return [UIColor colorWithRed:0.945f green:0.945f blue:0.945f alpha:1.00f];
}

+ (UIColor *)separatorLineColor {
    return [UIColor colorWithRed:0.784f green:0.780f blue:0.800f alpha:1.00f];
}

+ (UIColor *)placeHolderColor {
    return [UIColor colorWithRed:0.780 green:0.780 blue:0.804 alpha:1.00];
}

@end
