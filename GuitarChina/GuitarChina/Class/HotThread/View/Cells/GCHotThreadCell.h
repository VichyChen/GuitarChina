//
//  GCHotThreadCell.h
//  GuitarChina
//
//  Created by 陈大捷 on 15/9/4.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCHotThreadModel.h"

@interface GCHotThreadCell : UITableViewCell

@property (nonatomic, strong) GCHotThreadModel *model;

+ (CGFloat)getCellHeightWithModel:(GCHotThreadModel *)model;

@end
