//
//  GCMyPromptModel.h
//  GuitarChina
//
//  Created by mac on 17/1/19.
//  Copyright © 2017年 陈大捷. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCMyPromptModel : NSObject

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *tid;
@property (nonatomic, copy) NSString *threadTitle;
@property (nonatomic, copy) NSString *remarkString;

@end


@interface GCMyPromptArray : NSObject

@property (nonatomic, strong) NSMutableArray *data;    //GCMyPromptModel

@end
