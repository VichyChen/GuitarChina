//
//  AppDelegate.h
//  GuitarChina
//
//  Created by 陈大捷 on 15/8/19.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "GCTabBarController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) UIWindow *window;

@property (nonatomic, strong) GCTabBarController *tabBarController;

@property (nonatomic, strong) NSDictionary *forumDictionary;

- (void)saveContext;

- (void)selectImage:(UIViewController *)controller success:(void(^)(UIImage *image, NSDictionary *info))success;

@end

