//
//  GCNewsListCell.h
//  GuitarChina
//
//  Created by mac on 2017/7/6.
//  Copyright © 2017年 陈大捷. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GCNewsListCell : UITableViewCell

@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *readCountLabel;

@property (nonatomic, strong) GCNewsModel *model;

+ (CGFloat)getCellHeightWithModel:(GCNewsModel *)model;

@end
