//
//  GCDiscoveryCell.m
//  GuitarChina
//
//  Created by 陈大捷 on 16/4/10.
//  Copyright © 2016年 陈大捷. All rights reserved.
//

#import "GCDiscoveryCell.h"

@implementation GCDiscoveryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
        self.selectedBackgroundView.backgroundColor = [UIColor GCCellSelectedBackgroundColor];
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

+ (CGFloat)getCellHeightWithModel:(GCGuideThreadModel *)model {
    return 200;
}

#pragma mark - Setters

- (void)setModel:(GCGuideThreadModel *)model {
    _model = model;
    
}

@end
