//
//  GCMyFavThreadCell.m
//  GuitarChina
//
//  Created by mac on 15/10/28.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCMyFavThreadCell.h"
#import "UIView+LayoutHelper.h"
#import "GCNetworkAPI.h"

#define SubjectWidth ScreenWidth - 30

@interface GCMyFavThreadCell()

@property (nonatomic, strong) UIImageView *avatarImage;
@property (nonatomic, strong) UILabel *authorLabel;
@property (nonatomic, strong) UILabel *datelineLabel;
@property (nonatomic, strong) UILabel *subjectLabel;
@property (nonatomic, strong) UILabel *repliesLabel;

//标题高度
@property (nonatomic, assign) CGFloat subjectLabelHeight;

@end

@implementation GCMyFavThreadCell

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
    
    self.avatarImage.frame = CGRectMake(20, 10, 40, 40);
    self.authorLabel.frame = CGRectMake(70, 8, ScreenWidth - 70, 20);
    self.datelineLabel.frame = CGRectMake(70, 33, ScreenWidth - 70, 20);
    self.subjectLabel.frame = CGRectMake(20, 60, SubjectWidth, self.subjectLabelHeight);
    self.repliesLabel.frame = CGRectMake(15, 8, SubjectWidth, 20);
}

#pragma mark - Private Method

- (void)configureView {
    [self.contentView addSubview:self.avatarImage];
    [self.contentView addSubview:self.authorLabel];
    [self.contentView addSubview:self.datelineLabel];
    [self.contentView addSubview:self.repliesLabel];
    [self.contentView addSubview:self.subjectLabel];
}

#pragma mark - Class Method

+ (CGFloat)getCellHeightWithModel:(GCMyFavThreadModel *)model {
    CGFloat subjectLabelHeight = [UIView calculateLabelHeightWithText:model.title fontSize:17 width:SubjectWidth];
    return subjectLabelHeight + 70;
}

#pragma mark - Setters

- (void)setModel:(GCMyFavThreadModel *)model {
    _model = model;
    
    [self.avatarImage sd_setImageWithURL:[NSURL URLWithString:GCNETWORKAPI_SMALLAVTARIMAGE_URL(model.uid)]
                        placeholderImage:nil
                                 options:SDWebImageRetryFailed];
    self.authorLabel.text = model.author;
    self.datelineLabel.text = [Util getDateStringWithTimeStamp:model.dateline format:@"yyyy-MM-dd HH:mm"];
    self.subjectLabel.text = model.title;
    CGFloat subjectLabelHeight = [UIView calculateLabelHeightWithText:self.subjectLabel.text fontSize:self.subjectLabel.font.pointSize width:SubjectWidth];
    self.subjectLabelHeight = subjectLabelHeight;
    self.repliesLabel.attributedText = model.repliesString;
}

#pragma mark - Getters

- (UIImageView *)avatarImage {
    if (!_avatarImage) {
        _avatarImage = [UIView createImageView:CGRectZero contentMode:UIViewContentModeScaleToFill];
    }
    return _avatarImage;
}

- (UILabel *)authorLabel {
    if (!_authorLabel) {
        _authorLabel = [UIView createLabel:CGRectZero
                                      text:@""
                                      font:[UIFont boldSystemFontOfSize:16]
                                 textColor:[UIColor GCBlueColor]];
    }
    return _authorLabel;
}

- (UILabel *)datelineLabel {
    if (!_datelineLabel) {
        _datelineLabel = [UIView createLabel:CGRectZero
                                        text:@""
                                        font:[UIFont systemFontOfSize:14]
                                   textColor:[UIColor GCDeepGrayColor]];
    }
    return _datelineLabel;
}

- (UILabel *)subjectLabel {
    if (!_subjectLabel) {
        _subjectLabel = [UIView createLabel:CGRectZero
                                       text:@""
                                       font:[UIFont systemFontOfSize:17]
                                  textColor:[UIColor GCFontColor]
                              numberOfLines:0
                    preferredMaxLayoutWidth:SubjectWidth];
        _subjectLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _subjectLabel;
}

- (UILabel *)repliesLabel {
    if (!_repliesLabel) {
        _repliesLabel = [UIView createLabel:CGRectZero
                                       text:@""
                                       font:[UIFont systemFontOfSize:14]
                                  textColor:[UIColor GCDeepGrayColor]];
        _repliesLabel.textAlignment = NSTextAlignmentRight;
    }
    return _repliesLabel;
}

@end
