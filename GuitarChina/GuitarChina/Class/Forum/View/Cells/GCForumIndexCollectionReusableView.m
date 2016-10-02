//
//  GCForumIndexCollectionReusableView.m
//  GuitarChina
//
//  Created by mac on 16/10/1.
//  Copyright © 2016年 陈大捷. All rights reserved.
//

#import "GCForumIndexCollectionReusableView.h"

@implementation GCForumIndexCollectionReusableView

- (void)awakeFromNib {
    [super awakeFromNib];

    self.titleLabel.textColor = [GCColor blueColor];
    if (ScreenWidth == 320) {
        self.titleLabel.font = [UIFont systemFontOfSize:15];
    }
}

@end
