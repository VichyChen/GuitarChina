//
//  GCThreadDetailToolBarView.h
//  GuitarChina
//
//  Created by mac on 17/1/13.
//  Copyright © 2017年 陈大捷. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GCThreadDetailToolBarView : UIView

@property (nonatomic, strong) UIView *separatorLineView;
@property (nonatomic, strong) UIButton *pageButton;
@property (nonatomic, strong) UIButton *previousPageButton;
@property (nonatomic, strong) UIButton *nextPageButton;
@property (nonatomic, strong) UIView *replyView;

@property (nonatomic, copy) void (^pageActionBlock)();
@property (nonatomic, copy) void (^previousPageActionBlock)();
@property (nonatomic, copy) void (^nextPageActionBlock)();
@property (nonatomic, copy) void (^replyActionBlock)();

@end
