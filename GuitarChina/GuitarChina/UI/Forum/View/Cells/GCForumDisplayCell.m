//
//  GCForumDisplayCell.m
//  GuitarChina
//
//  Created by 陈大捷 on 15/9/4.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCForumDisplayCell.h"

#define kSubScreenWidth kScreenWidth - 30

@interface GCForumDisplayCell()

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *authorLabel;
@property (nonatomic, strong) UILabel *datelineLabel;
@property (nonatomic, strong) UILabel *subjectLabel;
@property (nonatomic, strong) UILabel *lastPostDetailLabel;
@property (nonatomic, strong) UILabel *repliesLabel;

//标题高度
@property (nonatomic, assign) CGFloat subjectLabelHeight;

@end

@implementation GCForumDisplayCell

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
    
    self.avatarImageView.frame = CGRectMake(kMargin, kMargin, 40, 40);
    self.authorLabel.frame = CGRectMake(65, 14, kScreenWidth - 65, 20);
    self.datelineLabel.frame = CGRectMake(65, 38, kScreenWidth - 65, 20);
    self.subjectLabel.frame = CGRectMake(kMargin, 65, kSubScreenWidth, self.subjectLabelHeight);
    self.lastPostDetailLabel.frame = CGRectMake(kMargin, 72 + self.subjectLabelHeight, kSubScreenWidth, 16);
    self.repliesLabel.frame = CGRectMake(kMargin, 13, kSubScreenWidth, 20);
}

#pragma mark - Private Method

- (void)configureView {
    [self.contentView addSubview:self.avatarImageView];
    [self.contentView addSubview:self.authorLabel];
    [self.contentView addSubview:self.datelineLabel];
    [self.contentView addSubview:self.subjectLabel];
    [self.contentView addSubview:self.lastPostDetailLabel];
    [self.contentView addSubview:self.repliesLabel];
}

#pragma mark - Class Method

+ (CGFloat)getCellHeightWithModel:(GCForumThreadModel *)model {
    CGFloat subjectLabelHeight = [UIView calculateLabelHeightWithText:model.subject fontSize:15 width:kSubScreenWidth];
    return subjectLabelHeight + 103;
}

#pragma mark - Setters

- (void)setModel:(GCForumThreadModel *)model {
    _model = model;
    
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:GCNetworkAPI_URL_SmallAvatarImage(model.authorid)]
                        placeholderImage:DefaultAvator
                                 options:SDWebImageRetryFailed];
    self.authorLabel.text = model.author;
    self.datelineLabel.text = model.dateline;
    self.subjectLabel.text = model.subject;
    CGFloat subjectLabelHeight = [UIView calculateLabelHeightWithText:self.subjectLabel.text fontSize:self.subjectLabel.font.pointSize width:kSubScreenWidth];
    self.subjectLabelHeight = subjectLabelHeight;
    self.lastPostDetailLabel.attributedText = model.lastPosterDetailString;
    self.repliesLabel.attributedText = model.replyAndViewDetailString;
}

#pragma mark - Getters

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.contentMode = UIViewContentModeScaleToFill;
        _avatarImageView.clipsToBounds = YES;
        _avatarImageView.layer.cornerRadius = kCornerRadius;
        _avatarImageView.userInteractionEnabled = YES;

        @weakify(self);
        [_avatarImageView bk_whenTapped:^{
            @strongify(self);
            if (self.avatarImageViewBlock) {
                self.avatarImageViewBlock();
            }
        }];
    }
    return _avatarImageView;
}

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
        _datelineLabel.font = [UIFont systemFontOfSize:12];
        _datelineLabel.textColor = [GCColor grayColor3];
    }
    return _datelineLabel;
}

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

- (UILabel *)lastPostDetailLabel {
    if (!_lastPostDetailLabel) {
        _lastPostDetailLabel = [[UILabel alloc] init];
        _lastPostDetailLabel.font = [UIFont systemFontOfSize:12];
        _lastPostDetailLabel.textColor = [GCColor grayColor3];
    }
    return _lastPostDetailLabel;
}

- (UILabel *)repliesLabel {
    if (!_repliesLabel) {
        _repliesLabel = [[UILabel alloc] init];
        _repliesLabel.font = [UIFont systemFontOfSize:12];
        _repliesLabel.textColor = [GCColor grayColor3];
        _repliesLabel.textAlignment = NSTextAlignmentRight;
    }
    return _repliesLabel;
}

@end
