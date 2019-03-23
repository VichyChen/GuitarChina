//
//  UITabBarItem+DoubleTap.h
//

#import <UIKit/UIKit.h>

@interface UITabBarItem (QMUI)

@property(nonatomic, copy) void (^doubleTapBlock)(UITabBarItem *tabBarItem, NSInteger index);

@end

@interface UITabBar (QMUI)

@end
