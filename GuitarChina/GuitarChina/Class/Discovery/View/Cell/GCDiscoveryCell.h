//
//  GCDiscoveryCell.h
//  GuitarChina
//
//  Created by 陈大捷 on 16/4/10.
//  Copyright © 2016年 陈大捷. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCGuideThreadModel.h"

@interface GCDiscoveryCell : UITableViewCell

@property (nonatomic, strong) GCGuideThreadModel *model;

+ (CGFloat)getCellHeightWithModel:(GCGuideThreadModel *)model;

@property (nonatomic, copy) void (^forumButtonBlock)(void);

@end
