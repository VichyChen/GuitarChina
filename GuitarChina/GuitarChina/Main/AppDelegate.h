//
//  AppDelegate.h
//  GuitarChina
//
//  Created by 陈大捷 on 15/8/19.
//  Copyright (c) 2015年 陈大捷. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "RESideMenu.h"
#import "GCLeftMenuViewController.h"
#import "GCThreadRightMenuViewController.h"
#import "GCTabBarController.h"

#define LeftSideMenuOffsetCenterXIniPhone ScreenWidth * 0.166 //iphone右侧边栏X坐标
#define LeftSideMenuOffsetCenterXIniPad -(ScreenWidth / 6)   //ipad右侧边栏X坐标

@interface AppDelegate : UIResponder <UIApplicationDelegate, RESideMenuDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) RESideMenu *sideMenuViewController;
@property (strong, nonatomic) GCLeftMenuViewController *leftMenuViewController;
@property (strong, nonatomic) GCThreadRightMenuViewController *rightMenuViewController;

@property (strong, nonatomic) GCTabBarController *tabBarController;


- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

