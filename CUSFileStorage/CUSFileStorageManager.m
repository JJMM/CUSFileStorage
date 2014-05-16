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

+(CUSFileStorage *)getFileStorage{
    return [self getFileStorage:@"DefaultDB"];
}
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

+(void)clearAllCache{
    if (!CUSFileStorageDictionary) {
        return;
    }
    for (CUSFileStorage *fileStorage in CUSFileStorageDictionary) {
        [fileStorage clearCache];
    }
    [CUSFileStorageDictionary  removeAllObjects];
}

@end
