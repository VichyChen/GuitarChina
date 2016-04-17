//
//  GCDiscoveryCell.m
//  GuitarChina
//
//  Created by 陈大捷 on 16/4/10.
//  Copyright © 2016年 陈大捷. All rights reserved.
//

#import "GCDiscoveryCell.h"
#import "UIView+LayoutHelper.h"
#import "GCForumDisplayViewController.h"

#define SubjectWidth ScreenWidth - 30

@interface GCDiscoveryCell()

@property (nonatomic, strong) UIImageView *avatarImage;
@property (nonatomic, strong) UILabel *authorLabel;
@property (nonatomic, strong) UILabel *datelineLabel;
@property (nonatomic, strong) UILabel *subjectLabel;
@property (nonatomic, strong) UIButton *forumButton;
@property (nonatomic, strong) UILabel *lastPostDetailLabel;
@property (nonatomic, strong) UILabel *repliesLabel;

//标题高度
@property (nonatomic, assign) CGFloat subjectLabelHeight;

@end

@implementation GCDiscoveryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
        self.selectedBackgroundView.backgroundColor = [UIColor GCCellSelectedBackgroundColor];
        [self configureView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.avatarImage.frame = CGRectMake(15, 10, 40, 40);
    self.authorLabel.frame = CGRectMake(65, 8, ScreenWidth - 65, 20);
    self.datelineLabel.frame = CGRectMake(65, 33, ScreenWidth - 65, 20);
    self.subjectLabel.frame = CGRectMake(15, 60, SubjectWidth, self.subjectLabelHeight);
    self.forumButton.frame = CGRectMake(15, 60 + self.subjectLabelHeight + 2, 150, 26);
    [self.forumButton sizeToFit];
    self.lastPostDetailLabel.frame = CGRectMake(15, self.forumButton.frame.origin.y + self.forumButton.frame.size.height, SubjectWidth, 20);
    self.repliesLabel.frame = CGRectMake(15, 8, SubjectWidth, 20);
}

#pragma mark - Private Method

- (void)configureView {
    [self.contentView addSubview:self.avatarImage];
    [self.contentView addSubview:self.authorLabel];
    [self.contentView addSubview:self.datelineLabel];
    [self.contentView addSubview:self.subjectLabel];
    [self.contentView addSubview:self.forumButton];
    [self.contentView addSubview:self.lastPostDetailLabel];
    [self.contentView addSubview:self.repliesLabel];
}

#pragma mark - Class Method

+ (CGFloat)getCellHeightWithModel:(GCGuideThreadModel *)model {
    CGFloat subjectLabelHeight = [UIView calculateLabelHeightWithText:model.subject fontSize:16 width:SubjectWidth];
    return subjectLabelHeight + 118;
}

#pragma mark - Event Responses

- (void)buttonAction:(UIButton *)button {
    if (self.forumButtonBlock) {
        self.forumButtonBlock();
    }
}

#pragma mark - Setters

- (void)setModel:(GCGuideThreadModel *)model {
    _model = model;
    
    [self.avatarImage sd_setImageWithURL:[NSURL URLWithString:GCNETWORKAPI_URL_SMALLAVTARIMAGE(model.authorid)]
                        placeholderImage:nil
                                 options:SDWebImageRetryFailed];
    self.authorLabel.text = model.author;
    self.datelineLabel.text = model.dateline;
    self.subjectLabel.text = model.subject;
    CGFloat subjectLabelHeight = [UIView calculateLabelHeightWithText:self.subjectLabel.text fontSize:self.subjectLabel.font.pointSize width:SubjectWidth];
    self.subjectLabelHeight = subjectLabelHeight;
    [self.forumButton setTitle:model.forum forState:UIControlStateNormal];
    self.lastPostDetailLabel.attributedText = model.lastPosterDetailString;
    self.repliesLabel.attributedText = model.replyAndViewDetailString;
}

#pragma mark - Getters

- (UIImageView *)avatarImage {
    if (!_avatarImage) {
        _avatarImage = [UIView createImageView:CGRectZero contentMode:UIViewContentModeScaleToFill];
        //        _avatarImage.layer.cornerRadius = 5;
        //        _avatarImage.layer.masksToBounds = YES;
    }
    return _avatarImage;
}

- (UILabel *)authorLabel {
    if (!_authorLabel) {
        _authorLabel = [UIView createLabel:CGRectZero
                                      text:@""
                                      font:[UIFont boldSystemFontOfSize:14]
                                 textColor:[UIColor GCBlueColor]];
    }
    return _authorLabel;
}

- (UILabel *)datelineLabel {
    if (!_datelineLabel) {
        _datelineLabel = [UIView createLabel:CGRectZero
                                        text:@""
                                        font:[UIFont systemFontOfSize:13]
                                   textColor:[UIColor GCLightGrayFontColor]];
    }
    return _datelineLabel;
}

- (UILabel *)subjectLabel {
    if (!_subjectLabel) {
        _subjectLabel = [UIView createLabel:CGRectZero
                                       text:@""
                                       font:[UIFont systemFontOfSize:16]
                                  textColor:[UIColor GCDarkGrayFontColor]
                              numberOfLines:0
                    preferredMaxLayoutWidth:SubjectWidth];
        _subjectLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _subjectLabel;
}

- (UIButton *)forumButton {
    if (!_forumButton) {
        _forumButton = [UIView createButton:CGRectZero text:@"" target:self action:@selector(buttonAction:)];
        [_forumButton setTitleColor:[UIColor GCBlueColor] forState:UIControlStateNormal];
        [_forumButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        _forumButton.titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return _forumButton;
}

- (UILabel *)lastPostDetailLabel {
    if (!_lastPostDetailLabel) {
        _lastPostDetailLabel = [UIView createLabel:CGRectZero
                                              text:@""
                                              font:[UIFont systemFontOfSize:13]
                                         textColor:[UIColor GCLightGrayFontColor]];
    }
    return _lastPostDetailLabel;
}

- (UILabel *)repliesLabel {
    if (!_repliesLabel) {
        _repliesLabel = [UIView createLabel:CGRectZero
                                       text:@""
                                       font:[UIFont systemFontOfSize:13]
                                  textColor:[UIColor GCLightGrayFontColor]];
        _repliesLabel.textAlignment = NSTextAlignmentRight;
    }
    return _repliesLabel;
}

@end
