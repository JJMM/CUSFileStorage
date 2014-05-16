//
//  CUSFileStorageManager.h
//  CUSFileStorageExample
//
//  Created by zhangyu on 14-5-14.
//  Copyright (c) 2014年 zhangyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CUSFileStorage.h"
@interface CUSFileStorageManager : NSObject

+(CUSFileStorage *)getFileStorage;
+(CUSFileStorage *)getFileStorage:(NSString *)tableName;

+(void)clearAllCache;
@end
