//
//  GCMoreCell.m
//  GuitarChina
//
//  Created by mac on 15/11/13.
//  Copyright © 2015年 陈大捷. All rights reserved.
//

#import "GCMoreCell.h"

@interface GCMoreCell()

@property (nonatomic, strong) UIView *separatorViewBottom;

@end

@implementation GCMoreCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
//        self.selectedBackgroundView.backgroundColor = [GCColor cellSelectedColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self configureView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.leftImageView.frame = CGRectMake(15, 12, 20, 20);
}

- (void)configureView {
//    [self.contentView addSubview:self.leftImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.redCountLabel];
    [self.contentView addSubview:self.separatorViewBottom];
}

#pragma mark - Getters

- (UIImageView *)leftImageView {
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] init];
        _leftImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _leftImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMargin, 14, kSubScreenWidth, 16)];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = [GCColor fontColor];
    }
    return _titleLabel;
}

- (UILabel *)redCountLabel {
    if (!_redCountLabel) {
        _redCountLabel = [[UILabel alloc] init];
        _redCountLabel.font = [UIFont systemFontOfSize:14];
        _redCountLabel.textColor = [UIColor whiteColor];
        _redCountLabel.backgroundColor = [UIColor redColor];
        _redCountLabel.clipsToBounds = YES;
        _redCountLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _redCountLabel;
}

- (UIView *)separatorViewBottom {
    if (!_separatorViewBottom) {
        _separatorViewBottom = [[UIView alloc] initWithFrame:CGRectMake(kMargin, 47.5, kSubScreenWidth, 0.5)];
        _separatorViewBottom.backgroundColor = [GCColor separatorLineColor];
    }
    return _separatorViewBottom;
}

@end
