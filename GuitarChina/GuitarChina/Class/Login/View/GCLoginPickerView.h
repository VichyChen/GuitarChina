//
//  GCLoginPickerView.h
//  GuitarChina
//
//  Created by mac on 17/1/13.
//  Copyright © 2017年 陈大捷. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GCLoginPickerView : UIView

@property (nonatomic, strong) UIView *transparentView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton *goButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIView *separatorLineView;
@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) NSArray *array;

@property (nonatomic, copy) void (^okActionBlock)(NSInteger index);

@property (nonatomic, assign, getter=isShow) BOOL show;

- (void)dismiss;
- (void)show;

@end
