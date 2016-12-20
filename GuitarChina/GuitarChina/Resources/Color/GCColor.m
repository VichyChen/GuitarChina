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
    return [UIColor colorWithRed:0.960 green:0.960 blue:0.960 alpha:1.00];
}

+ (UIColor *)fontColor {
    return [UIColor colorWithRed:0.196 green:0.196 blue:0.196 alpha:1.00];
}

//#c30003
+ (UIColor *)redColor {
    return [UIColor colorWithRed:0.767 green:0.000 blue:0.015 alpha:1.00];
//    return [GCColor blueColor];
}

+ (UIColor *)blueColor {
//    return [UIColor colorWithRed:0.302f green:0.524f blue:0.639f alpha:1.00f];
        return [GCColor redColor];
}

+ (UIColor *)cellSelectedColor {
    return [UIColor colorWithRed:0.945f green:0.945f blue:0.945f alpha:1.00f];
}

+ (UIColor *)separatorLineColor {
    return [UIColor colorWithRed:0.851 green:0.867 blue:0.871 alpha:1.00];
}

+ (UIColor *)placeHolderColor {
    return [UIColor colorWithRed:0.780 green:0.780 blue:0.804 alpha:1.00];
}

+ (UIColor *)grayColor1 {
    return [UIColor colorWithRed:0.392 green:0.392 blue:0.392 alpha:1.00];
}

+ (UIColor *)grayColor2 {
    return [UIColor colorWithRed:0.592 green:0.592 blue:0.592 alpha:1.00];
}
+ (UIColor *)grayColor3 {
    return [UIColor colorWithRed:0.710 green:0.710 blue:0.710 alpha:1.00];
}

+ (UIColor *)grayColor4 {
    return [UIColor colorWithRed:0.851 green:0.867 blue:0.871 alpha:1.00];
}

@end
