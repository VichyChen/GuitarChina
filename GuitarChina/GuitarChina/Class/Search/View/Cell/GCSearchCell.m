//
//  GCSearchCell.m
//  GuitarChina
//
//  Created by mac on 16/5/27.
//  Copyright © 2016年 陈大捷. All rights reserved.
//

#import "GCSearchCell.h"

#define SubjectWidth ScreenWidth - 26

@interface GCSearchCell()

@property (nonatomic, strong) UILabel *authorLabel;
@property (nonatomic, strong) UILabel *datelineLabel;
@property (nonatomic, strong) UILabel *subjectLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *forumLabel;
@property (nonatomic, strong) UILabel *replyLabel;

//标题高度
@property (nonatomic, assign) CGFloat subjectLabelHeight;

@end

@implementation GCSearchCell

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
}

#pragma mark - Private Method

- (void)configureView {
    [self.contentView addSubview:self.authorLabel];
    [self.contentView addSubview:self.datelineLabel];
    [self.contentView addSubview:self.subjectLabel];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.forumLabel];
    [self.contentView addSubview:self.replyLabel];
}

- (void)configureFrame {
    self.subjectLabel.frame = CGRectMake(13, 10, SubjectWidth, [self.subjectLabel sizeThatFits:CGSizeMake(SubjectWidth, 999)].height);
    self.replyLabel.frame = CGRectMake(13, self.subjectLabel.frame.origin.y + self.subjectLabel.frame.size.height - 15, SubjectWidth, 20);
    self.contentLabel.frame = CGRectMake(13, self.replyLabel.frame.origin.y + self.replyLabel.frame.size.height + 4, SubjectWidth, [self.contentLabel sizeThatFits:CGSizeMake(SubjectWidth, 999)].height);
    
    if (self.model.content.length == 0) {
        self.datelineLabel.frame = CGRectMake(13, self.contentLabel.frame.origin.y + self.contentLabel.frame.size.height - 14 - 26, [self.datelineLabel sizeThatFits:CGSizeMake(SubjectWidth, 999)].width, 20);
    }
    else {
        self.datelineLabel.frame = CGRectMake(13, self.contentLabel.frame.origin.y + self.contentLabel.frame.size.height - 14, [self.datelineLabel sizeThatFits:CGSizeMake(SubjectWidth, 999)].width, 20);
    }
    self.authorLabel.frame = CGRectMake(self.datelineLabel.frame.origin.x + self.datelineLabel.frame.size.width, self.datelineLabel.frame.origin.y, [self.authorLabel sizeThatFits:CGSizeMake(SubjectWidth, 999)].width, 20);
    self.forumLabel.frame = CGRectMake(self.authorLabel.frame.origin.x + self.authorLabel.frame.size.width, self.authorLabel.frame.origin.y, [self.forumLabel sizeThatFits:CGSizeMake(SubjectWidth, 999)].width, 20);
}

#pragma mark - Class Method

+ (CGFloat)getCellHeightWithModel:(GCSearchModel *)model {
    UILabel *subjectLabel = [UIView createLabel:CGRectZero
                                   text:@""
                                   font:[UIFont systemFontOfSize:15]
                              textColor:[UIColor GCDarkGrayFontColor]
                          numberOfLines:0
                preferredMaxLayoutWidth:SubjectWidth];
    subjectLabel.lineBreakMode = NSLineBreakByWordWrapping;
    subjectLabel.attributedText = model.attributedSubject;
    
    UILabel *contentLabel = [UIView createLabel:CGRectZero
                                   text:@""
                                   font:[UIFont systemFontOfSize:15]
                              textColor:[UIColor GCDarkGrayFontColor]
                          numberOfLines:0
                preferredMaxLayoutWidth:SubjectWidth];
    contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    contentLabel.attributedText = model.attributedContent;
    
    if (model.content.length == 0) {
        return [subjectLabel sizeThatFits:CGSizeMake(SubjectWidth, 999)].height + [contentLabel sizeThatFits:CGSizeMake(SubjectWidth, 999)].height + 32 - 26;
    }
    else {
        return [subjectLabel sizeThatFits:CGSizeMake(SubjectWidth, 999)].height + [contentLabel sizeThatFits:CGSizeMake(SubjectWidth, 999)].height + 32;
    }
}

#pragma mark - Event Responses


#pragma mark - Setters

- (void)setModel:(GCSearchModel *)model {
    _model = model;
    
    self.subjectLabel.attributedText = model.attributedSubject;
    self.replyLabel.text = model.reply;
    self.contentLabel.attributedText = model.attributedContent;
    self.datelineLabel.text = [NSString stringWithFormat:@"%@ - ", model.dateline];
    self.authorLabel.text = [NSString stringWithFormat:@"%@ - ", model.author];
    self.forumLabel.text = model.forum;
    
    [self configureFrame];
}

#pragma mark - Getters

- (UILabel *)subjectLabel {
    if (!_subjectLabel) {
        _subjectLabel = [UIView createLabel:CGRectZero
                                       text:@""
                                       font:[UIFont systemFontOfSize:15]
                                  textColor:[UIColor GCDarkGrayFontColor]
                              numberOfLines:0
                    preferredMaxLayoutWidth:SubjectWidth];
        _subjectLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _subjectLabel;
}

- (UILabel *)replyLabel {
    if (!_replyLabel) {
        _replyLabel = [UIView createLabel:CGRectZero
                                     text:@""
                                     font:[UIFont systemFontOfSize:12]
                                textColor:[UIColor GCLightGrayFontColor]];
        _replyLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _replyLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [UIView createLabel:CGRectZero
                                       text:@""
                                       font:[UIFont systemFontOfSize:15]
                                  textColor:[UIColor GCDarkGrayFontColor]
                              numberOfLines:0
                    preferredMaxLayoutWidth:SubjectWidth];
        _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _contentLabel;
}

- (UILabel *)datelineLabel {
    if (!_datelineLabel) {
        _datelineLabel = [UIView createLabel:CGRectZero
                                        text:@""
                                        font:[UIFont systemFontOfSize:12]
                                   textColor:[UIColor GCLightGrayFontColor]];
    }
    return _datelineLabel;
}

- (UILabel *)authorLabel {
    if (!_authorLabel) {
        _authorLabel = [UIView createLabel:CGRectZero
                                      text:@""
                                      font:[UIFont systemFontOfSize:12]
                                 textColor:[UIColor GCLightGrayFontColor]];
    }
    return _authorLabel;
}

- (UILabel *)forumLabel {
    if (!_forumLabel) {
        _forumLabel = [UIView createLabel:CGRectZero
                                     text:@""
                                     font:[UIFont systemFontOfSize:12]
                                textColor:[UIColor GCLightGrayFontColor]];
        _forumLabel.textAlignment = NSTextAlignmentRight;
    }
    return _forumLabel;
}


@end
