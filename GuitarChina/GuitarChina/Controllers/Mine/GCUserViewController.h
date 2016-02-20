//
//  GCUserViewController.h
//  GuitarChina
//
//  Created by mac on 16/2/21.
//  Copyright © 2016年 陈大捷. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCBaseViewController.h"

@interface GCUserViewController : GCBaseViewController

@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *userLevel;

@end
