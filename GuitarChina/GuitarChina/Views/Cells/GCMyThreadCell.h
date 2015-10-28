//
//  GCMyThreadCell.h
//  GuitarChina
//
//  Created by mac on 15/10/28.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCMyThreadModel.h"

@interface GCMyThreadCell : UITableViewCell

@property (nonatomic, strong) GCMyThreadModel *model;

+ (CGFloat)getCellHeightWithModel:(GCMyThreadModel *)model;

@end
