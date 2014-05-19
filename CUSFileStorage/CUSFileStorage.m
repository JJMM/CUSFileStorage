/**
 @version 1.00 2014/05/13 Creation
 @copyright Copyright (c) 2014 zhangyu. All rights reserved.
 */
#import "CUSFileStorage.h"

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
    return convertValue;
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


/**
 @result get value list
 */
- (NSUInteger)count{
    NSMutableDictionary *serializStorageDic = [self getStorageDB];
    return [serializStorageDic count];
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
-(NSString *)getTableNameFile{
    return [NSString stringWithFormat:@"%@.plist",[self getTableName]];
}

-(NSString*)getFilePath:(NSString *)fileName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:fileName];
}

//real file name
-(NSString *)getTableNameFilePath{
    NSString *filePaht = [NSString stringWithFormat:@"CUS_FS_%@",[self getTableNameFile]];
    return [self getFilePath:filePaht];
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
        retDic = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];;
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
        NSLog(@"error:write file[%@]",[self description]);
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

/////////////////////////CUSFileStorageManager/////////////////////////
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
}
@end
