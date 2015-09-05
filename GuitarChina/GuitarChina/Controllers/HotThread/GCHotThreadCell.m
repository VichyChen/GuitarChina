//
//  GCHotThreadCell.m
//  GuitarChina
//
//  Created by 陈大捷 on 15/9/4.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCHotThreadCell.h"

@interface GCHotThreadCell()

@property (nonatomic, strong) UIImageView *avatarImage;
@property (nonatomic, strong) UILabel *authorLabel;
@property (nonatomic, strong) UILabel *datelineLabel;
@property (nonatomic, strong) UILabel *subjectLabel;
@property (nonatomic, strong) UILabel *lastpostLabel;
@property (nonatomic, strong) UILabel *lastposterLabel;

@end

@implementation GCHotThreadCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configureView];
    }
    return self;
}

- (void)configureView {
    [self.contentView addSubview:self.avatarImage];
    [self.contentView addSubview:self.authorLabel];
    [self.contentView addSubview:self.datelineLabel];
    [self.contentView addSubview:self.subjectLabel];

}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.avatarImage.frame = CGRectMake(10, 10, 50, 50);
    self.authorLabel.frame = CGRectMake(10, 70, ScreenWidth, 20);
//    self.datelineLabel.frame = CGRectMake(10, 70, ScreenWidth, 20);
//    self.subjectLabel.frame = CGRectMake(10, 70, ScreenWidth, 20);

}

+ (CGFloat)getCellHeightWithModel:(GCHotThreadModel *)model {
    return 60;
}

#pragma mark - Setters

- (void)setModel:(GCHotThreadModel *)model {
    _model = model;
    
    [self.avatarImage sd_setImageWithURL:[NSURL URLWithString:model.avatar]
                 placeholderImage:nil
                          options:SDWebImageRetryFailed];

    self.authorLabel.text = model.subject;
}

#pragma mark - Getters

- (UIImageView *)avatarImage {
    if (_avatarImage != nil) {
        return _avatarImage;
    }
    _avatarImage = [UIView createImageView:CGRectZero contentMode:UIViewContentModeScaleToFill];
    
    return _avatarImage;
}

- (UILabel *)authorLabel {
    if (_authorLabel != nil) {
        return _authorLabel;
    }
    _authorLabel = [UIView createLabel:CGRectZero
                                  text:@""
                                  font:[UIFont systemFontOfSize:16]
                             textColor:[UIColor redColor]];
    
    return _authorLabel;
}

- (UILabel *)datelineLabel {
    if (_datelineLabel != nil) {
        return _datelineLabel;
    }
    _datelineLabel = [UIView createLabel:CGRectZero
                                  text:@""
                                  font:[UIFont systemFontOfSize:16]
                             textColor:[UIColor redColor]];
    
    return _datelineLabel;
}

- (UILabel *)subjectLabel {
    if (_subjectLabel != nil) {
        return _subjectLabel;
    }
    _subjectLabel = [UIView createLabel:CGRectZero
                                    text:@""
                                    font:[UIFont systemFontOfSize:16]
                               textColor:[UIColor redColor]
                          numberOfLines:0 preferredMaxLayoutWidth:ScreenWidth - 20];
    
    return _subjectLabel;
}


@end
