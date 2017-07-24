//
//  GCAddImageCell.h
//  GuitarChina
//
//  Created by mac on 16/11/8.
//  Copyright © 2016年 陈大捷. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GCAddImageCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *deleteButton;

@property (nonatomic, copy) void(^deleteActionBlock)(void);

@end
