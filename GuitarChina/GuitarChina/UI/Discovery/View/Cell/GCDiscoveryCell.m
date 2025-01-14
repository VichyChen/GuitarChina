//
//  GCDiscoveryCell.m
//  GuitarChina
//
//  Created by 陈大捷 on 16/4/10.
//  Copyright © 2016年 陈大捷. All rights reserved.
//

#import "GCDiscoveryCell.h"
#import "GCForumDisplayViewController.h"

@interface GCDiscoveryCell()

@property (nonatomic, strong) UIImageView *avatarImageView;
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
        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
//        self.selectedBackgroundView.backgroundColor = [GCColor cellSelectedColor];
        [self configureView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.avatarImageView.frame = CGRectMake(kMargin, kMargin, 40, 40);
    self.authorLabel.frame = CGRectMake(kMargin + 40 + 10, kMargin, kScreenWidth - (kMargin + 40 + 10), 20);
    self.datelineLabel.frame = CGRectMake(self.authorLabel.frame.origin.x, 35, self.authorLabel.frame.size.width, 20);
    self.repliesLabel.frame = CGRectMake(kMargin, kMargin, kSubScreenWidth, 20);
    self.subjectLabel.frame = CGRectMake(kMargin, self.avatarImageView.frame.origin.y + self.avatarImageView.frame.size.height + 10, kSubScreenWidth, self.subjectLabelHeight);
    self.forumButton.frame = CGRectMake(kMargin, self.subjectLabel.frame.origin.y + self.subjectLabelHeight + 2, kSubScreenWidth, 26);
    [self.forumButton sizeToFit];
    self.lastPostDetailLabel.frame = CGRectMake(kMargin, self.forumButton.frame.origin.y + self.forumButton.frame.size.height + 2, kSubScreenWidth, 16);
}

#pragma mark - Private Method

- (void)configureView {
    [self.contentView addSubview:self.avatarImageView];
    [self.contentView addSubview:self.authorLabel];
    [self.contentView addSubview:self.datelineLabel];
    [self.contentView addSubview:self.subjectLabel];
    [self.contentView addSubview:self.forumButton];
    [self.contentView addSubview:self.lastPostDetailLabel];
    [self.contentView addSubview:self.repliesLabel];
}

#pragma mark - Class Method

+ (CGFloat)getCellHeightWithModel:(GCGuideThreadModel *)model {
    CGFloat subjectLabelHeight = [UIView calculateLabelHeightWithText:model.subject fontSize:15 width:kSubScreenWidth];
    return subjectLabelHeight + 115 + 10;
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
    
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:GCNetworkAPI_URL_SmallAvatarImage(model.authorid)]
                        placeholderImage:DefaultAvator
                                 options:SDWebImageRetryFailed];
    self.authorLabel.text = model.author;
    self.datelineLabel.text = model.dateline;
    self.subjectLabel.text = model.subject;
    CGFloat subjectLabelHeight = [UIView calculateLabelHeightWithText:self.subjectLabel.text fontSize:self.subjectLabel.font.pointSize width:kSubScreenWidth];
    self.subjectLabelHeight = subjectLabelHeight;
    [self.forumButton setTitle:model.forum forState:UIControlStateNormal];
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

- (UIButton *)forumButton {
    if (!_forumButton) {
        _forumButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_forumButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_forumButton setTitleColor:[GCColor blueColor] forState:UIControlStateNormal];
        [_forumButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        _forumButton.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _forumButton;
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
