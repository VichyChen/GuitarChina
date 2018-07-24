//
//  GCThreadDetailPagePickerView.m
//  GuitarChina
//
//  Created by mac on 17/1/13.
//  Copyright © 2017年 陈大捷. All rights reserved.
//

#import "GCThreadDetailPagePickerView.h"

@interface GCThreadDetailPagePickerView() <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, assign) CGRect originFrame;
@property (nonatomic, assign) CGRect afterMoveFrame;

@end

@implementation GCThreadDetailPagePickerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.show = NO;
        self.originFrame = frame;
        self.afterMoveFrame = CGRectMake(0, 0, kScreenWidth, self.frame.size.height);
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
    if (self.goActionBlock) {
        self.goActionBlock(([self.pickerView selectedRowInComponent:0] + 1));
    }
}

- (void)selectFirstAction {
    if (self.selectFirstBlock) {
        self.selectFirstBlock(1);
    }
}

- (void)selectLastAction {
    if (self.selectLastBlock) {
        self.selectLastBlock(self.pickerViewCount);
    }
}

- (void)cancelAction {
    [self dismiss];
}

- (void)dismiss {
    if (self.isShow) {
        [UIView animateWithDuration:0.3 animations:^{
            self.contentView.frame = CGRectMake(0, self.frame.size.height, kScreenWidth, 210);
            self.transparentView.alpha = 0.0f;
        } completion:^(BOOL finished) {
            self.frame = self.originFrame;
            self.show = NO;
        }];
    }
}

- (void)show {
    if (!self.isShow) {
        self.frame = self.afterMoveFrame;
        self.contentView.frame = CGRectMake(0, self.frame.size.height, kScreenWidth, 210);
        self.transparentView.alpha = 0.0f;
        [UIView animateWithDuration:0.4
                              delay:0.0
             usingSpringWithDamping:0.8
              initialSpringVelocity:0.0
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.contentView.frame = CGRectMake(0, self.frame.size.height - 200, kScreenWidth, 210);
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
    return self.pickerViewCount;
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    [pickerView.subviews objectAtIndex:1].hidden = YES;
    [pickerView.subviews objectAtIndex:2].hidden = YES;
    return [NSString stringWithFormat:@"%ld", row + 1];
}

#pragma mark - Setters

- (void)setPickerViewCount:(NSInteger)pickerViewCount {
    _pickerViewCount = pickerViewCount;
    
    [self.pickerView reloadComponent:0];
}

- (void)setPickerViewIndex:(NSInteger)pickerViewIndex {
    _pickerViewIndex = pickerViewIndex;
    
    [self.pickerView selectRow:pickerViewIndex inComponent:0 animated:YES];
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
        [_contentView addSubview:self.firstButton];
        [_contentView addSubview:self.lastButton];
        [_contentView addSubview:self.goButton];
        [_contentView addSubview:self.separatorLineView];
        [_contentView addSubview:self.pickerView];
    }
    return _contentView;
}

- (UIButton *)goButton {
    if (!_goButton) {
        _goButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _goButton.frame = CGRectMake(kScreenWidth - kMargin - 60, 0, 60, 40);
        [_goButton setTitle:@"跳转" forState:UIControlStateNormal];
        [_goButton addTarget:self action:@selector(goAction) forControlEvents:UIControlEventTouchUpInside];
        _goButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _goButton.tintColor = [GCColor grayColor1];
    }
    return _goButton;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _cancelButton.frame = CGRectMake(kMargin, 0, 60, 40);
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
        _cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _cancelButton.tintColor = [GCColor grayColor1];
    }
    return _cancelButton;
}

- (UIButton *)firstButton {
    if (!_firstButton) {
        _firstButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _firstButton.frame = CGRectMake(kMargin + kSubScreenWidth / 3 - 30, 0, 60, 40);
        [_firstButton setTitle:@"首页" forState:UIControlStateNormal];
        [_firstButton addTarget:self action:@selector(selectFirstAction) forControlEvents:UIControlEventTouchUpInside];
        _firstButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _firstButton.tintColor = [GCColor grayColor1];
    }
    return _firstButton;
}

- (UIButton *)lastButton {
    if (!_lastButton) {
        _lastButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _lastButton.frame = CGRectMake(kMargin + kSubScreenWidth / 3 * 2 - 30, 0, 60, 40);
        [_lastButton setTitle:@"末页" forState:UIControlStateNormal];
        [_lastButton addTarget:self action:@selector(selectLastAction) forControlEvents:UIControlEventTouchUpInside];
        _lastButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _lastButton.tintColor = [GCColor grayColor1];
    }
    return _lastButton;
}

- (UIView *)separatorLineView {
    if (!_separatorLineView) {
        _separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, kScreenWidth, 0.5)];
        _separatorLineView.backgroundColor = [GCColor separatorLineColor];
    }
    return _separatorLineView;
}

- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40.5, kScreenWidth, 160)];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        _pickerView.backgroundColor = [UIColor whiteColor];
    }
    return _pickerView;
}

@end
