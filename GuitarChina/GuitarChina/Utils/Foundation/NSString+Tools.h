#import <Foundation/Foundation.h>

@interface NSString (Tools)

- (instancetype)trim;

- (BOOL)containString:(NSString *)string;

- (NSArray *)split:(NSString *)string;

- (instancetype)replace:(NSString *)oldString toNewString:(NSString *)newString;

- (instancetype)substring:(NSInteger)index length:(NSInteger)length;

- (instancetype)substringFrom:(NSInteger)begin toIndex:(NSInteger)end;

- (instancetype)toLowerCase;

- (instancetype)toUpperCase;

- (BOOL)equals:(NSString *)string;

- (BOOL)startsWith:(NSString *)prefix;

- (BOOL)endsWith:(NSString *)suffix;

@end
