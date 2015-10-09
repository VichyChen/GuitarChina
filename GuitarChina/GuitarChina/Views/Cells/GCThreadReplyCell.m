//
//  GCThreadReplyCell.m
//  GuitarChina
//
//  Created by 陈大捷 on 15/9/13.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCThreadReplyCell.h"

@interface GCThreadReplyCell()

//@property (nonatomic, strong) RTLabel *descriptLabel;

@end

@implementation GCThreadReplyCell

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
    
    self.descriptLabel.frame = CGRectMake(15, 60, ScreenWidth - 30, 250);

}

#pragma mark - Private Method

- (void)configureView {
    [self.contentView addSubview:self.descriptLabel];
}

#pragma mark - Class Method

+ (CGFloat)getCellHeightWithModel:(GCForumThreadModel *)model {
    
    return 95;
}

#pragma mark - Setters

//- (void)setModel:(GCForumThreadModel *)model {
//    _model = model;
//}

#pragma mark - Getters

- (RTLabel *)descriptLabel {
    if (!_descriptLabel) {
        _descriptLabel = [[RTLabel alloc] initWithFrame:CGRectMake(15, 10, ScreenWidth - 30, 0)];
        _descriptLabel.font = [UIFont systemFontOfSize:15];
        _descriptLabel.textColor = [UIColor LightFontColor];
        _descriptLabel.linkAttributes = @{@"color":@"red"};
        _descriptLabel.selectedLinkAttributes = @{@"color":@"red"};
    }
    return _descriptLabel;
}

@end
