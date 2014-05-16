//
//  CUSFileStorage.m
//  CUSFileStorageExample
//
//  Created by zhangyu on 14-5-13.
//  Copyright (c) 2014 zhangyu. All rights reserved.
//

#import "CUSFileStorage.h"
#import "DataPersistence.h"

@interface CUSFileStorage()
@property(nonatomic,assign) BOOL beginFlag;
@property(nonatomic,strong) NSMutableDictionary *cacheStorageDB;
@end

@implementation CUSFileStorage
@synthesize tableName = _tableName;
@synthesize beginFlag;
@synthesize cacheStorageDB;

-(NSString *)getTableName{
    if (!_tableName) {
        return @"DefaultDB";
    }
    return _tableName;
}

- (void)setObject:(id)anObject forKey:(NSString *)aKey{
    if (!anObject) {
        return;
    }
    if (!aKey) {
        return;
    }
    NSMutableDictionary *serializStorageDic = [self getStorageDB];
    if ([anObject conformsToProtocol:@protocol(CUSSerializable)]) {
        [serializStorageDic setObject:[anObject serialize] forKey:aKey];
    }else{
        [serializStorageDic setObject:anObject forKey:aKey];
    }
    [self writeToDisk:serializStorageDic];
}

- (id)objectForKey:(NSString *)aKey{
    if (!aKey) {
        return nil;
    }
    NSMutableDictionary *serializStorageDic = [self getStorageDB];
    id value = [serializStorageDic objectForKey:aKey];
    id convertValue = [self convertValue:value];
    return [convertValue copy];
}

-(id)objectForFilter:(CUSFilter)filter{
    if (!filter) {
        return nil;
    }
    NSMutableDictionary *serializStorageDic = [self getStorageDB];
    NSArray *keys = [serializStorageDic allKeys];
    for (NSString *key in keys) {
        id value = [serializStorageDic objectForKey:key];
        id convertValue = [self convertValue:value];
        if (filter(key,convertValue)) {
            return convertValue;
        }
    }
    return nil;
}

- (void)removeObjectForKey:(NSString *)aKey{
    if (!aKey) {
        return;
    }
    NSMutableDictionary *serializStorageDic = [self getStorageDB];
    [serializStorageDic removeObjectForKey:aKey];
    [self writeToDisk:serializStorageDic];
}

- (void)removeObjectForFilter:(CUSFilter)filter{
    if (!filter) {
        return;
    }
    NSMutableDictionary *serializStorageDic = [self getStorageDB];
    NSArray *keys = [serializStorageDic allKeys];
    BOOL removeSucessful = NO;
    for (NSString *key in keys) {
        id value = [serializStorageDic objectForKey:key];
        id convertValue = [self convertValue:value];
        if (filter(key,convertValue)) {
            [serializStorageDic removeObjectForKey:key];
            removeSucessful = YES;
        }
    }
    if (removeSucessful) {
        [self writeToDisk:serializStorageDic];
    }
}

- (void)removeDB{
    NSString *filePath = [self getTableNameFilePath];
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:NULL];
    }
}
- (NSArray *)allKeys{
    NSMutableDictionary *serializStorageDic = [self getStorageDB];
    return [serializStorageDic allKeys];

}

- (NSArray *)allValues{
    NSMutableDictionary *serializStorageDic = [self getStorageDB];
    return [serializStorageDic allValues];
}

- (NSArray *)allValuesForFilter:(CUSFilter)filter{
    NSMutableArray *retArray = [NSMutableArray array];
    if (!filter) {
        return retArray;
    }
    
    NSMutableDictionary *serializStorageDic = [self getStorageDB];
    NSArray *keys = [serializStorageDic allKeys];
    for (NSString *key in keys) {
        id value = [serializStorageDic objectForKey:key];
        id convertValue = [self convertValue:value];
        if (filter(key,convertValue)) {
            [retArray addObject:convertValue];
        }
    }
    return retArray;
}

-(void)beginUpdates{
    self.beginFlag = YES;
}

-(void)endUpdates{
    self.beginFlag = NO;
    //save to disk
    [self writeToDisk:self.cacheStorageDB];
}

-(void)clearCache{
    if (!self.cacheStorageDB) {
        return;
    }
    [self writeToDisk:self.cacheStorageDB];
    self.cacheStorageDB = nil;
}
///////////////////internal method///////////////////////
//获取表存储文件名
-(NSString *)getTableNameFile{
    return [NSString stringWithFormat:@"%@.plist",[self getTableName]];
}
//获取文件真实路径
-(NSString *)getTableNameFilePath{
    NSString *filePaht = [NSString stringWithFormat:@"CUS_FS_%@",[self getTableNameFile]];
    return [DataPersistence getFilePath:filePaht];
}

-(NSMutableDictionary *)getStorageDB{
    if (!self.cacheStorageDB) {
        self.cacheStorageDB = [self readFromDisk];
    }
    return self.cacheStorageDB;
}

-(NSMutableDictionary *)readFromDisk{
    NSMutableDictionary *retDic = [NSMutableDictionary dictionary];
    NSString *filePath = [self getTableNameFilePath];
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        retDic = [[NSMutableDictionary alloc]initWithContentsOfFile:filePath];
    }else{
        retDic = [NSMutableDictionary dictionary];
    }
    return retDic;
}

-(void)writeToDisk:(NSDictionary *)dic{
    if (self.beginFlag) {
        return;
    }
    NSString *filePath = [self getTableNameFilePath];
    BOOL ret = [dic writeToFile:filePath atomically:YES];
    if (!ret) {
        NSLog(@"写入文件[%@]时发生错误",[self description]);
    }
}

-(id)convertValue:(id)value{
    if ([value conformsToProtocol:@protocol(CUSDeserializable)]) {
        return [value deserialize];
    }else{
        return value;
    }
}
@end
