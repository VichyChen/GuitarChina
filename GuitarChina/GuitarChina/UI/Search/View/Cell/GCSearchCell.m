//
//  GCSearchCell.m
//  GuitarChina
//
//  Created by mac on 16/5/27.
//  Copyright © 2016年 陈大捷. All rights reserved.
//

#import "GCSearchCell.h"

#define kSubScreenWidth kScreenWidth - 26

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
//        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
//        self.selectedBackgroundView.backgroundColor = [GCColor cellSelectedColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
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
    self.subjectLabel.frame = CGRectMake(kMargin, kMargin, kSubScreenWidth, [self.subjectLabel sizeThatFits:CGSizeMake(kSubScreenWidth, 999)].height);
    self.replyLabel.frame = CGRectMake(kMargin, self.subjectLabel.frame.origin.y + self.subjectLabel.frame.size.height - 15, kSubScreenWidth, 20);
    self.contentLabel.frame = CGRectMake(kMargin, self.replyLabel.frame.origin.y + self.replyLabel.frame.size.height + 4, kSubScreenWidth, [self.contentLabel sizeThatFits:CGSizeMake(kSubScreenWidth, 999)].height);
    
    if (self.model.content.length == 0) {
        self.datelineLabel.frame = CGRectMake(kMargin, self.contentLabel.frame.origin.y + self.contentLabel.frame.size.height - 14 - 26, [self.datelineLabel sizeThatFits:CGSizeMake(kSubScreenWidth, 999)].width, 20);
    }
    else {
        self.datelineLabel.frame = CGRectMake(kMargin, self.contentLabel.frame.origin.y + self.contentLabel.frame.size.height - 14, [self.datelineLabel sizeThatFits:CGSizeMake(kSubScreenWidth, 999)].width, 20);
    }
    self.authorLabel.frame = CGRectMake(self.datelineLabel.frame.origin.x + self.datelineLabel.frame.size.width, self.datelineLabel.frame.origin.y, [self.authorLabel sizeThatFits:CGSizeMake(kSubScreenWidth, 999)].width, 20);
    self.forumLabel.frame = CGRectMake(self.authorLabel.frame.origin.x + self.authorLabel.frame.size.width, self.authorLabel.frame.origin.y, [self.forumLabel sizeThatFits:CGSizeMake(kSubScreenWidth, 999)].width, 20);
}

#pragma mark - Class Method

+ (CGFloat)getCellHeightWithModel:(GCSearchModel *)model {
    UILabel *subjectLabel = [[UILabel alloc] init];
    subjectLabel.font = [UIFont systemFontOfSize:15];
    subjectLabel.numberOfLines = 0;
    subjectLabel.preferredMaxLayoutWidth = kSubScreenWidth;
    subjectLabel.lineBreakMode = NSLineBreakByWordWrapping;
    subjectLabel.attributedText = model.attributedSubject;
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.font = [UIFont systemFontOfSize:15];
    contentLabel.textColor = [GCColor grayColor1];
    contentLabel.numberOfLines = 0;
    contentLabel.preferredMaxLayoutWidth = kSubScreenWidth;
    contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    contentLabel.attributedText = model.attributedContent;
    
    if (model.content.length == 0) {
        return [subjectLabel sizeThatFits:CGSizeMake(kSubScreenWidth, 999)].height + [contentLabel sizeThatFits:CGSizeMake(kSubScreenWidth, 999)].height + 42 - 26;
    }
    else {
        return [subjectLabel sizeThatFits:CGSizeMake(kSubScreenWidth, 999)].height + [contentLabel sizeThatFits:CGSizeMake(kSubScreenWidth, 999)].height + 42;
    }
}

#pragma mark - Event Responses


#pragma mark - Setters

- (void)setModel:(GCSearchModel *)model {
    _model = model;
    
    self.subjectLabel.attributedText = model.attributedSubject;
    self.replyLabel.text = [NSString stringWithFormat:@"%@  %@", model.dateline, model.author];
    self.contentLabel.attributedText = model.attributedContent;
    self.datelineLabel.text = [NSString stringWithFormat:@"%@，%@", model.forum, model.reply];
    self.authorLabel.text = @"";
    self.forumLabel.text = @"";
    
    [self configureFrame];
}

#pragma mark - Getters

- (UILabel *)subjectLabel {
    if (!_subjectLabel) {
        _subjectLabel = [[UILabel alloc] init];
        _subjectLabel.font = [UIFont systemFontOfSize:15];
        _subjectLabel.textColor = [GCColor grayColor1];
        _subjectLabel.numberOfLines = 0;
        _subjectLabel.preferredMaxLayoutWidth = kSubScreenWidth;
        _subjectLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _subjectLabel;
}

- (UILabel *)replyLabel {
    if (!_replyLabel) {
        _replyLabel = [[UILabel alloc] init];
        _replyLabel.font = [UIFont systemFontOfSize:12];
        _replyLabel.textColor = [GCColor grayColor3];
        _replyLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _replyLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = [UIFont systemFontOfSize:15];
        _contentLabel.textColor = [GCColor grayColor1];
        _contentLabel.numberOfLines = 0;
        _contentLabel.preferredMaxLayoutWidth = kSubScreenWidth;
        _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _contentLabel;
}

- (UILabel *)datelineLabel {
    if (!_datelineLabel) {
        _datelineLabel = [[UILabel alloc] init];
        _datelineLabel.font = [UIFont systemFontOfSize:12];
        _datelineLabel.textColor = [GCColor grayColor3];
    }
    return _datelineLabel;
}

- (UILabel *)authorLabel {
    if (!_authorLabel) {
        _authorLabel = [[UILabel alloc] init];
        _authorLabel.font = [UIFont systemFontOfSize:12];
        _authorLabel.textColor = [GCColor grayColor3];
    }
    return _authorLabel;
}

- (UILabel *)forumLabel {
    if (!_forumLabel) {
        _forumLabel = [[UILabel alloc] init];
        _forumLabel.font = [UIFont systemFontOfSize:12];
        _forumLabel.textColor = [GCColor grayColor3];
        _forumLabel.textAlignment = NSTextAlignmentRight;
    }
    return _forumLabel;
}


@end
