//
//  NSString+Tools.h
//  GuitarChina
//
//  Created by 陈大捷 on 15/9/7.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Tools)

- (instancetype)trim;

- (NSArray *)split:(NSString *)string;

- (instancetype)replace:(NSString *)oldString toNewString:(NSString *)newString;

- (instancetype)substring:(NSInteger)index length:(NSInteger)length;

- (instancetype)substrFrom:(NSInteger)begin toIndex:(NSInteger)end;

//转换成小写
- (instancetype)toLowerCase;

//转换成大写
- (instancetype)toUpperCase;

//对比两个字符串内容是否一致
- (BOOL)equals:(NSString *)string;

//判断字符串是否以指定的前缀开头
- (BOOL)startsWith:(NSString *)prefix;

//判断字符串是否以指定的后缀结束
- (BOOL)endsWith:(NSString *)suffix;

@end
