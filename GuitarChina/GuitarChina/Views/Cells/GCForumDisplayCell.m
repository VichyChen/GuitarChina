//
//  GCForumDisplayCell.m
//  GuitarChina
//
//  Created by 陈大捷 on 15/9/4.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCForumDisplayCell.h"

@implementation GCForumDisplayCell

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

+ (CGFloat)getCellHeightWithModel:(GCForumThreadModel *)model {
    
    return 95;
}

#pragma mark - Setters

- (void)setModel:(GCForumThreadModel *)model {
    _model = model;
}

#pragma mark - Getters

@end
