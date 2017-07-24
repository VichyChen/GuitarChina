//
//  GCForumIndexCollectionViewCell.h
//  GuitarChina
//
//  Created by mac on 16/10/1.
//  Copyright © 2016年 陈大捷. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GCForumIndexCollectionViewCell : UICollectionViewCell

//@property (nonatomic, copy) void(^didSelectButtonBlock)(NSInteger index);
//
//- (void)configure:(NSArray *)array;
//
//+ (CGSize)getCellHeight:(NSArray *)array;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
