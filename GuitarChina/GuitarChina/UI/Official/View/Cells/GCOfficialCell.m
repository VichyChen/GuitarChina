//
//  GCOfficialCell.m
//  GuitarChina
//
//  Created by mac on 16/12/18.
//  Copyright © 2016年 陈大捷. All rights reserved.
//

#import "GCOfficialCell.h"

@implementation GCOfficialCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
        self.selectedBackgroundView.backgroundColor = [GCColor cellSelectedColor];
    }
    return self;
}

- (UIImageView *)leftImageView {
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(13, 10, 56, 56)];
        _leftImageView.layer.cornerRadius = 10;
        _leftImageView.clipsToBounds = YES;
        _leftImageView.backgroundColor = [GCColor grayColor4];
        [self.contentView addSubview:_leftImageView];
    }
    return _leftImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(82, 14, ScreenWidth - 82 - 13, 15)];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = [GCColor fontColor];
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)descriptionLabel {
    if (!_descriptionLabel) {
        _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(82, 28, ScreenWidth - 82 - 13, 40)];
        _descriptionLabel.font = [UIFont systemFontOfSize:12];
        _descriptionLabel.textColor = [GCColor grayColor2];
        _descriptionLabel.numberOfLines = 2;
        _descriptionLabel.preferredMaxLayoutWidth = _descriptionLabel.frame.size.width;
        [self.contentView addSubview:_descriptionLabel];
    }
    return _descriptionLabel;
}

@end
