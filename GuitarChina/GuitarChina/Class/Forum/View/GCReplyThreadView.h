//
//  GCReplyThreadView.h
//  GuitarChina
//
//  Created by mac on 15/10/26.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GCReplyThreadView : UIView

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *placeholderLabel;
@property (nonatomic, strong) UIView *separatorView;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIViewController *viewController;

@property (nonatomic, copy) NSArray *imageArray;

@end
