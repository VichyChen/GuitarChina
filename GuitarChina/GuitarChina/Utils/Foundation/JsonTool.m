//
//  JsonTool.m
//  GuitarChina
//
//  Created by mac on 16/2/16.
//  Copyright © 2016年 陈大捷. All rights reserved.
//

#import "JsonTool.h"

@implementation JsonTool

+ (NSDictionary *)jsonToDictionary:(NSString *)string {
    if (!string) {
        return nil;
    }
    NSError *error;
    NSData *jsonData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if(error) {
        NSLog(@"json解析失败：%@", error);
        return nil;
    }
    return dictionary;
}

@end
