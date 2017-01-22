//
//  GCReplyThreadView.h
//  GuitarChina
//
//  Created by mac on 15/10/26.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCReplyPostThreadToolBarView.h"

@interface GCReplyThreadView : UIView

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *placeholderLabel;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) GCReplyPostThreadToolBarView *toolBarView;

@property (nonatomic, weak) UIViewController *viewController;

@property (nonatomic, strong) NSMutableArray *imageArray;

@end
