//
//  GCAdInterstitial.h
//  GuitarChina
//
//  Created by mac on 16/12/27.
//  Copyright © 2016年 陈大捷. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCAdInterstitial : NSObject

- (void)presentFromViewController:(UIViewController *)viewController;

- (void)presentFromRootViewController;

@property (nonatomic, copy) void(^dismissScreenBlock)(void);

@end
