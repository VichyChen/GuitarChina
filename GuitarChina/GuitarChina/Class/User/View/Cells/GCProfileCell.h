//
//  GCProfileCell.h
//  GuitarChina
//
//  Created by mac on 2017/3/5.
//  Copyright © 2017年 陈大捷. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, GCProfileCellState) {
    GCProfileCellStateHeader,
    GCProfileCellStateTitleArrow,
    GCProfileCellStateTitleValue
};

@interface GCProfileCell : UITableViewCell

@property (nonatomic, assign) GCProfileCellState state;

@property (nonatomic, strong) UIImageView *avatorImageView;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UILabel *valueLabel;

@end
