//
//  GCMyFavThreadCell.h
//  GuitarChina
//
//  Created by mac on 15/10/28.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCMyFavThreadModel.h"

@interface GCMyFavThreadCell : UITableViewCell

@property (nonatomic, strong) GCMyFavThreadModel *model;

+ (CGFloat)getCellHeightWithModel:(GCMyFavThreadModel *)model;

@end
