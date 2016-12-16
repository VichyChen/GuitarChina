//
//  GCAddImageCell.m
//  GuitarChina
//
//  Created by mac on 16/11/8.
//  Copyright © 2016年 陈大捷. All rights reserved.
//

#import "GCAddImageCell.h"

@implementation GCAddImageCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configureView];
        [self configureFrame];
    }
    return self;
}

- (void)configureView {
    [self.contentView addSubview:self.imageView];
}

- (void)configureFrame {
    self.imageView.frame = CGRectMake(0, 0, (ScreenWidth - 10 * 5) / 4, (ScreenWidth - 10 * 5) / 4);
}

#pragma mark - Getters

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    
    return _imageView;
}

@end
