/**
 @header CUSFileStorage.h
 @abstract file storage tool
 @discussion A simple IOS file storage system using CUSSerializer achieve automatic support recursive model storage
 @link
    https://github.com/JJMM/CUSSerializer
    https://github.com/JJMM/CUSFileStorage
 @version 1.00 2014/05/13 Creation
 @copyright Copyright (c) 2014 zhangyu. All rights reserved.
 */
#import "CUSSerializer.h"

/**
 @abstract traversal of all item, its efficiency is low
 */
typedef BOOL(^CUSFilter)(NSString *key,id item);

/**
 @abstract Don't alloc by yourself.
        Use the public method named shareFileStorage instead of alloc.
 */
@interface CUSFileStorage : NSObject
@property(nonatomic,strong)NSString *tableName;

/**
 @abstract add or update an object
 @param anObject
            base value or CUSSerializable
 @param aKey
            a string key
 */
- (void)setObject:(id)anObject forKey:(NSString *)aKey;

/**
 @abstract get object by primary key
 @param aKey
            a string key
 @result object
 */
- (id)objectForKey:(NSString *)aKey;

/**
 @abstract get object by filter
 @param filter
            CUSFilter
 @result object
 */
- (id)objectForFilter:(CUSFilter)filter;

/**
 @abstract delete object by primary key
 @param aKey
            a string key
 */
- (void)removeObjectForKey:(NSString *)aKey;

/**
 @abstract delete object by filter
 @param filter
            CUSFilter
 */
- (void)removeObjectForFilter:(CUSFilter)filter;

/**
 @abstract delete file
            WARNNING:remove all datas
 */
- (void)removeDB;

/**
 @result get key list for cycle
 */
- (NSArray *)allKeys;

/**
 @result get value list
 */
- (NSArray *)allValues;

/**
 @abstract get object by filter
 @param filter
            CUSFilter
 @result object
 */
- (NSArray *)allValuesForFilter:(CUSFilter)filter;


/**
 @result get count
 */
- (NSUInteger)count;

/**
 @abstract Don't save data to disk until the method named endUpdates is called
 */
-(void)beginUpdates;

/**
 @abstract end updates.It will save data to  disk.
 */
-(void)endUpdates;

/**
 @abstract clear cache
 */
-(void)clearCache;
@end

/**
 @abstract CUSFileStorageManager
 */
@interface CUSFileStorageManager : NSObject

/**
 @abstract get an shared instance of CUSFileStorage
 @result the default instance of CUSFileStorage
 */
+(CUSFileStorage *)getFileStorage;

/**
 @abstract get an shared instance of CUSFileStorage
 @param tableName
            the file name
 @result the instance of CUSFileStorage
 */
+(CUSFileStorage *)getFileStorage:(NSString *)tableName;

/**
 @abstract clear all CUSFileStorage cache
 */
+(void)clearAllCache;
@end
