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
    [self.contentView addSubview:self.deleteButton];
}

- (void)configureFrame {
    self.imageView.frame = CGRectMake(0, 0, (ScreenWidth - 10 * 4) / 3, (ScreenWidth - 10 * 4) / 3);
    self.deleteButton.frame = CGRectMake(self.frame.size.width - 28, 3, 25, 25);
    self.deleteButton.layer.cornerRadius = 12.5;
}

- (void)deleteAction {
    if (self.deleteActionBlock) {
        self.deleteActionBlock();
    }
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

- (UIButton *)deleteButton {
    if (!_deleteButton) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteButton.backgroundColor = [UIColor whiteColor];
        [_deleteButton setImage:[[UIImage imageNamed:@"icon_delete"] imageWithTintColor:[GCColor grayColor2]] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
        _deleteButton.clipsToBounds = YES;
    }
    
    return _deleteButton;
}

@end
