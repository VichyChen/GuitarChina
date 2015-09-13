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
@property (nonatomic, strong) UILabel *authorLabel;
//@property (nonatomic, strong) UILabel *authorLabel;

@end

@implementation GCForumIndexCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configureView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

#pragma mark - Private Method

- (void)configureView {
}

#pragma mark - Class Method

+ (CGFloat)getCellHeightWithModel:(GCForumModel *)model {

    return 95;
}

#pragma mark - Setters

- (void)setModel:(GCForumModel *)model {
    _model = model;
}

#pragma mark - Getters

@end
