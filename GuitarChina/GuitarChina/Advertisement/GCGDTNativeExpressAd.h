//
//  GCGDTNativeExpressAdView.h
//  GuitarChina
//
//  Created by mac on 2017/11/9.
//  Copyright © 2017年 陈大捷. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDTNativeExpressAd.h"
#import "GDTNativeExpressAdView.h"

@interface GCGDTNativeExpressAd : NSObject

// 存储返回的GDTNativeExpressAdView
@property (nonatomic, copy) NSArray<GDTNativeExpressAdView *> *expressAdViews;
@property (nonatomic, copy) void(^loadSuccessBlock)(NSArray<GDTNativeExpressAdView *> *expressAdViews);

- (instancetype)initWithSize:(CGSize)size count:(int)count;


@end
