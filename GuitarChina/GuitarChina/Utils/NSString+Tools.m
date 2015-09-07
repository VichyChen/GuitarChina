//
//  NSString+Tools.m
//  GuitarChina
//
//  Created by 陈大捷 on 15/9/7.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "NSString+Tools.h"

@implementation NSString (Tools)

- (instancetype)trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSArray *)split:(NSString *)string {
    return [self componentsSeparatedByString:string];
}

- (instancetype)replace:(NSString *)oldString toNewString:(NSString *)newString {
    return [self stringByReplacingOccurrencesOfString:oldString withString:newString];
}

- (instancetype)substring:(NSInteger)index length:(NSInteger)length {
    NSRange range ;
    range.location = index;
    range.length = length;
    return [self substringWithRange:range];
}

- (instancetype)substrFrom:(NSInteger)begin toIndex:(NSInteger)end {
    if (end <= begin) {
        return @"";
    }
    NSRange range = NSMakeRange(begin, end - begin);
    return [self substringWithRange:range];
}

//转换成小写
- (instancetype)toLowerCase {
    return [self lowercaseString];
}

//转换成大写
- (instancetype)toUpperCase {
    return [self uppercaseString];
}

//对比两个字符串内容是否一致
- (BOOL)equals:(NSString *)string {
    return [self isEqualToString:string];
}

//判断字符串是否以指定的前缀开头
- (BOOL)startsWith:(NSString *)prefix {
    return [self hasPrefix:prefix];
}

//判断字符串是否以指定的后缀结束
- (BOOL)endsWith:(NSString *)suffix {
    return [self hasSuffix:suffix];
}

@end
