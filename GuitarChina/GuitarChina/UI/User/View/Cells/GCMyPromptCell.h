//
//  GCMyPromptCell.h
//  GuitarChina
//
//  Created by mac on 17/1/19.
//  Copyright © 2017年 陈大捷. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GCMyPromptCell : UITableViewCell

@property (nonatomic, strong) GCMyPromptModel *model;

+ (CGFloat)getCellHeightWithModel:(GCMyPromptModel *)model;

@end
