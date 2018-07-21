//
//  GCReplyPostThreadToolBarView.m
//  GuitarChina
//
//  Created by mac on 17/1/21.
//  Copyright © 2017年 陈大捷. All rights reserved.
//

#import "GCReplyPostThreadToolBarView.h"

@interface  GCReplyPostThreadToolBarView()

@property (nonatomic, strong) UIButton *selectImageButton;
@property (nonatomic, strong) UIButton *inputImageURLButton;

@property (nonatomic, strong) UIButton *closeButton;
@end

@implementation GCReplyPostThreadToolBarView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [GCColor cellSelectedColor];
        self.frame = CGRectMake(0, 0, kScreenWidth, 44);
        [self configureView];
        [self configureFrame];
    }
    return self;
}

#pragma mark - Private Methods

- (void)configureView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    view.backgroundColor = [GCColor separatorLineColor];
    [self addSubview:view];
//    [self addSubview:self.closeButton];
    [self addSubview:self.selectImageButton];
//    [self addSubview:self.inputImageURLButton];
}

- (void)configureFrame {
    self.closeButton.frame = CGRectMake(kScreenWidth - 60, 0, 50, 44);
    self.selectImageButton.frame = CGRectMake(10, 0, 44, 44);
    self.inputImageURLButton.frame = CGRectMake(64, 0, 44, 44);
}

#pragma mark - Event Response

- (void)closeAction {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (void)selectImageAction {
    if (self.selectImageBlock) {
        self.selectImageBlock();
    }
}

#pragma mark - Getters

- (UIButton *)selectImageButton {
    if (!_selectImageButton) {
        _selectImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectImageButton setImage:[[UIImage imageNamed:@"icon_image"] imageWithTintColor:[GCColor grayColor1]] forState:UIControlStateNormal];
        [_selectImageButton addTarget:self action:@selector(selectImageAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectImageButton;
}

- (UIButton *)inputImageURLButton {
    if (!_inputImageURLButton) {
        _inputImageURLButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_inputImageURLButton setTitle:@"bb" forState:UIControlStateNormal];
        [_inputImageURLButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _inputImageURLButton.backgroundColor = [UIColor greenColor];
    }
    return _inputImageURLButton;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setTitle:@"关闭" forState:UIControlStateNormal];
        [_closeButton setTitleColor:[GCColor grayColor1] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

@end
