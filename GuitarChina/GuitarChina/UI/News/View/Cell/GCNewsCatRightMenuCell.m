//
//  GCNewsCatRightMenuCell.m
//  GuitarChina
//
//  Created by mac on 2017/7/7.
//  Copyright © 2017年 陈大捷. All rights reserved.
//

#import "GCNewsCatRightMenuCell.h"

@implementation GCNewsCatRightMenuCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
        self.selectedBackgroundView.backgroundColor = [GCColor cellSelectedColor];
        [self configureView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.titleLabel.frame = CGRectMake(13, 0, 200, 44);
}

#pragma mark - Private Method

- (void)configureView {
    [self.contentView addSubview:self.titleLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    

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
