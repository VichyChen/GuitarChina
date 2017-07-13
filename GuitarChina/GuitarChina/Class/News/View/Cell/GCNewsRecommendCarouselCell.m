//
//  GCNewsRecommendCarouselCell.m
//  GuitarChina
//
//  Created by mac on 2017/7/12.
//  Copyright © 2017年 陈大捷. All rights reserved.
//

#import "GCNewsRecommendCarouselCell.h"

@interface GCNewsRecommendCarouselCell() <SDCycleScrollViewDelegate>

@end

@implementation GCNewsRecommendCarouselCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configureView];
    }
    return self;
}

- (void)configureView {
    self.imgScrollView = [[SDCycleScrollView alloc] init];
    self.imgScrollView.frame = CGRectMake(0, 0, ScreenWidth, ScreenWidth * 0.6);
    self.imgScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleNone;
    self.imgScrollView.delegate = self;
    self.imgScrollView.autoScroll = NO;
    self.imgScrollView.titleLabelTextFont = [UIFont systemFontOfSize:16];
        _imgScrollView.placeholderImage = DefaultImage;
    self.imgScrollView.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.contentView addSubview:self.imgScrollView];
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    if (self.didSelectItemBlock) {
        self.didSelectItemBlock(index);
    }
}


@end
