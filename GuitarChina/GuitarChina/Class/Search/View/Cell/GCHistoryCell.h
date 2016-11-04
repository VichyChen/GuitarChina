//
//  GCHistoryCell.h
//  GuitarChina
//
//  Created by 陈大捷 on 16/5/28.
//  Copyright © 2016年 陈大捷. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GCHistoryCell : UITableViewCell

@property (nonatomic, copy) void(^didSelectButtonBlock)(NSInteger index);

- (void)configure:(NSArray *)array;

+ (CGSize)getCellHeightWithArray:(NSArray *)array;

@end
