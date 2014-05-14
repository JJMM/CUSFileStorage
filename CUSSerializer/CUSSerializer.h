/**
 @header CUSSerializer.h
 @abstract Automatic serialization tool
 @discussion Automatic serialization tool,convert model to NSDictionary, support recursive conversion NSDictionary, NSArray data structures, In addition, it's very suitable for use with JSONKit
 @code
 NSDictionary *dictionary = [NSDictionary dictionary];
 CUSSchool *school = [dictionary deserialize];
 NSDictionary *serializeDic = [school serialize];
 
 @link
 https://github.com/JJMM/CUSSerializer
 @version 1.00 2014/05/13 Creation
 @copyright Copyright (c) 2014 zhangyu. All rights reserved.
 */

#import <Foundation/Foundation.h>

//using it to create model instance
#define CUS_OC_CLASSNAME @"OC_ClassName"


/**
 @protocol CUSSerializable
 @abstract To serialize model, must implement this protocol
 */
@protocol CUSSerializable <NSObject>

/**
 @abstract serialize method
 @result object
 NSDictionary or NSArray
 */
-(id)serialize;
@end


/**
 @protocol CUSSerializableBoxing
 @abstract serialize boxing
 */
@protocol CUSSerializableBoxing <NSObject>

/**
 @abstract Invoke the method when set value to Dictionary,you can override it by youself.
 @param serializeContainner
 NSMutableDictionary or NSMutableArray
 @param key
 a string key
 @param value
 a value
 */
-(void)serializeBoxing:(id)serializeContainner withKey:(NSString *)key withValue:(id)value;

@optional
/**
 @abstract Ignore the property for key. Default serialize all of the model properties.
 @result BOOL
 YES:ignore key
 NO:don't ignore key.Default value is NO
 */
-(BOOL)serializeIgnoreKey:(NSString *)key;
@end


/**
 @protocol CUSDeserializable
 @abstract To deserialize model, must implement this protocol
 */
@protocol CUSDeserializable <NSObject>

/**
 @abstract serialize method
 @result object
 Model,NSDictionary or NSArray
 */
-(id)deserialize;
@end


/**
 @protocol CUSDeserializableBoxing
 @abstract deserializable boxing
 */
@protocol CUSDeserializableBoxing <NSObject>

/**
 @abstract Invoke the method when set value to Dictionary,you can override it by youself.
 @param deserializeContainner
 NSMutableDictionary , NSMutableArray or Model
 @param key
 a string key
 @param value
 a value
 */
-(void)deserializeBoxing:(id)deserializeContainner withKey:(NSString *)key withValue:(id)value;

@optional
/**
 @abstract Ignore the property for key. Default deserialize all of the model properties.
 @result BOOL
 YES:ignore key
 NO:don't ignore key.Default value is NO
 */
-(BOOL)deserializeIgnoreKey:(NSString *)key;
@end


/**
 @class CUSModel
 @abstract Base Model for serializing.It has been implemented in the CUSSerializable ,CUSSerializableBoxing,CUSDeserializableBoxing protocol
 */
@interface CUSModel : NSObject<CUSSerializable,CUSSerializableBoxing,CUSDeserializableBoxing>

/**
 @abstract override for changing reutrn value type
 @result NSDictionary
 */
-(NSDictionary *)serialize;

/**
 @abstract boxing the dictionary and set the values to model properties.You must create an instance before invoking the method
 @param NSDictionary
 */
-(void)deserialize:(NSDictionary *)dic;
@end


/**
 @category NSArray
 @abstract NSArray.It has been implemented in the CUSSerializable,CUSDeserializable protocol
 */
@interface NSArray(CUSSerializer)<CUSSerializable,CUSDeserializable>

/**
 @abstract override for changing reutrn value type
 @result NSArray recursive serialize the value in NSArray
 */
-(NSArray *)serialize;

/**
 @abstract deserialize method
 @result NSArray recursive deserialize the value in NSArray
 */
-(NSArray *)deserialize;
@end


/**
 @category NSDictionary
 @abstract NSDictionary.It has been implemented in the CUSSerializable,CUSDeserializable protocol
 */
@interface NSDictionary(CUSSerializer)<CUSSerializable,CUSDeserializable>

/**
 @abstract override for changing reutrn value type
 @result NSDictionary recursive serialize the value in NSArray
 */
-(NSDictionary *)serialize;

/**
 @abstract deserialize to Model or NSDictionary
 @result Model or NSDictionary
 recursive deserialize the value in NSDictionary
 */
-(id)deserialize;
@end


/**
 @class CUSSerializer
 @abstract CUSSerializer,static method
 */
@interface CUSSerializer : NSObject

/**
 @abstract mapping class name to other name
 @param className
 the source code class name
 @param mappingName
 the name defined by yourself
 */
+(void)setClassMapping:(NSString *)className mappingFor:(NSString *)mappingName;

/**
 @abstract get the source code class name by mappingName
 @param mappingName
 the name defined by yourself
 @result NSString
 className
 */
+(NSString *)getClassName:(NSString *)mappingName;

/**
 @abstract get mappingName by className
 @param className
 the source code class name
 @result NSString
 mappingName
 */
+(NSString *)getMappingName:(NSString *)className;

/**
 @abstract open or close log
 @param status
 YES:open print log.Default value is YES
 NO:close print log
 */
+(void)setLogStatus:(BOOL)status;

/**
 @abstract get the log status
 @result BOOL
 */
+(BOOL)getLogStatus;
@end

