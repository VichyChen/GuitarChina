//
//  UITableViewCell+Extension.m
//  TableDatasourceSeparation
//
//  Created by TuTu on 15/12/16.
//  Copyright © 2015年 teason. All rights reserved.
//

#import "UITableViewCell+Extension.h"

@implementation UITableViewCell (Extension)

- (void)configure:(UITableViewCell *)cell
        customObj:(id)object
        indexPath:(NSIndexPath *)indexPath {

}

+ (CGFloat)getCellHeightWithCustomObject:(id)object
                            indexPath:(NSIndexPath *)indexPath {
    if (object) {
        return 44.0f;
    }
    return 0.0f;
}

@end
