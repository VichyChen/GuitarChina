//
//  GCForumIndexCell.m
//  GuitarChina
//
//  Created by 陈大捷 on 15/9/4.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCForumIndexCell.h"
#import "RTLabel.h"
#import "UIView+LayoutHelper.h"

@interface GCForumIndexCell() <RTLabelDelegate>

@property (nonatomic, strong) UIImageView *forumImage;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *descriptLabel;
@property (nonatomic, strong) UILabel *forumDetailLabel;

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
    
    self.nameLabel.frame = CGRectMake(15, 10, ScreenWidth - 30, 20);
    self.forumDetailLabel.frame = CGRectMake(15, 35, ScreenWidth - 30, 20);
    self.descriptLabel.frame = CGRectMake(15, 60, ScreenWidth - 30, self.descriptLabelHeight);
}

#pragma mark RTLabel delegate

- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL*)url
{
    NSLog(@"did select url %@", url);
    [Util openUrlInSafari:url.absoluteString];
}

#pragma mark - Private Method

- (void)configureView {
    [self.contentView addSubview:self.forumImage];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.descriptLabel];
    [self.contentView addSubview:self.forumDetailLabel];
}

#pragma mark - Class Method

+ (CGFloat)getCellHeightWithModel:(GCForumModel *)model {
//    RTLabel *label = [[RTLabel alloc] initWithFrame:CGRectMake(15, 40, ScreenWidth - 30, 0)];
//    label.font = [UIFont systemFontOfSize:15];
//    label.text = model.descript;
//    CGSize labelSize = [label optimumSize];
    CGFloat descriptLabelHeight = [UIView calculateLabelHeightWithText:model.descript fontSize:16 width:ScreenWidth - 30];
    return descriptLabelHeight + 70;
    
//    return labelSize.height + 70;
}

#pragma mark - Setters

- (void)setModel:(GCForumModel *)model {
    _model = model;
    
    self.nameLabel.attributedText = model.nameString;
    self.descriptLabel.text = model.descript;
   CGFloat labelHeight = [UIView calculateLabelHeightWithText:self.descriptLabel.text fontSize:self.descriptLabel.font.pointSize width:ScreenWidth - 30];
    self.descriptLabelHeight = labelHeight;
    self.forumDetailLabel.attributedText = model.forumDetailString;
}

#pragma mark - Getters

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UIView createLabel:CGRectZero
                                    text:@""
                                    font:[UIFont boldSystemFontOfSize:17]
                               textColor:[UIColor GCBlueColor]];
    }
    return _nameLabel;
}

- (UILabel *)descriptLabel {
    if (!_descriptLabel) {
//        _descriptLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 40, ScreenWidth - 30, 0)];
//        _descriptLabel.font = [UIFont systemFontOfSize:16];
//        _descriptLabel.textColor = [UIColor GCFontColor];
////        _descriptLabel.linkAttributes = @{@"color":@"red"};
////        _descriptLabel.selectedLinkAttributes = @{@"color":@"red"};
        _descriptLabel = [UIView createLabel:CGRectZero
                                       text:@""
                                       font:[UIFont systemFontOfSize:16]
                                  textColor:[UIColor GCFontColor]
                              numberOfLines:0
                    preferredMaxLayoutWidth:ScreenWidth - 30];
        _descriptLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _descriptLabel;
}

- (UILabel *)forumDetailLabel {
    if (!_forumDetailLabel) {
        _forumDetailLabel = [UIView createLabel:CGRectZero
                                           text:@""
                                           font:[UIFont systemFontOfSize:14]
                                      textColor:[UIColor GCDeepGrayColor]];
    }
    return _forumDetailLabel;
}

@end