//
//  CUSFileStorageManager.m
//  CUSFileStorageExample
//
//  Created by zhangyu on 14-5-14.
//  Copyright (c) 2014年 zhangyu. All rights reserved.
//

#import "CUSFileStorageManager.h"

static NSMutableDictionary *CUSFileStorageDictionary;

@implementation CUSFileStorageManager

+(CUSFileStorage *)getFileStorage:(NSString *)tableName{
    if (!CUSFileStorageDictionary) {
        CUSFileStorageDictionary = [[NSMutableDictionary alloc]init];
    }
    CUSFileStorage *fileStorage = [CUSFileStorageDictionary objectForKey:tableName];
    if (!fileStorage) {
        fileStorage = [[CUSFileStorage alloc]init];
        fileStorage.tableName = tableName;
        [CUSFileStorageDictionary setValue:fileStorage forKey:tableName];
    }
    return fileStorage;
}

@end
