//
//  CUSFileStorage.m
//  CUSFileStorageExample
//
//  Created by zhangyu on 14-5-13.
//  Copyright (c) 2014 zhangyu. All rights reserved.
//

#import "CUSFileStorage.h"

static NSMutableDictionary *CUSFileStorageDictionary;

@implementation CUSFileStorage
@synthesize tableName;

+(id)shareFileStorage:(NSString *)tableName{
    if (!CUSFileStorageDictionary) {
        CUSFileStorageDictionary = [[NSMutableDictionary alloc]init];
    }
    CUSFileStorage *fileStorage = [CUSFileStorageDictionary objectForKey:tableName];
    if (!fileStorage) {
        fileStorage = [[CUSFileStorage alloc]init];
        fileStorage.tableName = tableName;
        [CUSFileStorageDictionary setValue:fileStorage forKey:tableName];
    }
    UITableView *t;
    return fileStorage;
}
@end
