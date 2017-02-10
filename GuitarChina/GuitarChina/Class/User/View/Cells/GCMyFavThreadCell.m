//
//  GCMyFavThreadCell.m
//  GuitarChina
//
//  Created by mac on 15/10/28.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCMyFavThreadCell.h"
#import "UIView+LayoutHelper.h"

#define SubjectWidth ScreenWidth - 30

@interface GCMyFavThreadCell()

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
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
        self.selectedBackgroundView.backgroundColor = [GCColor cellSelectedColor];
        [self configureView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.authorLabel.frame = CGRectMake(15, 8, ScreenWidth - 70, 20);
    self.datelineLabel.frame = CGRectMake(15, 33, ScreenWidth - 70, 20);
    self.subjectLabel.frame = CGRectMake(15, 60, SubjectWidth, self.subjectLabelHeight);
    self.repliesLabel.frame = CGRectMake(15, 8, SubjectWidth, 20);
}

#pragma mark - Private Method

- (void)configureView {
    [self.contentView addSubview:self.authorLabel];
    [self.contentView addSubview:self.datelineLabel];
    [self.contentView addSubview:self.repliesLabel];
    [self.contentView addSubview:self.subjectLabel];
}

#pragma mark - Class Method

+ (CGFloat)getCellHeightWithModel:(GCMyFavThreadModel *)model {
    CGFloat subjectLabelHeight = [UIView calculateLabelHeightWithText:model.title fontSize:16 width:SubjectWidth];
    return subjectLabelHeight + 70;
}

#pragma mark - Setters

- (void)setModel:(GCMyFavThreadModel *)model {
    _model = model;
    
    self.authorLabel.text = model.author;
    self.datelineLabel.text = [Util getDateStringWithTimeStamp:model.dateline format:@"yyyy-MM-dd HH:mm"];
    self.subjectLabel.text = model.title;
    CGFloat subjectLabelHeight = [UIView calculateLabelHeightWithText:self.subjectLabel.text fontSize:self.subjectLabel.font.pointSize width:SubjectWidth];
    self.subjectLabelHeight = subjectLabelHeight;
    self.repliesLabel.attributedText = model.repliesString;
}

#pragma mark - Getters

- (UILabel *)authorLabel {
    if (!_authorLabel) {
        _authorLabel = [[UILabel alloc] init];
        _authorLabel.font = [UIFont systemFontOfSize:15];
        _authorLabel.textColor = [GCColor fontColor];
    }
    return _authorLabel;
}

- (UILabel *)datelineLabel {
    if (!_datelineLabel) {
        _datelineLabel = [[UILabel alloc] init];
        _datelineLabel.font = [UIFont systemFontOfSize:14];
        _datelineLabel.textColor = [GCColor grayColor2];
    }
    return _datelineLabel;
}

- (UILabel *)subjectLabel {
    if (!_subjectLabel) {
        _subjectLabel = [[UILabel alloc] init];
        _subjectLabel.font = [UIFont systemFontOfSize:16];
        _subjectLabel.textColor = [GCColor fontColor];
        _subjectLabel.numberOfLines = 0;
        _subjectLabel.preferredMaxLayoutWidth = SubjectWidth;
        _subjectLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _subjectLabel;
}

- (UILabel *)repliesLabel {
    if (!_repliesLabel) {
        _repliesLabel = [[UILabel alloc] init];
        _repliesLabel.font = [UIFont systemFontOfSize:14];
        _repliesLabel.textColor = [GCColor grayColor2];
        _repliesLabel.textAlignment = NSTextAlignmentRight;
    }
    return _repliesLabel;
}

@end
