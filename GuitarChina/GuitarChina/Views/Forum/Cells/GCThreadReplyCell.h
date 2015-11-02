//
//  GCThreadReplyCell.h
//  GuitarChina
//
//  Created by 陈大捷 on 15/9/13.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTLabel.h"
#import "GCThreadDetailModel.h"

@interface GCThreadReplyCell : UITableViewCell

@property (nonatomic, strong) GCThreadDetailPostModel *model;

+ (CGFloat)getCellHeightWithModel:(GCThreadDetailPostModel *)model;

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) CGFloat messageWebViewHeight;
@property (nonatomic, copy) void (^ReloadAction)(NSIndexPath *, CGFloat);

@property (nonatomic, strong) UILabel *authorLabel;
@property (nonatomic, strong) UILabel *datelineLabel;
@property (nonatomic, strong) UIWebView *messageWebView;
@property (nonatomic, strong) UILabel *numberLabel;


@end
