//
//  VCValidateUtil.m
//  GuitarChina
//
//  Created by mac on 2017/11/10.
//  Copyright © 2017年 陈大捷. All rights reserved.
//

#import "VCValidateUtil.h"

@implementation VCValidateUtil

+ (BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

@end
