//
//  ForumBrowseRecordModel.h
//  GuitarChina
//
//  Created by 陈大捷 on 16/3/27.
//  Copyright © 2016年 陈大捷. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ForumBrowseRecordModel : NSManagedObject

@property (nonatomic) int32_t fid;
@property (nonatomic) int32_t count;

@end

