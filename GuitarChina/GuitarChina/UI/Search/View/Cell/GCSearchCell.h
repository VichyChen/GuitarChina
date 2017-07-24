//
//  GCSearchCell.h
//  GuitarChina
//
//  Created by mac on 16/5/27.
//  Copyright © 2016年 陈大捷. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCSearchModel.h"

@interface GCSearchCell : UITableViewCell

@property (nonatomic, strong) GCSearchModel *model;

+ (CGFloat)getCellHeightWithModel:(GCSearchModel *)model;

@end
