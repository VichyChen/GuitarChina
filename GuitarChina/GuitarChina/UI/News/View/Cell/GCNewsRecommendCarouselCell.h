//
//  GCNewsRecommendCarouselCell.h
//  GuitarChina
//
//  Created by mac on 2017/7/12.
//  Copyright © 2017年 陈大捷. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"

@interface GCNewsRecommendCarouselCell : UITableViewCell

@property (nonatomic, strong) SDCycleScrollView *imgScrollView;

@property (nonatomic, copy) void(^didSelectItemBlock)(NSInteger index);

@end
