//
//  UIView+UIFactory.h
//  GuitarChina
//
//  Created by 陈大捷 on 15/9/4.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIView (UIFactory)

// Label
+ (UILabel *)createLabel;

+ (UILabel *)createLabel:(CGRect)frame text:(NSString *)text font:(UIFont *)font textColor:(UIColor *)textColor;

+ (UILabel *)createLabel:(CGRect)frame text:(NSString *)text font:(UIFont *)font textColor:(UIColor *)textColor numberOfLines:(NSInteger)numberOfLines preferredMaxLayoutWidth:(CGFloat)preferredMaxLayoutWidth;

// TextField
+ (id)createTextFiled;

+ (id)createTextFiled:(UITextBorderStyle)style;

+ (id)createTextFiled:(CGRect)frame style:(UITextBorderStyle)style;

// Button
+ (id)createButton:(CGRect)frame;

+ (id)createButton:(CGRect)frame
              type:(UIButtonType)type;

+ (id)createButton:(CGRect)frame
            target:(id)target
            action:(SEL)action;

+ (id)createButton:(CGRect)frame
            target:(id)target
            action:(SEL)action
        buttonType:(UIButtonType)type;

//ImageView
+ (UIImageView *)createImageView:(CGRect)frame contentMode:(UIViewContentMode)contentMode;

+ (UIImageView *)createImageView:(CGRect)frame image:(UIImage *)image contentMode:(UIViewContentMode)contentMode;

// TableView
+ (id)createTableView:(id<UITableViewDataSource>)dataSource
             delegete:(id<UITableViewDelegate>)delegate;

+ (id)createTableView:(id<UITableViewDataSource>)dataSource
             delegete:(id<UITableViewDelegate>)delegate
                style:(UITableViewStyle)style;

+ (id)createTableView:(CGRect)frame
           dataSource:(id<UITableViewDataSource>)dataSource
             delegete:(id<UITableViewDelegate>)delegate;

+ (id)createTableView:(CGRect)frame
           dataSource:(id<UITableViewDataSource>)dataSource
             delegete:(id<UITableViewDelegate>)delegate
                style:(UITableViewStyle)style;


@end
