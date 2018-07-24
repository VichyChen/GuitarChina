//
//  GCMyThreadCell.m
//  GuitarChina
//
//  Created by mac on 15/10/28.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCMyThreadCell.h"

#define kSubScreenWidth kScreenWidth - 30

@interface GCMyThreadCell()

@property (nonatomic, strong) UILabel *subjectLabel;
@property (nonatomic, strong) UILabel *datelineLabel;
@property (nonatomic, strong) UILabel *repliesLabel;

//标题高度
@property (nonatomic, assign) CGFloat subjectLabelHeight;

@end

@implementation GCMyThreadCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
        //        self.selectedBackgroundView.backgroundColor = [GCColor cellSelectedColor];
        [self configureView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.datelineLabel.frame = CGRectMake(kMargin, 10, kSubScreenWidth, 20);
    self.repliesLabel.frame = CGRectMake(kMargin, 10, kSubScreenWidth, 20);
    self.subjectLabel.frame = CGRectMake(kMargin, 40, kSubScreenWidth, self.subjectLabelHeight);
}

#pragma mark - Private Method

- (void)configureView {
    [self.contentView addSubview:self.subjectLabel];
    [self.contentView addSubview:self.datelineLabel];
    [self.contentView addSubview:self.repliesLabel];
}

#pragma mark - Class Method

+ (CGFloat)getCellHeightWithModel:(GCMyThreadModel *)model {
    CGFloat subjectLabelHeight = [UIView calculateLabelHeightWithText:model.subject fontSize:15 width:kSubScreenWidth];
    return subjectLabelHeight + 50;
}

#pragma mark - Setters

- (void)setModel:(GCMyThreadModel *)model {
    _model = model;
    
    self.datelineLabel.text = model.dateline;
    self.subjectLabel.text = model.subject;
    CGFloat subjectLabelHeight = [UIView calculateLabelHeightWithText:self.subjectLabel.text fontSize:self.subjectLabel.font.pointSize width:kSubScreenWidth];
    self.subjectLabelHeight = subjectLabelHeight;
    self.repliesLabel.attributedText = model.replyAndViewDetailString;
}

#pragma mark - Getters

- (UILabel *)subjectLabel {
    if (!_subjectLabel) {
        _subjectLabel = [[UILabel alloc] init];
        _subjectLabel.font = [UIFont systemFontOfSize:15];
        _subjectLabel.textColor = [GCColor fontColor];
        _subjectLabel.numberOfLines = 0;
        _subjectLabel.preferredMaxLayoutWidth = kSubScreenWidth;
        _subjectLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _subjectLabel;
}

- (UILabel *)datelineLabel {
    if (!_datelineLabel) {
        _datelineLabel = [[UILabel alloc] init];
        _datelineLabel.font = [UIFont systemFontOfSize:13];
        _datelineLabel.textColor = [GCColor grayColor2];
    }
    return _datelineLabel;
}

- (UILabel *)repliesLabel {
    if (!_repliesLabel) {
        _repliesLabel = [[UILabel alloc] init];
        _repliesLabel.font = [UIFont systemFontOfSize:13];
        _repliesLabel.textColor = [GCColor grayColor2];
        _repliesLabel.textAlignment = NSTextAlignmentRight;
    }
    return _repliesLabel;
}

@end
