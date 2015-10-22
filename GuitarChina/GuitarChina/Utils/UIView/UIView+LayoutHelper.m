//
//  UIView+LayoutHelper.m
//  GuitarChina
//
//  Created by 陈大捷 on 15/9/6.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "UIView+LayoutHelper.h"

@implementation UIView (LayoutHelper)

+ (CGFloat)calculateLabelHeightWithText:(NSString *)text fontSize:(CGFloat)fontSize width:(CGFloat)width {
    NSDictionary *attribute = @{ NSFontAttributeName : [UIFont systemFontOfSize:fontSize] };
    CGSize size = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    return size.height;
}

+ (CGFloat)calculateLabelHeightWithAttributeText:(NSAttributedString *)attributeText rectSize:(CGSize)rectSize {
    CGSize size=[attributeText boundingRectWithSize:rectSize options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    
    return size.height;
}


@end
