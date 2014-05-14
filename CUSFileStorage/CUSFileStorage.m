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
@property(nonatomic,strong) NSMutableDictionary *storageDB;
@end

@implementation CUSFileStorage
@synthesize tableName = _tableName;
@synthesize beginFlag;

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
    NSMutableDictionary *serializStorageDic = [self readFromDisk];
    if ([anObject conformsToProtocol:@protocol(CUSSerializable)]) {
        [serializStorageDic setObject:[anObject serialize] forKey:aKey];
    }else{
        [serializStorageDic setObject:anObject forKey:aKey];
    }
    [self writeToDisk:serializStorageDic];
    
    
    if (self.beginFlag) {
        return;
    }
}

- (id)objectForKey:(NSString *)aKey{
    if (!aKey) {
        return nil;
    }
    NSMutableDictionary *serializStorageDic = [self readFromDisk];
    id value = [serializStorageDic objectForKey:aKey];
    
    return value;
}

-(id)objectForFilter:(id<CUSFilter>)filter{
    return nil;
}

- (void)removeObjectForKey:(NSString *)aKey{
    if (!aKey) {
        return;
    }
    NSMutableDictionary *serializStorageDic = [self readFromDisk];
    [serializStorageDic removeObjectForKey:aKey];
    [self writeToDisk:serializStorageDic];
    
    if (self.beginFlag) {
        return;
    }
}

- (NSArray *)allKeys{
    NSMutableDictionary *serializStorageDic = [self readFromDisk];
    return [serializStorageDic allKeys];

}

- (NSArray *)allValues{
    return nil;
}

- (NSArray *)allValuesForFilter:(id<CUSFilter>)filter{
    return nil;
}

-(void)beginUpdates{
    self.beginFlag = YES;
}

-(void)endUpdates{
    self.beginFlag = NO;
    //save to disk
}

-(void)clearCache{
    
}
///////////////////internal method///////////////////////
//获取表存储文件名
-(NSString *)getTableNameFile{
    return [NSString stringWithFormat:@"%@.plist",[self getTableName]];
}
//获取文件真实路径
-(NSString *)getTableNameFilePath{
    NSString *filePaht = [NSString stringWithFormat:@"SYSTMETABLE_%@",[self getTableNameFile]];
    return [DataPersistence getFilePath:filePaht];
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
    NSString *filePath = [self getTableNameFilePath];
    BOOL ret = [dic writeToFile:filePath atomically:YES];
    if (!ret) {
        NSLog(@"写入文件[%@]时发生错误",[self description]);
    }
}
@end
