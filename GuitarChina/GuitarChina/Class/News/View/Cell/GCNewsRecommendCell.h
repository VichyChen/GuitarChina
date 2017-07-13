//
//  GCNewsRecommendCell.h
//  GuitarChina
//
//  Created by mac on 2017/7/12.
//  Copyright © 2017年 陈大捷. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GCNewsRecommendCell : UITableViewCell

@property (nonatomic, strong) UIView *blackTransparentView;
@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *readCountLabel;

@property (nonatomic, strong) GCNewsModulePostModel *model;

- (void)setModel:(GCNewsModulePostModel *)model index:(NSInteger)index;

+ (CGFloat)getCellHeightWithModel:(GCNewsModulePostModel *)model index:(NSInteger)index;

@end
