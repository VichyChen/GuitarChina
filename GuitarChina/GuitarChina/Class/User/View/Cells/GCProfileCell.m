//
//  GCProfileCell.m
//  GuitarChina
//
//  Created by mac on 2017/3/5.
//  Copyright © 2017年 陈大捷. All rights reserved.
//

#import "GCProfileCell.h"

@interface GCProfileCell()

@property (nonatomic, strong) UIView *containView;

@end

@implementation GCProfileCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
        self.selectedBackgroundView.backgroundColor = [GCColor cellSelectedColor];

        self.containView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 100)];
        [self.contentView addSubview:self.containView];
    }
    return self;
}

- (void)setState:(GCProfileCellState)state {
    _state = state;
    
    for (UIView *view in self.containView.subviews) {
        [view removeFromSuperview];
    }
    
    switch (state) {
        case GCProfileCellStateHeader:
        {
            [self.containView addSubview:self.avatorImageView];
            [self.containView addSubview:self.titleLabel];
            [self.containView addSubview:self.descriptionLabel];
            
            self.avatorImageView.frame = CGRectMake(13, 10, 60, 60);
            self.titleLabel.frame = CGRectMake(86, 15, 200, 20);
            self.descriptionLabel.frame = CGRectMake(86, 45, 200, 20);
            self.accessoryType = UITableViewCellAccessoryNone;
        }
            break;
            
        case GCProfileCellStateTitleArrow:
        {
            [self.containView addSubview:self.titleLabel];
            
            self.titleLabel.frame = CGRectMake(13, 0, ScreenWidth - 26, 44);
            
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
            
        case GCProfileCellStateTitleValue:
        {
            [self.containView addSubview:self.titleLabel];
            [self.containView addSubview:self.valueLabel];

            self.titleLabel.frame = CGRectMake(13, 0, ScreenWidth - 26, 44);
            self.valueLabel.frame = CGRectMake(13, 0, ScreenWidth - 26, 44);
            
            self.accessoryType = UITableViewCellAccessoryNone;
        }
            break;
    }
}

#pragma mark - Getters

- (UIImageView *)avatorImageView {
    if (!_avatorImageView) {
        _avatorImageView = [[UIImageView alloc] init];
        _avatorImageView.contentMode = UIViewContentModeScaleAspectFill;
        _avatorImageView.clipsToBounds = YES;
    }
    return _avatorImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = [GCColor fontColor];
    }
    return _titleLabel;
}

- (UILabel *)descriptionLabel {
    if (!_descriptionLabel) {
        _descriptionLabel = [[UILabel alloc] init];
        _descriptionLabel.font = [UIFont systemFontOfSize:14];
        _descriptionLabel.textColor = [GCColor grayColor1];
    }
    return _descriptionLabel;
}

- (UILabel *)valueLabel {
    if (!_valueLabel) {
        _valueLabel = [[UILabel alloc] init];
        _valueLabel.font = [UIFont systemFontOfSize:15];
        _valueLabel.textColor = [GCColor fontColor];
        _valueLabel.textAlignment = NSTextAlignmentRight;
    }
    return _valueLabel;
}



@end
