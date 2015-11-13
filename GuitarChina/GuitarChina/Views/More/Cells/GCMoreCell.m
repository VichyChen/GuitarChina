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
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self configureView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.leftImageView.frame = CGRectMake(15, 12, 20, 20);
    self.titleLabel.frame = CGRectMake(45, 0, ScreenWidth - 80, 44);
    self.separatorViewBottom.frame = CGRectMake(0, 43.5, ScreenWidth, 0.5);
}

- (void)configureView {
    [self.contentView addSubview:self.leftImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.separatorViewBottom];
}

#pragma mark - Getters

- (UIImageView *)leftImageView {
    if (!_leftImageView) {
        _leftImageView = [UIView createImageView:CGRectZero
                                     contentMode:UIViewContentModeScaleAspectFill];
    }
    return _leftImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UIView createLabel:CGRectZero
                                     text:@"陈大捷"
                                     font:[UIFont systemFontOfSize:16]
                                textColor:[UIColor GCFontColor]];
    }
    return _titleLabel;
}

- (UIView *)separatorViewBottom {
    if (!_separatorViewBottom) {
        _separatorViewBottom = [[UIView alloc] initWithFrame:CGRectZero];
        _separatorViewBottom.backgroundColor = [UIColor GCGrayLineColor];
    }
    return _separatorViewBottom;
}

@end
