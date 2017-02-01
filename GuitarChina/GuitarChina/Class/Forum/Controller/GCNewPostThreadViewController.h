//
//  GCNewPostThreadViewController.h
//  GuitarChina
//
//  Created by mac on 17/1/31.
//  Copyright © 2017年 陈大捷. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GCNewPostThreadViewController : UIViewController

@property (nonatomic, copy) NSString *fid;
@property (nonatomic, copy) NSString *formhash;
@property (nonatomic, strong) NSDictionary *threadTypes;

@end
