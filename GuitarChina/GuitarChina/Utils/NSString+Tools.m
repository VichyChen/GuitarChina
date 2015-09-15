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

- (instancetype)substringFrom:(NSInteger)begin toIndex:(NSInteger)end {
    if (end <= begin) {
        return @"";
    }
    NSRange range = NSMakeRange(begin, end - begin);
    return [self substringWithRange:range];
}

- (instancetype)toLowerCase {
    return [self lowercaseString];
}

- (instancetype)toUpperCase {
    return [self uppercaseString];
}

- (BOOL)equals:(NSString *)string {
    return [self isEqualToString:string];
}

- (BOOL)startsWith:(NSString *)prefix {
    return [self hasPrefix:prefix];
}

- (BOOL)endsWith:(NSString *)suffix {
    return [self hasSuffix:suffix];
}

@end
