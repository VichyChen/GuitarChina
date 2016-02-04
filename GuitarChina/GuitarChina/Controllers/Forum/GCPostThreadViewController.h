//
//  GCPostThreadViewController.h
//  GuitarChina
//
//  Created by mac on 16/1/19.
//  Copyright © 2016年 陈大捷. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GCPostThreadViewController : UIViewController

@property (nonatomic, copy) NSString *fid;
@property (nonatomic, copy) NSString *formhash;
@property (nonatomic, strong) NSDictionary *threadTypes;

@end
