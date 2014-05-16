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


- (void)removeObjectForFilter:(CUSFilter)filter;

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
