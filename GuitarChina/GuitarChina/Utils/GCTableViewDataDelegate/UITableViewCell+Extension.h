//
//  UITableViewCell+Extension.h
//  TableDatasourceSeparation

#import <UIKit/UIKit.h>

@interface UITableViewCell (Extension)

- (void)configure:(UITableViewCell *)cell
        customObj:(id)object
        indexPath:(NSIndexPath *)indexPath;

+ (CGFloat)getCellHeightWithCustomObject:(id)object
                            indexPath:(NSIndexPath *)indexPath;

@end
