//
//  CUSSerializer.h
//  CUSSerializer
//
//  Created by zhangyu on 14-5-13.
//  Copyright (c) 2014 zhangyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#define CUS_OC_CLASSNAME @"OC_ClassName" //Model class name for deserializing when crate the model implitation.

/*
 *Serializable protocol
 */
@protocol CUSSerializable <NSObject>
//serialize method
-(id)serialize;
@end


/*
 *Deserializable protocol
 */
@protocol CUSDeserializable <NSObject>
//serialize method
-(id)deserialize;
@end


/*
 *Base Model for serializing
 */
@interface CUSModel : NSObject<CUSSerializable>
-(NSDictionary *)serialize;

//serialize helper method

//Ignore the property for key. Default serialize all of the model properties.
-(BOOL)serializeIgnoreKey:(NSString *)key;
//Invoke the method when set value to Dictionary,you can override it by youself.
-(void)setValueToDictionary:(NSMutableDictionary *)dic withKey:(NSString *)key withValue:(id)value;
@end


/*
 *NSArray
 */
@interface NSArray(CUSSerializer)<CUSSerializable,CUSDeserializable>
-(NSArray *)serialize;
-(NSArray *)deserialize;
@end


/*
 *NSDictionary
 */
@interface NSDictionary(CUSSerializer)<CUSSerializable,CUSDeserializable>
-(NSDictionary *)serialize;

//NSDictionary deserialize to Model or NSDictionary
-(id)deserialize;
@end


/*
 *CUSSerializer,static method
 */
@interface CUSSerializer : NSObject
//@className : the string of source class name
//@mappingName : the name defined by yourself
+(void)setClassMapping:(NSString *)className mappingFor:(NSString *)mappingName;
+(NSString *)getClassName:(NSString *)mappingName;
+(NSString *)getMappingName:(NSString *)className;

//set NO to close print log
+(void)setLogStatus:(BOOL)status;
+(BOOL)getLogStatus;
@end

