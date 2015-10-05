//
//  GCForumIndexCell.h
//  GuitarChina
//
//  Created by 陈大捷 on 15/9/4.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCForumIndexModel.h"

@interface GCForumIndexCell : UITableViewCell

@property (nonatomic, strong) GCForumModel *model;

+ (CGFloat)getCellHeightWithModel:(GCForumModel *)model;

@property (nonatomic, assign) CGFloat descriptLabelHeight;

@end
