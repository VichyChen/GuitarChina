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
    
    self.remarkLabel.frame = CGRectMake(15, 10, ScreenWidth - 30, 20);
    self.subjectLabel.frame = CGRectMake(15, 40, ScreenWidth - 30, self.subjectLabelHeight);
}

#pragma mark - Private Method

- (void)configureView {
    [self.contentView addSubview:self.remarkLabel];
    [self.contentView addSubview:self.subjectLabel];
}

#pragma mark - Setters

- (void)setModel:(GCMyPromptModel *)model {
    _model = model;
    
    self.remarkLabel.text = [NSString stringWithFormat:@"%@ %@", model.name, model.remarkString];
    self.subjectLabel.text = model.threadTitle;
    CGFloat subjectLabelHeight = [UIView calculateLabelHeightWithText:self.subjectLabel.text fontSize:self.subjectLabel.font.pointSize width:ScreenWidth - 30];
    self.subjectLabelHeight = subjectLabelHeight;
}

+ (CGFloat)getCellHeightWithModel:(GCMyPromptModel *)model {
    CGFloat subjectLabelHeight = [UIView calculateLabelHeightWithText:model.threadTitle fontSize:16 width:ScreenWidth - 30];
    return subjectLabelHeight + 50;
}

#pragma mark - Getters

- (UILabel *)remarkLabel {
    if (!_remarkLabel) {
        _remarkLabel = [UIView createLabel:CGRectZero
                                       text:@""
                                       font:[UIFont systemFontOfSize:14]
                                  textColor:[GCColor grayColor2]
                              numberOfLines:0
                    preferredMaxLayoutWidth:ScreenWidth - 30];
        _remarkLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _remarkLabel;
}

- (UILabel *)subjectLabel {
    if (!_subjectLabel) {
        _subjectLabel = [UIView createLabel:CGRectZero
                                       text:@""
                                       font:[UIFont systemFontOfSize:16]
                                  textColor:[GCColor fontColor]
                              numberOfLines:0
                    preferredMaxLayoutWidth:ScreenWidth - 30];
        _subjectLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _subjectLabel;
}

@end
