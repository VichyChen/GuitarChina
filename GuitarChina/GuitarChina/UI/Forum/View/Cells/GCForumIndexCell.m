//
//  GCForumIndexCell.m
//  GuitarChina
//
//  Created by 陈大捷 on 15/9/4.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCForumIndexCell.h"

@interface GCForumIndexCell()

@property (nonatomic, strong) UIImageView *forumImage;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *descriptLabel;
@property (nonatomic, strong) UILabel *todayPostCountLabel;
@property (nonatomic, strong) UIView *separatorView;

@end

@implementation GCForumIndexCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.clipsToBounds = YES;
        [self configureView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.nameLabel.frame = CGRectMake(kMargin, kMargin, kSubScreenWidth, 20);
    [self.nameLabel sizeToFit];
    self.todayPostCountLabel.frame = CGRectMake(self.nameLabel.frame.origin.x + self.nameLabel.frame.size.width + 5, kMargin, 100, 20);
    self.descriptLabel.frame = CGRectMake(kMargin, self.nameLabel.frame.origin.y + self.nameLabel.frame.size.height + 6, kSubScreenWidth, self.descriptLabelHeight);
    [self.descriptLabel sizeToFit];
    self.separatorView.frame = CGRectMake(kMargin, self.descriptLabel.frame.origin.y + self.descriptLabelHeight + kMargin, kSubScreenWidth, 0.5);
}

#pragma mark - Private Method

- (void)configureView {
    [self.contentView addSubview:self.forumImage];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.descriptLabel];
    [self.contentView addSubview:self.todayPostCountLabel];
    [self.contentView addSubview:self.separatorView];
}

#pragma mark - Class Method

+ (CGFloat)getCellHeightWithModel:(GCForumModel *)model {
//    if ([model respondsToSelector:@selector(descript)]) {
    if (model && [model isKindOfClass:[GCForumModel class]]) {
        CGFloat descriptLabelHeight = [UIView calculateLabelHeightWithText:model.descript fontSize:14 width:kSubScreenWidth];
        return kMargin + 20 + 6 + descriptLabelHeight + kMargin;
    } else {
        return 0;
    }
}

#pragma mark - Setters

- (void)setModel:(GCForumModel *)model {
    if ([model respondsToSelector:@selector(descript)]) {
        _model = model;
        
        self.nameLabel.text = model.name;
        self.todayPostCountLabel.text = [model.todayposts isEqualToString:@"0"] ? @"" : [NSString stringWithFormat:@"(%@)" , model.todayposts ];
        self.descriptLabel.text = model.descript;
        CGFloat labelHeight = [UIView calculateLabelHeightWithText:self.descriptLabel.text fontSize:self.descriptLabel.font.pointSize width:kSubScreenWidth];
        self.descriptLabelHeight = labelHeight;
        //    self.forumDetailLabel.attributedText = model.forumDetailString;
    }
}

#pragma mark - Getters

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:15];
        _nameLabel.textColor = [GCColor fontColor];
    }
    return _nameLabel;
}

- (UILabel *)todayPostCountLabel {
    if (!_todayPostCountLabel) {
        _todayPostCountLabel = [[UILabel alloc] init];
        _todayPostCountLabel.font = [UIFont systemFontOfSize:15];
        _todayPostCountLabel.textColor = [GCColor grayColor2];
    }
    return _todayPostCountLabel;
}

- (UILabel *)descriptLabel {
    if (!_descriptLabel) {
        _descriptLabel = [[UILabel alloc] init];
        _descriptLabel.font = [UIFont systemFontOfSize:14];
        _descriptLabel.textColor = [GCColor grayColor3];
        _descriptLabel.numberOfLines = 0;
        _descriptLabel.preferredMaxLayoutWidth = kScreenWidth - 30;
        _descriptLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _descriptLabel;
}

- (UIView *)separatorView {
    if (!_separatorView) {
        _separatorView = [[UIView alloc] init];
        _separatorView.backgroundColor = [GCColor separatorLineColor];
    }
    return _separatorView;
}


@end
