//
//  GCForumDisplayCell.h
//  GuitarChina
//
//  Created by 陈大捷 on 15/9/4.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCForumDisplayModel.h"

@interface GCForumDisplayCell : UITableViewCell

@property (nonatomic, strong) GCForumThreadModel *model;

+ (CGFloat)getCellHeightWithModel:(GCForumThreadModel *)model;

@end
