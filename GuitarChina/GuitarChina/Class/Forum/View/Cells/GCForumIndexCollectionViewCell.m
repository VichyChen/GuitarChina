//
//  GCForumIndexCollectionViewCell.m
//  GuitarChina
//
//  Created by mac on 16/10/1.
//  Copyright © 2016年 陈大捷. All rights reserved.
//

#import "GCForumIndexCollectionViewCell.h"

#define ButtonHeight 40
#define ButtonVerticalSpace 13
#define ButtonHorizontalSpace 13

@interface GCForumIndexCollectionViewCell()

@property (nonatomic, strong) NSMutableArray *buttonArray;

@end

@implementation GCForumIndexCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleLabel.textColor = [GCColor fontColor];
    self.buttonArray = [NSMutableArray array];
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    if (ScreenWidth == 320) {
        self.titleLabel.font = [UIFont systemFontOfSize:14];
    }
}

- (void)configure:(NSArray *)array {
    for (int i = 0; i < self.buttonArray.count; i++) {
        UIButton *button = (UIButton *)[self.buttonArray objectAtIndex:i];
        if (button.superview) {
            [button removeFromSuperview];
        }
    }
    [self.buttonArray removeAllObjects];
    
    CGFloat rowOriginX = 13;
    CGFloat rowOriginY = 0;
    CGFloat buttonWidth = 0;
    for (int i = 0; i < array.count; i++) {
        GCForumModel *forumModel = [array objectAtIndex:i];

        NSString *title = [forumModel.todayposts isEqualToString:@"0"] ? forumModel.name : [NSString stringWithFormat:@"%@(%@)", forumModel.name, forumModel.todayposts];
        title = [title replace:@"&amp;" toNewString:@"&"];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[GCColor grayColor1] forState:UIControlStateNormal];
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.titleLabel.adjustsFontSizeToFitWidth = YES;
        button.backgroundColor = [UIColor colorWithRed:0.961 green:0.961 blue:0.961 alpha:1.00];
        button.layer.cornerRadius = 3;
        [self addSubview:button];
        [self.buttonArray addObject:button];
        button.tag = i;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        buttonWidth = (ScreenWidth - ButtonHorizontalSpace * 3) / 2;

        if (buttonWidth + rowOriginX + ButtonHorizontalSpace > ScreenWidth) {
            rowOriginY += (ButtonHeight + ButtonVerticalSpace);
            rowOriginX = 13;
        }
        button.frame = CGRectMake(rowOriginX, rowOriginY, buttonWidth, ButtonHeight);
        rowOriginX += (ButtonHorizontalSpace + buttonWidth);
    }
}

- (void)buttonAction:(UIButton *)sender {
//    if (self.didSelectButtonBlock) {
//        self.didSelectButtonBlock(sender.tag);
//    }
}

+ (CGSize)getCellHeight:(NSArray *)array {
    CGFloat rowOriginX = 13;
    CGFloat rowOriginY = 0;
    CGFloat buttonWidth = 0;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    for (int i = 0; i < array.count; i++) {
        GCForumModel *forumModel = [array objectAtIndex:i];
        
        NSString *title = [forumModel.todayposts isEqualToString:@"0"] ? forumModel.name : [NSString stringWithFormat:@"%@(%@)", forumModel.name, forumModel.todayposts];
        title = [title replace:@"&amp;" toNewString:@"&"];
        
        [button setTitle:title forState:UIControlStateNormal];
        
        buttonWidth = (ScreenWidth - ButtonHorizontalSpace * 3) / 2;
        
        if (buttonWidth + rowOriginX + ButtonHorizontalSpace > ScreenWidth) {
            rowOriginY += (ButtonHeight + ButtonVerticalSpace);
            rowOriginX = 13;
        }
        button.frame = CGRectMake(rowOriginX, rowOriginY, buttonWidth, ButtonHeight);
        rowOriginX += (ButtonHorizontalSpace + buttonWidth);
    }
    
    return  CGSizeMake(ScreenWidth, rowOriginY + ButtonHeight);
}

@end
