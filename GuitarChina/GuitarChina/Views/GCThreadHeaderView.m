//
//  GCThreadHeaderView.m
//  GuitarChina
//
//  Created by mac on 15/9/16.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCThreadHeaderView.h"

@interface GCThreadHeaderView()

@property (nonatomic, strong) UILabel *subjectLabel;
@property (nonatomic, strong) UILabel *authorLabel;
@property (nonatomic, strong) UILabel *datelineLabel;
@property (nonatomic, strong) UILabel *viewsLabel;
@property (nonatomic, strong) UILabel *repliesLabel;

@end

@implementation GCThreadHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self configureView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

#pragma mark - Private Methods

- (void)configureView {
    [self addSubview:self.subjectLabel];
    [self addSubview:self.authorLabel];
    [self addSubview:self.datelineLabel];
    [self addSubview:self.viewsLabel];
    [self addSubview:self.repliesLabel];
}

- (void)layoutFrame {
    self.subjectLabel.frame = CGRectMake(10, 10, ScreenWidth, 20);
    self.authorLabel.frame = CGRectMake(10, 40, ScreenWidth, 20);
    self.datelineLabel.frame = CGRectMake(10, 70, ScreenWidth, 20);
    self.viewsLabel.frame = CGRectMake(10, 100, ScreenWidth, 20);
    self.repliesLabel.frame = CGRectMake(10, 130, ScreenWidth, 20);
    
    self.frame = CGRectMake(0, 0, ScreenWidth, 160);
}

#pragma mark - Setters

- (void)setForumThreadModel:(GCForumThreadModel *)forumThreadModel {
    _forumThreadModel = forumThreadModel;
    self.subjectLabel.text = forumThreadModel.subject;
    self.authorLabel.text = forumThreadModel.author;
    self.datelineLabel.text = forumThreadModel.dateline;
    self.viewsLabel.text = forumThreadModel.views;
    self.repliesLabel.text = forumThreadModel.replies;
    
    [self layoutFrame];
}

- (void)setHotThreadModel:(GCHotThreadModel *)hotThreadModel {
    _hotThreadModel = hotThreadModel;
    self.subjectLabel.text = hotThreadModel.subject;
    self.authorLabel.text = hotThreadModel.author;
    self.datelineLabel.text = hotThreadModel.dateline;
    self.viewsLabel.text = hotThreadModel.views;
    self.repliesLabel.text = hotThreadModel.replies;
    
    [self layoutFrame];
}


#pragma mark - Getters

- (UILabel *)subjectLabel {
    if (!_subjectLabel) {
        _subjectLabel = [UIView createLabel:CGRectZero
                                      text:@""
                                      font:[UIFont systemFontOfSize:16]
                                 textColor:[UIColor FontColor]];
    }
    return _subjectLabel;
}

- (UILabel *)authorLabel {
    if (!_authorLabel) {
        _authorLabel = [UIView createLabel:CGRectZero
                                      text:@""
                                      font:[UIFont systemFontOfSize:16]
                                 textColor:[UIColor FontColor]];
    }
    return _authorLabel;
}

- (UILabel *)datelineLabel {
    if (!_datelineLabel) {
        _datelineLabel = [UIView createLabel:CGRectZero
                                      text:@""
                                      font:[UIFont systemFontOfSize:16]
                                 textColor:[UIColor FontColor]];
    }
    return _datelineLabel;
}

- (UILabel *)viewsLabel {
    if (!_viewsLabel) {
        _viewsLabel = [UIView createLabel:CGRectZero
                                      text:@""
                                      font:[UIFont systemFontOfSize:16]
                                 textColor:[UIColor FontColor]];
    }
    return _viewsLabel;
}

- (UILabel *)repliesLabel {
    if (!_repliesLabel) {
        _repliesLabel = [UIView createLabel:CGRectZero
                                      text:@""
                                      font:[UIFont systemFontOfSize:16]
                                 textColor:[UIColor FontColor]];
    }
    return _repliesLabel;
}

@end
