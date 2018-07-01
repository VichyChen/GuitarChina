//
//  GCLoginPickerView.m
//  GuitarChina
//
//  Created by mac on 17/1/13.
//  Copyright © 2017年 陈大捷. All rights reserved.
//

#import "GCLoginPickerView.h"

@interface GCLoginPickerView() <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, assign) CGRect originFrame;
@property (nonatomic, assign) CGRect afterMoveFrame;

@end

@implementation GCLoginPickerView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.show = NO;
        self.frame = CGRectMake(0, ScreenHeight - 64, ScreenWidth, ScreenHeight - 64);
        self.originFrame = self.frame;
        self.afterMoveFrame = CGRectMake(0, 0, ScreenWidth, self.frame.size.height);
        [self configureView];
    }
    return self;
}

#pragma mark - Private Methods

- (void)configureView {
    [self addSubview:self.transparentView];
    [self addSubview:self.contentView];
}

- (void)goAction {
    if (self.okActionBlock) {
        self.okActionBlock([self.pickerView selectedRowInComponent:0]);
    }
    [self dismiss];
}

- (void)cancelAction {
    [self dismiss];
}

- (void)dismiss {
    if (self.isShow) {
        [UIView animateWithDuration:0.3 animations:^{
            self.contentView.frame = CGRectMake(0, self.frame.size.height, ScreenWidth, 210);
            self.transparentView.alpha = 0.0f;
        } completion:^(BOOL finished) {
            self.frame = self.originFrame;
            self.show = NO;
            [self removeFromSuperview];
        }];
    }
}

- (void)showInView:(UIView *)view {
    if (!self.isShow) {
        [view addSubview:self];
        self.frame = self.afterMoveFrame;
        self.contentView.frame = CGRectMake(0, self.frame.size.height, ScreenWidth, 210);
        self.transparentView.alpha = 0.0f;
        [UIView animateWithDuration:0.4
                              delay:0.0
             usingSpringWithDamping:0.8
              initialSpringVelocity:0.0
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.contentView.frame = CGRectMake(0, self.frame.size.height - 200, ScreenWidth, 210);
                             self.transparentView.alpha = 0.3f;
                         } completion:^(BOOL finished) {
                             self.show = YES;
                         }];
    }
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.array.count;
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    [pickerView.subviews objectAtIndex:1].hidden = YES;
    [pickerView.subviews objectAtIndex:2].hidden = YES;
    return self.array[row];
}

#pragma mark - Setters

- (void)setArray:(NSArray *)array {
    _array = array;
    
    [self.pickerView reloadAllComponents];
}

#pragma mark - Getters

- (UIView *)transparentView {
    if (!_transparentView) {
        _transparentView = [[UIView alloc] initWithFrame:self.bounds];
        _transparentView.backgroundColor = [UIColor blackColor];
        _transparentView.alpha = 0.0f;
        
        @weakify(self);
        [_transparentView bk_whenTapped:^{
            @strongify(self);
            [self dismiss];
        }];
    }
    return _transparentView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
        
        [_contentView addSubview:self.cancelButton];
        [_contentView addSubview:self.goButton];
        [_contentView addSubview:self.separatorLineView];
        [_contentView addSubview:self.pickerView];
    }
    return _contentView;
}

- (UIButton *)goButton {
    if (!_goButton) {
        _goButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _goButton.frame = CGRectMake(ScreenWidth - 13 - 60, 0, 60, 40);
        [_goButton setTitle:@"确定" forState:UIControlStateNormal];
        [_goButton addTarget:self action:@selector(goAction) forControlEvents:UIControlEventTouchUpInside];
        _goButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _goButton.tintColor = [GCColor grayColor1];
    }
    return _goButton;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _cancelButton.frame = CGRectMake(13, 0, 60, 40);
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
        _cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _cancelButton.tintColor = [GCColor grayColor1];
    }
    return _cancelButton;
}

- (UIView *)separatorLineView {
    if (!_separatorLineView) {
        _separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, ScreenWidth, 0.5)];
        _separatorLineView.backgroundColor = [GCColor separatorLineColor];
    }
    return _separatorLineView;
}

- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40.5, ScreenWidth, 160)];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        _pickerView.backgroundColor = [UIColor whiteColor];
    }
    return _pickerView;
}

@end
