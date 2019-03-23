//
//  UITabBarItem+DoubleTap.m
//

#import "UITabBarItem+DoubleTap.h"
#import <objc/runtime.h>

@implementation UITabBarItem (QMUI)

- (void(^)(UITabBarItem *, NSInteger))doubleTapBlock {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setDoubleTapBlock:(void(^)(UITabBarItem *, NSInteger))doubleTapBlock {
    objc_setAssociatedObject(self, @selector(doubleTapBlock), doubleTapBlock, OBJC_ASSOCIATION_COPY);
}


@end

NSInteger const kLastTouchedTabBarItemIndexNone = -1;

@interface UITabBar ()

@property (nonatomic, assign) BOOL canItemRespondDoubleTouch;
@property (nonatomic, assign) NSInteger lastTouchedTabBarItemViewIndex;
@property (nonatomic, assign) NSInteger tabBarItemViewTouchCount;

@end

@implementation UITabBar (DoubleTap)

- (BOOL)canItemRespondDoubleTouch {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setCanItemRespondDoubleTouch:(BOOL)canItemRespondDoubleTouch {
    objc_setAssociatedObject(self, @selector(canItemRespondDoubleTouch), @(canItemRespondDoubleTouch), OBJC_ASSOCIATION_ASSIGN);
}

- (NSInteger)lastTouchedTabBarItemViewIndex {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (void)setLastTouchedTabBarItemViewIndex:(NSInteger)lastTouchedTabBarItemViewIndex {
    objc_setAssociatedObject(self, @selector(lastTouchedTabBarItemViewIndex), @(lastTouchedTabBarItemViewIndex), OBJC_ASSOCIATION_ASSIGN);
}

- (NSInteger)tabBarItemViewTouchCount {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (void)setTabBarItemViewTouchCount:(NSInteger)tabBarItemViewTouchCount {
    objc_setAssociatedObject(self, @selector(tabBarItemViewTouchCount), @(tabBarItemViewTouchCount), OBJC_ASSOCIATION_ASSIGN);
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        method_exchangeImplementations(class_getInstanceMethod(self.class, @selector(setItems:animated:)),
                                       class_getInstanceMethod(self.class, @selector(doubleTap_setItems:animated:)));
        
        method_exchangeImplementations(class_getInstanceMethod(self.class, @selector(setSelectedItem:)),
                                       class_getInstanceMethod(self.class, @selector(doubleTap_setSelectedItem:)));
    });
}

- (void)doubleTap_setItems:(NSArray<UITabBarItem *> *)items animated:(BOOL)animated {
    [self doubleTap_setItems:items animated:animated];
    
    for (UITabBarItem *item in items) {
        UIControl *itemView = (UIControl *)[item valueForKey:@"view"];
        [itemView addTarget:self action:@selector(handleTabBarItemViewEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)doubleTap_setSelectedItem:(UITabBarItem *)selectedItem {
    NSInteger olderSelectedIndex = self.selectedItem ? [self.items indexOfObject:self.selectedItem] : -1;
    [self doubleTap_setSelectedItem:selectedItem];
    NSInteger newerSelectedIndex = [self.items indexOfObject:selectedItem];
    // 只有双击当前正在显示的界面的 tabBarItem，才能正常触发双击事件
    self.canItemRespondDoubleTouch = olderSelectedIndex == newerSelectedIndex;
}

- (void)handleTabBarItemViewEvent:(UIControl *)itemView {
    if (!self.canItemRespondDoubleTouch) return;
    if (!self.selectedItem.doubleTapBlock) return;
    
    // 如果一定时间后仍未触发双击，则废弃当前的点击状态
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self revertTabBarItemTouch];
    });
    
    NSInteger selectedIndex = [self.items indexOfObject:self.selectedItem];
    if (self.lastTouchedTabBarItemViewIndex == kLastTouchedTabBarItemIndexNone) {
        // 记录第一次点击的 index
        self.lastTouchedTabBarItemViewIndex = selectedIndex;
    } else if (self.lastTouchedTabBarItemViewIndex != selectedIndex) {
        // 后续的点击如果与第一次点击的 index 不一致，则认为是重新开始一次新的点击
        [self revertTabBarItemTouch];
        self.lastTouchedTabBarItemViewIndex = selectedIndex;
        return;
    }
    
    self.tabBarItemViewTouchCount++;
    if (self.tabBarItemViewTouchCount == 2) {
        // 第二次点击了相同的 tabBarItem，触发双击事件
        UITabBarItem *item = self.items[selectedIndex];
        if (item.doubleTapBlock) {
            item.doubleTapBlock(item, selectedIndex);
        }
        [self revertTabBarItemTouch];
    }
}

- (void)revertTabBarItemTouch {
    self.lastTouchedTabBarItemViewIndex = kLastTouchedTabBarItemIndexNone;
    self.tabBarItemViewTouchCount = 0;
}

@end
