//
//  GCHistoryCell.m
//  GuitarChina
//
//  Created by 陈大捷 on 16/5/28.
//  Copyright © 2016年 陈大捷. All rights reserved.
//

#import "GCHistoryCell.h"

#define ButtonHeight 35
#define ButtonVerticalSpace 13
#define ButtonHorizontalSpace 13

@interface GCHistoryCell()

@property (nonatomic, strong) NSMutableArray *buttonArray;

@end

@implementation GCHistoryCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)configure:(NSArray *)array {
    
    for (int i = 0; i < self.buttonArray.count; i++) {
        UIButton *button = (UIButton *)[self.buttonArray objectAtIndex:i];
        if (button.superview) {
            [button removeFromSuperview];
        }
    }
    [self.buttonArray removeAllObjects];
    
    CGFloat rowOriginX = 0;
    CGFloat rowOriginY = 0;
    CGFloat buttonWidth = 0;
    for (int i = 0; i < array.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:array[i] forState:UIControlStateNormal];
        [button setTitleColor:[GCColor grayColor1] forState:UIControlStateNormal];
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 15);
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.backgroundColor = [UIColor colorWithRed:0.961 green:0.961 blue:0.961 alpha:1.00];
        button.layer.cornerRadius = 3;
        [self addSubview:button];
        [self.buttonArray addObject:button];
        button.tag = i;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        buttonWidth = [button sizeThatFits:CGSizeMake(1, 1)].width;
        if (buttonWidth + rowOriginX + ButtonHorizontalSpace > kScreenWidth - ButtonHorizontalSpace * 2) {
            rowOriginY += (ButtonHeight + ButtonVerticalSpace);
            rowOriginX = 0;
        }
        button.frame = CGRectMake(13 + rowOriginX, rowOriginY, buttonWidth, ButtonHeight);
        rowOriginX += (ButtonHorizontalSpace + buttonWidth);
    }
}

- (void)buttonAction:(UIButton *)sender {
    if (self.didSelectButtonBlock) {
        self.didSelectButtonBlock(sender.tag);
    }
}

+ (CGSize)getCellHeightWithArray:(NSArray *)array {
    CGFloat rowOriginX = 0;
    CGFloat rowOriginY = 0;
    CGFloat buttonWidth = 0;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.contentEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 15);
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    for (int i = 0; i < array.count; i++) {
        [button setTitle:array[i] forState:UIControlStateNormal];
        
        buttonWidth = [button sizeThatFits:CGSizeMake(1, 1)].width;
        if (buttonWidth + rowOriginX + ButtonHorizontalSpace > kScreenWidth - ButtonHorizontalSpace * 2) {
            rowOriginY += (ButtonHeight + ButtonVerticalSpace);
            rowOriginX = 0;
        }
        button.frame = CGRectMake(13 + rowOriginX, rowOriginY, buttonWidth, ButtonHeight);
        rowOriginX += (ButtonHorizontalSpace + buttonWidth);
    }
    
    return  CGSizeMake(kScreenWidth, rowOriginY + ButtonHeight);
}

#pragma mark - Getters

- (NSMutableArray *)buttonArray {
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray array];
    }
    
    return _buttonArray;
}

@end
