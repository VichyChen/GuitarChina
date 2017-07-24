//
//  GCDiscoveryTableViewController.h
//  GuitarChina
//
//  Created by 陈大捷 on 16/4/10.
//  Copyright © 2016年 陈大捷. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GCDiscoveryTableViewType) {
    GCDiscoveryTableViewTypeHot,
    GCDiscoveryTableViewTypeNew,
    GCDiscoveryTableViewTypeSofa,
    GCDiscoveryTableViewTypeDigest
};

@interface GCDiscoveryTableViewController : GCBaseViewController

@property (nonatomic, assign) GCDiscoveryTableViewType discoveryTableViewType;

@end
