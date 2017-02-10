//
//  GCMyPromptCell.m
//  GuitarChina
//
//  Created by mac on 17/1/19.
//  Copyright © 2017年 陈大捷. All rights reserved.
//

#import "GCMyPromptCell.h"
#import "UIView+LayoutHelper.h"

@interface GCMyPromptCell()

@property (nonatomic, strong) UILabel *remarkLabel;
@property (nonatomic, strong) UILabel *subjectLabel;
@property (nonatomic, strong) UILabel *timeLabel;

//标题高度
@property (nonatomic, assign) CGFloat subjectLabelHeight;

@end

@implementation GCMyPromptCell

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
    
    self.remarkLabel.frame = CGRectMake(15, 8, ScreenWidth - 30, 20);
    self.subjectLabel.frame = CGRectMake(15, 35, ScreenWidth - 30, self.subjectLabelHeight);
    self.timeLabel.frame = CGRectMake(15, 36 + self.subjectLabelHeight + 8, ScreenWidth - 30, 15);
}

#pragma mark - Private Method

- (void)configureView {
    [self.contentView addSubview:self.remarkLabel];
    [self.contentView addSubview:self.subjectLabel];
    [self.contentView addSubview:self.timeLabel];
}

#pragma mark - Setters

- (void)setModel:(GCMyPromptModel *)model {
    _model = model;
    
    self.remarkLabel.text = [NSString stringWithFormat:@"%@ %@", model.name, model.remarkString];
    self.subjectLabel.text = model.threadTitle;
    CGFloat subjectLabelHeight = [UIView calculateLabelHeightWithText:self.subjectLabel.text fontSize:self.subjectLabel.font.pointSize width:ScreenWidth - 30];
    self.subjectLabelHeight = subjectLabelHeight;
    self.timeLabel.text = model.time;
}

+ (CGFloat)getCellHeightWithModel:(GCMyPromptModel *)model {
    CGFloat subjectLabelHeight = [UIView calculateLabelHeightWithText:model.threadTitle fontSize:16 width:ScreenWidth - 30];
    return subjectLabelHeight + 66;
}

#pragma mark - Getters

- (UILabel *)remarkLabel {
    if (!_remarkLabel) {
        _remarkLabel = [[UILabel alloc] init];
        _remarkLabel.font = [UIFont systemFontOfSize:14];
        _remarkLabel.textColor = [GCColor grayColor2];
        _remarkLabel.numberOfLines = 0;
        _remarkLabel.preferredMaxLayoutWidth = ScreenWidth - 30;
        _remarkLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _remarkLabel;
}

- (UILabel *)subjectLabel {
    if (!_subjectLabel) {
        _subjectLabel = [[UILabel alloc] init];
        _subjectLabel.font = [UIFont systemFontOfSize:16];
        _subjectLabel.textColor = [GCColor fontColor];
        _subjectLabel.numberOfLines = 0;
        _subjectLabel.preferredMaxLayoutWidth = ScreenWidth - 30;
        _subjectLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _subjectLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:13];
        _timeLabel.textColor = [GCColor grayColor2];
        _timeLabel.numberOfLines = 0;
        _timeLabel.preferredMaxLayoutWidth = ScreenWidth - 30;
        _timeLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _timeLabel;
}

@end
