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
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (UIImageView *)leftImageView {
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kMargin, kMargin, 55, 55)];
        _leftImageView.layer.cornerRadius = 4;
        _leftImageView.clipsToBounds = YES;
        [self.contentView addSubview:_leftImageView];
    }
    return _leftImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMargin + self.leftImageView.frame.size.width + 10, kMargin, 100, 20)];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = [GCColor fontColor];
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)descriptionLabel {
    if (!_descriptionLabel) {
        _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.titleLabel.frame.origin.x, kMargin + 20, kScreenWidth - self.titleLabel.frame.origin.x - kMargin, 35)];
        _descriptionLabel.font = [UIFont systemFontOfSize:12];
        _descriptionLabel.textColor = [GCColor grayColor2];
        _descriptionLabel.numberOfLines = 2;
        _descriptionLabel.preferredMaxLayoutWidth = _descriptionLabel.frame.size.width;
        [self.contentView addSubview:_descriptionLabel];
    }
    return _descriptionLabel;
}

@end
