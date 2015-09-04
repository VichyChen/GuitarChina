//
//  UIView+UIFactory.m
//  GuitarChina
//
//  Created by 陈大捷 on 15/9/4.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import "UIView+UIFactory.h"

@implementation UIView (UIFactory)

+ (id)createLabel
{
    return [UIView createLabel:CGRectZero];
}

+ (id)createLabel:(CGRect)frame
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
//    label.textAlignment = kTextAlignmentCenter;
    
        return label;
}

#pragma mark TextField

+ (id)createTextFiled
{
    return [UIView createTextFiled:UITextBorderStyleRoundedRect];
}

+ (id)createTextFiled:(UITextBorderStyle)style
{
    return [UIView createTextFiled:CGRectZero style:style];
}

+ (id)createTextFiled:(CGRect)frame style:(UITextBorderStyle)style
{
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
//    textField.textAlignment = kTextAlignmentCenter;
    textField.textColor = [UIColor blackColor];
    textField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.borderStyle = style;
    
    return textField;
}


#pragma mark Button

+ (id)createButton:(CGRect)frame
{
    return [UIView createButton:frame type:UIButtonTypeRoundedRect];
}

+ (id)createButton:(CGRect)frame
              type:(UIButtonType)type
{
    UIButton *btn = [UIButton buttonWithType:type];
    btn.frame = frame;
    return btn;
}

+ (id)createButton:(CGRect)frame
            target:(id)target
            action:(SEL)action
{
    return [UIView createButton:frame
                         target:target
                         action:action
                     buttonType:UIButtonTypeRoundedRect];
}


+ (id)createButton:(CGRect)frame
            target:(id)target
            action:(SEL)action
        buttonType:(UIButtonType)type
{
    UIButton *btn = [UIButton buttonWithType:type];
    btn.frame = frame;
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}


#pragma mark TableView

+ (id)createTableView:(id<UITableViewDataSource>)dataSource
             delegete:(id<UITableViewDelegate>)delegate
{
    return [UIView createTableView:CGRectZero
                        dataSource:dataSource
                          delegete:delegate
                             style:UITableViewStyleGrouped];
}

+ (id)createTableView:(id<UITableViewDataSource>)dataSource
             delegete:(id<UITableViewDelegate>)delegate
                style:(UITableViewStyle)style
{
    return [UIView createTableView:CGRectZero
                        dataSource:dataSource
                          delegete:delegate
                             style:style];
}

+ (id)createTableView:(CGRect)frame
           dataSource:(id<UITableViewDataSource>)dataSource
             delegete:(id<UITableViewDelegate>)delegate
{
    return [UIView createTableView:frame
                        dataSource:dataSource
                          delegete:delegate
                             style:UITableViewStyleGrouped];
}


+ (id)createTableView:(CGRect)frame
           dataSource:(id<UITableViewDataSource>)dataSource
             delegete:(id<UITableViewDelegate>)delegate
                style:(UITableViewStyle)style
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:style];
    tableView.delegate = delegate;
    tableView.dataSource = dataSource;
    
    return tableView;
}


#pragma mark TextView

+ (id)createTextView:(CGRect)frame
{
    UITextView *tv = [[UITextView alloc] initWithFrame:frame];
    
    return tv;
}


@end

