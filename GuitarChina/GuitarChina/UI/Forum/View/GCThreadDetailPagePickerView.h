//
//  GCThreadDetailPagePickerView.h
//  GuitarChina
//
//  Created by mac on 17/1/13.
//  Copyright © 2017年 陈大捷. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GCThreadDetailPagePickerView : UIView

@property (nonatomic, strong) UIView *transparentView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton *goButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIView *separatorLineView;
@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, copy) void (^goActionBlock)(NSInteger page);

@property (nonatomic, assign) NSInteger pickerViewCount;
@property (nonatomic, assign) NSInteger pickerViewIndex;

@property (nonatomic, assign, getter=isShow) BOOL show;

- (void)dismiss;
- (void)show;

@end
