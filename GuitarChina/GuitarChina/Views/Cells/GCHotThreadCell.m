//
//  GCHotThreadCell.m
//  GuitarChina
//
//  Created by 陈大捷 on 15/9/4.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCHotThreadCell.h"
#import "UIView+LayoutHelper.h"

#define SubjectWidth ScreenWidth - 28

@interface GCHotThreadCell()

@property (nonatomic, strong) UIImageView *avatarImage;
@property (nonatomic, strong) UILabel *authorLabel;
@property (nonatomic, strong) UILabel *datelineLabel;
@property (nonatomic, strong) UILabel *subjectLabel;
@property (nonatomic, strong) UILabel *lastPostDetailLabel;
@property (nonatomic, strong) UILabel *repliesLabel;

//标题高度
@property (nonatomic, assign) CGFloat subjectLabelHeight;

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

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.avatarImage.frame = CGRectMake(15, 10, 40, 40);
    self.authorLabel.frame = CGRectMake(65, 8, ScreenWidth - 75, 20);
    self.datelineLabel.frame = CGRectMake(65, 33, ScreenWidth - 75, 20);
    self.subjectLabel.frame = CGRectMake(15, 60, SubjectWidth, self.subjectLabelHeight);
    self.lastPostDetailLabel.frame = CGRectMake(15, 65 + self.subjectLabelHeight, SubjectWidth, 20);
    self.repliesLabel.frame = CGRectMake(15, 8, SubjectWidth, 20);
}

#pragma mark - Private Method

- (void)configureView {
    [self.contentView addSubview:self.avatarImage];
    [self.contentView addSubview:self.authorLabel];
    [self.contentView addSubview:self.datelineLabel];
    [self.contentView addSubview:self.subjectLabel];
    [self.contentView addSubview:self.lastPostDetailLabel];
    [self.contentView addSubview:self.repliesLabel];
}

#pragma mark - Class Method

+ (CGFloat)getCellHeightWithModel:(GCHotThreadModel *)model {
    CGFloat subjectLabelHeight = [UIView calculateLabelHeightWithText:model.subject fontSize:16 width:SubjectWidth];
    return subjectLabelHeight + 95;
}

#pragma mark - Setters

- (void)setModel:(GCHotThreadModel *)model {
    _model = model;
    [self.avatarImage sd_setImageWithURL:[NSURL URLWithString:model.avatar]
                        placeholderImage:nil
                                 options:SDWebImageRetryFailed];
    self.authorLabel.text = model.author;
    self.datelineLabel.text = model.dateline;
    self.subjectLabel.text = model.subject;
    CGFloat subjectLabelHeight = [UIView calculateLabelHeightWithText:self.subjectLabel.text fontSize:self.subjectLabel.font.pointSize width:SubjectWidth];
    self.subjectLabelHeight = subjectLabelHeight;
    self.lastPostDetailLabel.attributedText = model.lastPosterDetailString;
    self.repliesLabel.attributedText = model.replyAndViewDetailString;
}

#pragma mark - Getters

- (UIImageView *)avatarImage {
    if (!_avatarImage) {
        _avatarImage = [UIView createImageView:CGRectZero contentMode:UIViewContentModeScaleToFill];
        _avatarImage.layer.cornerRadius = 5;
        _avatarImage.layer.masksToBounds = YES;
    }
    return _avatarImage;
}

- (UILabel *)authorLabel {
    if (!_authorLabel) {
        _authorLabel = [UIView createLabel:CGRectZero
                                      text:@""
                                      font:[UIFont systemFontOfSize:16]
                                 textColor:[UIColor FontColor]];
    }
    return _authorLabel;
}

- (UILabel *)datelineLabel {
    if (!_datelineLabel) {
        _datelineLabel = [UIView createLabel:CGRectZero
                                        text:@""
                                        font:[UIFont systemFontOfSize:14]
                                   textColor:[UIColor LightFontColor]];
    }
    return _datelineLabel;
}

- (UILabel *)subjectLabel {
    if (!_subjectLabel) {
        _subjectLabel = [UIView createLabel:CGRectZero
                                       text:@""
                                       font:[UIFont systemFontOfSize:16]
                                  textColor:[UIColor FontColor]
                              numberOfLines:0
                    preferredMaxLayoutWidth:SubjectWidth];
        _subjectLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _subjectLabel;
}

- (UILabel *)lastPostDetailLabel {
    if (!_lastPostDetailLabel) {
        _lastPostDetailLabel = [UIView createLabel:CGRectZero
                                              text:@""
                                              font:[UIFont systemFontOfSize:14]
                                         textColor:[UIColor LightFontColor]];
    }
    return _lastPostDetailLabel;
}

- (UILabel *)repliesLabel {
    if (!_repliesLabel) {
        _repliesLabel = [UIView createLabel:CGRectZero
                                       text:@""
                                       font:[UIFont systemFontOfSize:14]
                                  textColor:[UIColor LightFontColor]];
        _repliesLabel.textAlignment = NSTextAlignmentRight;
    }
    return _repliesLabel;
}

@end
