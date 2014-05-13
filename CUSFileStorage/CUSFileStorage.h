//
//  CUSFileStorage.h
//  CUSFileStorageExample
//
//  Created by zhangyu on 14-5-13.
//  Copyright (c) 2014 zhangyu. All rights reserved.
//
#import "CUSSerializer.h"
/**
 * Don't alloc by yourself.
 * Use the public method named shareFileStorage instead of alloc.
 */
@interface CUSFileStorage : NSObject
@property(nonatomic,strong)NSString *tableName;

+(id)shareFileStorage:(NSString *)tableName;

/**
 * @abstract add or update an object
 * @param anObject
 *          base value or CUSSerializable
 * @param aKey
 *          a string key
 */
- (void)setObject:(id)anObject forKey:(NSString *)aKey;

/**
 * @abstract get object by primary key
 * @param aKey
 *          a string key
 * @result 
 *          object
 */
- (id)objectForKey:(NSString *)aKey;

/**
 * @abstract delete object by primary key
 * @param aKey
 *          a string key
 */
- (void)removeObjectForKey:(NSString *)aKey;

/**
 * @result get key list for cycle
 */
- (NSArray *)allKeys;


/**
 * @result get value list
 */
- (NSArray *)allValues;


/**
 * Don't save data to disk until the method named endUpdates is called
 */
-(void)beginUpdates;

/**
 * end updates.It will save data to  disk.
 */
-(void)endUpdates;
@end
