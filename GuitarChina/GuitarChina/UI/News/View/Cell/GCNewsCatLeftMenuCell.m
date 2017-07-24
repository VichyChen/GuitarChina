//
//  GCNewsCatLeftMenuCell.m
//  GuitarChina
//
//  Created by mac on 2017/7/7.
//  Copyright © 2017年 陈大捷. All rights reserved.
//

#import "GCNewsCatLeftMenuCell.h"

@interface GCNewsCatLeftMenuCell()


@end

@implementation GCNewsCatLeftMenuCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configureView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [GCColor backgroundColor];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.leftView.frame = CGRectMake(0, 0, 4, 44);
    self.titleLabel.frame = CGRectMake(15, 0, 105, 44);
}

#pragma mark - Private Method

- (void)configureView {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.leftView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected) {
        self.leftView.hidden = NO;
        self.titleLabel.textColor = [GCColor redColor];
        self.backgroundColor = [UIColor whiteColor];
    }
    else {
        self.leftView.hidden = YES;
        self.titleLabel.textColor = [GCColor fontColor];
        self.backgroundColor = [GCColor backgroundColor];
    }
}

- (UIView *)leftView {
    if (!_leftView) {
        _leftView = [[UIView alloc] init];
        _leftView.backgroundColor = [GCColor redColor];
    }
    return _leftView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = [GCColor fontColor];
    }
    return _titleLabel;
}

@end
