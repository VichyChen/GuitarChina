//
//  GCNewsRecommendViewController.h
//  GuitarChina
//
//  Created by mac on 2017/7/7.
//  Copyright © 2017年 陈大捷. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GCNewsRecommendViewController : UIViewController

@property (nonatomic, copy) void(^refreshBlock)(void);

- (void)beginRefresh;
- (void)endRefresh;
- (void)refresh:(GCNewsRecommendModel *)model;

@end
