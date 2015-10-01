//
//  GCForumIndexCell.m
//  GuitarChina
//
//  Created by 陈大捷 on 15/9/4.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "GCForumIndexCell.h"
#import "RTLabel.h"

@interface GCForumIndexCell() <RTLabelDelegate>

@property (nonatomic, strong) UIImageView *forumImage;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) RTLabel *descriptLabel;

@property (nonatomic, strong) UILabel *threadAndPostLabel;

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
    
    self.nameLabel.frame = CGRectMake(15, 15, ScreenWidth - 30, 20);
    
    self.descriptLabel.frame = CGRectMake(15, 40, ScreenWidth - 30, 80);
}

#pragma mark RTLabel delegate

- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL*)url
{
    NSLog(@"did select url %@", url);
}

#pragma mark - Private Method

- (void)configureView {
    [self.contentView addSubview:self.forumImage];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.descriptLabel];
    [self.contentView addSubview:self.threadAndPostLabel];
    
    self.descriptLabel.delegate = self;
}

#pragma mark - Class Method

+ (CGFloat)getCellHeightWithModel:(GCForumModel *)model {
    return 95;
}

#pragma mark - Setters

- (void)setModel:(GCForumModel *)model {
    _model = model;
    
    self.nameLabel.text = model.name;
    
//    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithData:[model.descript dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
//    self.descriptLabel.attributedText = attrStr;
    
    self.descriptLabel.text = model.descript;
}

#pragma mark - Getters

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [UIView createLabel:CGRectZero
                                    text:@""
                                    font:[UIFont systemFontOfSize:16]
                               textColor:[UIColor FontColor]];
    }
    return _nameLabel;
}

//- (UILabel *)descriptLabel {
//    if (_descriptLabel == nil) {
//        _descriptLabel = [UIView createLabel:CGRectZero
//                                        text:@""
//                                        font:[UIFont systemFontOfSize:16]
//                                   textColor:[UIColor FontColor]
//                               numberOfLines:0
//                     preferredMaxLayoutWidth:ScreenWidth - 30];
//        _descriptLabel.lineBreakMode = NSLineBreakByWordWrapping;
//        _descriptLabel.backgroundColor = [UIColor redColor];
//    }
//    return _descriptLabel;
//}

- (RTLabel *)descriptLabel {
    if (_descriptLabel == nil) {
        _descriptLabel = [[RTLabel alloc] initWithFrame:CGRectZero];
        _descriptLabel.textColor = [UIColor LightFontColor];
        _descriptLabel.linkAttributes = @{@"color":@"red"};
        _descriptLabel.selectedLinkAttributes = @{@"color":@"red"};


    }
    return _descriptLabel;
}

- (UILabel *)threadAndPostLabel {
    if (_threadAndPostLabel == nil) {
        _threadAndPostLabel = [UIView createLabel:CGRectZero
                                             text:@""
                                             font:[UIFont systemFontOfSize:16]
                                        textColor:[UIColor FontColor]];
    }
    return _threadAndPostLabel;
}

@end
