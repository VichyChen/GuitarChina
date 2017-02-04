//
//  GCNewPostThreadCell.m
//  GuitarChina
//
//  Created by mac on 17/1/31.
//  Copyright © 2017年 陈大捷. All rights reserved.
//

#import "GCNewPostThreadCell.h"

@interface GCNewPostThreadCell() <UITextViewDelegate>

@property (nonatomic, strong) NSMutableArray *buttonArray;

@end

@implementation GCNewPostThreadCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.clipsToBounds = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
        self.selectedBackgroundView.backgroundColor = [GCColor cellSelectedColor];
        self.buttonArray = [NSMutableArray array];
        [self configureView];
    }
    return self;
}

+ (CGFloat)getCellHeightWithDictionary:(NSDictionary *)dictionary {
    if ([dictionary[@"type"] isEqualToNumber:@(GCNewPostThreadCellStyleRadioButton)] ||
        [dictionary[@"type"] isEqualToNumber:@(GCNewPostThreadCellStyleCheckButton)] ) {

        NSArray *buttonTitleArray = dictionary[@"dataArray"];

        CGFloat rowOriginX = 0;
        CGFloat rowOriginY = 10;
        CGFloat buttonWidth = 0;
        CGFloat buttonHeight = 30;
        CGFloat buttonVerticalSpace = 10;
        CGFloat buttonHorizontalSpace = 10;
        
        for (int i = 0; i < buttonTitleArray.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:buttonTitleArray[i] forState:UIControlStateNormal];
            button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
            button.titleLabel.font = [UIFont systemFontOfSize:14];

            buttonWidth = (ScreenWidth - 13 - 100 - 13 - 10 * 2) / 3;
            if (buttonWidth + rowOriginX > ScreenWidth - 13 - 100 - 13) {
                rowOriginY += (buttonHeight + buttonVerticalSpace);
                rowOriginX = 0;
            }
            button.frame = CGRectMake(rowOriginX, rowOriginY, buttonWidth, buttonHeight);
            rowOriginX += (buttonHorizontalSpace + buttonWidth);
        }
        
        return rowOriginY + buttonHeight + buttonVerticalSpace;
    
    } else {
        NSString *value = [@{@(GCNewPostThreadCellStyleSegmentedControl) : @"44.0",
                                     @(GCNewPostThreadCellStyleTextField) : @"44.0",
                                     @(GCNewPostThreadCellStyleOnlyTextField) : @"44.0",
                                     @(GCNewPostThreadCellStyleTextView) : @"100.0",
                                     @(GCNewPostThreadCellStyleOnlyTextView) : @"100.0",
                                     @(GCNewPostThreadCellStyleLabelArrow) : @"44.0"} objectForKey:dictionary[@"type"]];
        return value.floatValue;
    }
}

#pragma mark - Event Response 

- (void)textFieldValueChange:(UITextField *)textField {
    if (self.textFieldValueChangeBlock) {
        self.textFieldValueChangeBlock(textField);
    }
}

- (void)singleButtonAction:(UIButton *)button {
    for (UIButton *button in self.buttonArray) {
        button.selected = NO;
        [button setTitleColor:[GCColor redColor] forState:UIControlStateNormal];
    }

    button.selected = !button.selected;
    
    if (button.selected) {
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    } else {
        [button setTitleColor:[GCColor redColor] forState:UIControlStateNormal];
    }
    
    if (self.radioButtonSelectBlock) {
        self.radioButtonSelectBlock(button);
    }
}

- (void)mutableButtonAction:(UIButton *)button {
    button.selected = !button.selected;
    
    if (button.selected) {
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    } else {
        [button setTitleColor:[GCColor redColor] forState:UIControlStateNormal];
    }
    
    NSMutableArray *array = [NSMutableArray array];
    for (UIButton *button in self.buttonArray) {
        if (button.selected) {
            [array addObject:button];
        }
    }
    if (self.checkButtonSelectBlock) {
        self.checkButtonSelectBlock(array);
    }
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    if (self.textViewValueChangeBlock) {
        self.textViewValueChangeBlock(textView);
    }
}

- (void)segmentedControlValueChange:(UISegmentedControl *)segmentedControl {
    if (self.segmentControlValueChangeBlock) {
        self.segmentControlValueChangeBlock(segmentedControl);
    }
}

#pragma mark - Private Method

- (void)configureView {
    [self.contentView addSubview:self.containView];
}

- (void)createButtonsWithStringArray:(NSArray *)stringArray {
    UIView *buttonContentView = [[UIView alloc] init];
    buttonContentView.frame = CGRectMake(13 + 100, 0, ScreenWidth - 13 - 100 - 13, 0);
    [self.containView addSubview:buttonContentView];
    
    CGFloat rowOriginX = 0;
    CGFloat rowOriginY = 10;
    CGFloat buttonWidth = 0;
    CGFloat buttonHeight = 30;
    CGFloat buttonVerticalSpace = 10;
    CGFloat buttonHorizontalSpace = 10;
    
    for (int i = 0; i < stringArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:stringArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[GCColor redColor] forState:UIControlStateNormal];
        //        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        //        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [button setBackgroundImage:[[UIImage imageNamed:@"grayborder"] imageWithTintColor:[GCColor redColor]] forState:UIControlStateNormal];
        [button setBackgroundImage:[[UIImage imageNamed:@"grayBackground"] imageWithTintColor:[GCColor redColor]] forState:UIControlStateHighlighted];
        [button setBackgroundImage:[[UIImage imageNamed:@"grayBackground"] imageWithTintColor:[GCColor redColor]] forState:UIControlStateSelected];
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.layer.cornerRadius = 1;
        button.tag = i;
//        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [buttonContentView addSubview:button];
        [self.buttonArray addObject:button];
        
        buttonWidth = (buttonContentView.frame.size.width - 10 * 2) / 3;
        if (buttonWidth + rowOriginX > buttonContentView.frame.size.width) {
            rowOriginY += (buttonHeight + buttonVerticalSpace);
            rowOriginX = 0;
        }
        button.frame = CGRectMake(rowOriginX, rowOriginY, buttonWidth, buttonHeight);
        rowOriginX += (buttonHorizontalSpace + buttonWidth);
    }
    
    buttonContentView.frame = CGRectMake(13 + 100, 0, ScreenWidth - 13 - 100 - 13, rowOriginY + buttonHeight + buttonVerticalSpace);
    self.containView.frame = CGRectMake(0, 0, ScreenWidth, rowOriginY + buttonHeight + buttonVerticalSpace);
}

#pragma mark - Setters

- (void)setCellStyle:(GCNewPostThreadCellStyle)cellStyle {
    _cellStyle = cellStyle;
    
    for (UIView *subView in self.containView.subviews) {
        [subView removeFromSuperview];
    }
    for (UIButton *button in self.buttonArray) {
        [button removeFromSuperview];
    }
    [self.buttonArray removeAllObjects];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView bk_whenTapped:nil];
    
    switch (cellStyle) {
        case GCNewPostThreadCellStyleSegmentedControl:
            [self.containView addSubview:self.titleLabel];
            [self.containView addSubview:self.segmentedControl];
            
            self.containView.frame = CGRectMake(0, 0, ScreenWidth, 44);
            self.titleLabel.frame = CGRectMake(13, 0, 100, 44);
            self.segmentedControl.frame = CGRectMake(ScreenWidth - 13 - 160, 6, 160, 30);
            break;
            
        case GCNewPostThreadCellStyleTextField:
            [self.containView addSubview:self.titleLabel];
            [self.containView addSubview:self.textField];

            self.containView.frame = CGRectMake(0, 0, ScreenWidth, 44);
            self.titleLabel.frame = CGRectMake(13, 0, 100, 44);
            self.textField.frame = CGRectMake(ScreenWidth - 13 - 100, 0, 100, 44);
            
            self.textField.textAlignment = NSTextAlignmentRight;
            break;
            
        case GCNewPostThreadCellStyleOnlyTextField:
            [self.containView addSubview:self.textField];

            self.containView.frame = CGRectMake(0, 0, ScreenWidth, 44);
            self.textField.frame = CGRectMake(13, 0, ScreenWidth - 26, 44);
            self.textField.textAlignment = NSTextAlignmentLeft;
            break;
            
        case GCNewPostThreadCellStyleTextView:
            [self.containView addSubview:self.titleLabel];
            [self.containView addSubview:self.textView];

            self.containView.frame = CGRectMake(0, 0, ScreenWidth, 100);
            self.titleLabel.frame = CGRectMake(13, 0, 100, 44);
            self.textView.frame = CGRectMake(13 + 100, 3, ScreenWidth - 26 - 100, 100 - 6);
            break;
            
        case GCNewPostThreadCellStyleOnlyTextView:
            [self.containView addSubview:self.textView];

            self.containView.frame = CGRectMake(0, 0, ScreenWidth, 100);
            self.textView.frame = CGRectMake(10, 3, ScreenWidth - 20, 100 - 6);
            break;
            
        case GCNewPostThreadCellStyleRadioButton:
            [self.containView addSubview:self.titleLabel];

            self.containView.frame = CGRectMake(0, 0, ScreenWidth, 44);
            self.titleLabel.frame = CGRectMake(13, 0, 100, 44);
            break;
            
        case GCNewPostThreadCellStyleCheckButton:
            [self.containView addSubview:self.titleLabel];

            self.containView.frame = CGRectMake(0, 0, ScreenWidth, 44);
            self.titleLabel.frame = CGRectMake(13, 0, 100, 44);
            break;
            
        case GCNewPostThreadCellStyleLabelArrow:
            self.selectionStyle = UITableViewCellSelectionStyleDefault;

            [self.containView addSubview:self.titleLabel];
            [self.containView addSubview:self.valueLabel];
            [self.containView addSubview:self.arrowImageView];

            self.containView.frame = CGRectMake(0, 0, ScreenWidth, 44);
            self.titleLabel.frame = CGRectMake(13, 0, 100, 44);
            self.valueLabel.frame = CGRectMake(13 + 100, 0, ScreenWidth - 13 - 100 - 13 - 7 - 5, 44);
            self.arrowImageView.frame = CGRectMake(ScreenWidth - 13 - 7, 12, 14, 20);
            @weakify(self);
            [self.contentView bk_whenTapped:^{
                @strongify(self);
                if (self.didSelectRowBlock) {
                    self.didSelectRowBlock();
                }
            }];
            break;
    }
}

- (void)setRadioButtonTitleArray:(NSArray *)radioButtonTitleArray value:(NSString *)value {
    [self createButtonsWithStringArray:radioButtonTitleArray];
    
    for (UIButton *button in self.buttonArray) {
        if ([button.titleLabel.text isEqualToString:value]) {
            button.selected = YES;
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        } else {
            button.selected = NO;
            [button setTitleColor:[GCColor redColor] forState:UIControlStateNormal];
        }

        [button addTarget:self action:@selector(singleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)setCheckButtonTitleArray:(NSArray *)checkButtonTitleArray value:(NSArray *)value {
    [self createButtonsWithStringArray:checkButtonTitleArray];
    
    for (UIButton *button in self.buttonArray) {
        if ([value containsObject:button.titleLabel.text]) {
            button.selected = YES;
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        } else {
            button.selected = NO;
            [button setTitleColor:[GCColor redColor] forState:UIControlStateNormal];
        }
        [button addTarget:self action:@selector(mutableButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark - Getters

- (UIView *)containView {
    if (!_containView) {
        _containView = [[UIView alloc] init];
        _containView.clipsToBounds = YES;
    }
    return _containView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = [GCColor fontColor];
    }
    return _titleLabel;
}

- (UISegmentedControl *)segmentedControl {
    if (!_segmentedControl) {
        _segmentedControl = [[UISegmentedControl alloc] init];
        [_segmentedControl setTintColor:[GCColor redColor]];
        [_segmentedControl addTarget:self action:@selector(segmentedControlValueChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentedControl;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.font = [UIFont systemFontOfSize:16];
        _textField.textColor = [GCColor fontColor];
        _textField.placeholder = @"请输入";
        [_textField addTarget:self action:@selector(textFieldValueChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textField;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.font = [UIFont systemFontOfSize:16];
        _textView.textColor = [GCColor fontColor];
        _textView.placeholder = @"请输入";
        _textView.delegate = self;
    }
    return _textView;
}

- (UILabel *)valueLabel {
    if (!_valueLabel) {
        _valueLabel = [[UILabel alloc] init];
        _valueLabel.font = [UIFont systemFontOfSize:16];
        _valueLabel.textColor = [GCColor fontColor];
        _valueLabel.textAlignment = NSTextAlignmentRight;
        _valueLabel.text = @"请选择";
    }
    return _valueLabel;
}

- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] init];
        _arrowImageView.image = [UIImage imageNamed:@"icon_forward"];
    }
    return _arrowImageView;
}

@end
