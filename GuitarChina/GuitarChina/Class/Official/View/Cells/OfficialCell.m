//
//  OfficialCell.m
//  GuitarChina
//
//  Created by mac on 16/12/18.
//  Copyright © 2016年 陈大捷. All rights reserved.
//

#import "OfficialCell.h"

@implementation OfficialCell

- (UIImageView *)leftImageView {
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 50, 50)];
        _leftImageView.layer.cornerRadius = 5;
        _leftImageView.clipsToBounds = YES;
        _leftImageView.backgroundColor = [GCColor grayColor4];
        [self.contentView addSubview:_leftImageView];
    }
    return _leftImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 17, ScreenWidth - 75 - 15, 15)];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = [GCColor fontColor];
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)descriptionLabel {
    if (!_descriptionLabel) {
        _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 30, ScreenWidth - 75 - 15, 40)];
        _descriptionLabel.font = [UIFont systemFontOfSize:12];
        _descriptionLabel.textColor = [GCColor grayColor2];
        _descriptionLabel.numberOfLines = 2;
        _descriptionLabel.preferredMaxLayoutWidth = _descriptionLabel.frame.size.width;
        [self.contentView addSubview:_descriptionLabel];
    }
    return _descriptionLabel;
}

@end
