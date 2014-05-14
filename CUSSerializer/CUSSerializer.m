/**
 @version 1.00 2014/05/13 Creation
 @copyright Copyright (c) 2014 zhangyu. All rights reserved.
 */

#import "CUSSerializer.h"
#import <objc/runtime.h>
#if __has_feature(objc_arc)
#define CUS_AUTORELEASE(exp) exp
#define CUS_RELEASE(exp) exp
#define CUS_RETAIN(exp) exp
#else
#define CUS_AUTORELEASE(exp) [exp autorelease]
#define CUS_RELEASE(exp) [exp release]
#define CUS_RETAIN(exp) [exp retain]
#endif

/**
 @class CUSModel
 @abstract pre define interface
 */
@interface CUSSerializerUtils : NSObject

/**
 @abstract get all properties from class
 @param clazz
 @result NSArray
 */
+(NSArray *)getPropertyListByClass: (Class)clazz;

/**
 @abstract create instance
 @param serializeValue NSDictionary
 @result NSDictionary or Model
 */
+(id)deserializeWithDictionary:(NSDictionary *)serializeValue;
@end

//////////////////////////////CUSModel//////////////////////////////
@implementation CUSModel

-(NSDictionary *)serialize{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    NSArray *array = [CUSSerializerUtils getPropertyListByClass:[self class]];
    for (NSString *key in array) {
        id value = nil;
        @try {
            if ([self serializeIgnoreKey:key]) {
                continue;
            }
            value = [self valueForKey:key];
            [self serializeBoxing:dic withKey:key withValue:value];
        }
        @catch (NSException *exception) {
            if ([CUSSerializer getLogStatus]) {
                NSLog(@"exception:%@\nkey:%@   value:%@",exception,key,value);
            }
        }
    }
    NSString *className = [CUSSerializer getMappingName:NSStringFromClass([self class])];
    [dic setValue:className forKey:CUS_OC_CLASSNAME];
    return dic;
}

-(BOOL)serializeIgnoreKey:(NSString *)key{
    return NO;
}

-(void)serializeBoxing:(id)serializeContainner withKey:(NSString *)key withValue:(id)value{
    if (!value) {
        return;
    }
    NSMutableDictionary *dic = (NSMutableDictionary *)serializeContainner;
    if ([value conformsToProtocol:@protocol(CUSSerializable)]) {
        [dic setValue:[value serialize] forKey:key];
    }else{
        [dic setValue:value forKey:key];
    }
}

-(BOOL)deserializeIgnoreKey:(NSString *)key{
    if ([CUS_OC_CLASSNAME isEqualToString:key]) {
        return  YES;
    }
    return NO;
}

-(void)deserializeBoxing:(id)deserializeContainner withKey:(NSString *)key withValue:(id)value{
    if ([self deserializeIgnoreKey:key]) {
        return;
    }
    if (!value) {
        return;
    }
    if ([value conformsToProtocol:@protocol(CUSDeserializable)]) {
        [self setValue:[value deserialize] forKey:key];
    }else{
        [self setValue:value forKey:key];
    }
}

-(void)deserialize:(NSDictionary *)dic{
    NSArray *array = [dic allKeys];
    for (NSString *key in array) {
        id value = nil;
        @try {
            if ([self deserializeIgnoreKey:key]) {
                continue;
            }
            value = [dic valueForKey:key];
            [self deserializeBoxing:dic withKey:key withValue:value];
        }
        @catch (NSException *exception) {
            if ([CUSSerializer getLogStatus]) {
                NSLog(@"exception:%@\nkey:%@   value:%@",exception,key,value);
            }
        }
    }
}
@end


//////////////////////////////NSArray//////////////////////////////
@interface NSArray(CUSSerializerBoxing)<CUSSerializableBoxing,CUSDeserializableBoxing>
@end

@implementation NSArray(CUSSerializerBoxing)
-(void)serializeBoxing:(id)serializeContainner withKey:(NSString *)key withValue:(id)value{
    NSMutableArray *array = (NSMutableArray *)serializeContainner;
    if ([value conformsToProtocol:@protocol(CUSSerializable)]) {
        [array addObject:[value serialize]];
    }else{
        [array addObject:value];
    }
}

-(void)deserializeBoxing:(id)deserializeContainner withKey:(NSString *)key withValue:(id)value{
    NSMutableArray *array = (NSMutableArray *)deserializeContainner;
    if ([value conformsToProtocol:@protocol(CUSDeserializable)]) {
        [array addObject:[value deserialize]];
    }else{
        [array addObject:value];
    }
}
@end

@implementation NSArray(CUSSerializer)

-(NSArray *)serialize{
    NSMutableArray *array = [NSMutableArray array];
    for (id value in self) {
        @try {
            [self serializeBoxing:array withKey:nil withValue:value];
        }
        @catch (NSException *exception) {
            if ([CUSSerializer getLogStatus]) {
                NSLog(@"exception:%@\nvalue:%@",exception,value);
            }
        }
    }
    return array;
}

-(NSArray *)deserialize{
    NSMutableArray *array = [NSMutableArray array];
    for (id value in self) {
        @try {
            [self deserializeBoxing:array withKey:nil withValue:value];
        }
        @catch (NSException *exception) {
            if ([CUSSerializer getLogStatus]) {
                NSLog(@"exception:%@\nvalue:%@",exception,value);
            }
        }
    }
    return array;
}
@end

//////////////////////////////NSDictionary//////////////////////////////
@interface NSDictionary(CUSSerializerBoxing)<CUSSerializableBoxing,CUSDeserializableBoxing>
@end

@implementation NSDictionary(CUSSerializerBoxing)
-(void)serializeBoxing:(id)serializeContainner withKey:(NSString *)key withValue:(id)value{
    NSMutableDictionary *dic = (NSMutableDictionary *)serializeContainner;
    if (!value) {
        return;
    }
    if ([value conformsToProtocol:@protocol(CUSSerializable)]) {
        [dic setValue:[value serialize] forKey:key];
    }else{
        [dic setValue:value forKey:key];
    }
}

-(void)deserializeBoxing:(id)deserializeContainner withKey:(NSString *)key withValue:(id)value{
    if (!value) {
        return;
    }
    id classModel = deserializeContainner;
    
    id processValue = value;
    if ([value conformsToProtocol:@protocol(CUSDeserializable)]) {
        processValue = [value deserialize];
    }
    
    if ([classModel isKindOfClass:[NSDictionary class]]) {
        [classModel setValue:processValue forKey:key];
    }else{
        if ([classModel conformsToProtocol:@protocol(CUSDeserializableBoxing)] ) {
            [classModel deserializeBoxing:nil withKey:key withValue:processValue];
        }else{
            [classModel setValue:processValue forKey:key];
        }
    }
}
@end
@implementation NSDictionary(CUSSerializer)
-(NSDictionary *)serialize{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    NSArray *array = [self allKeys];
    for (NSString *key in array) {
        id value = nil;
        @try {
            value = [self valueForKey:key];
            [self serializeBoxing:dic withKey:key withValue:value];
        }
        @catch (NSException *exception) {
            if ([CUSSerializer getLogStatus]) {
                NSLog(@"exception:%@\nkey:%@   value:%@",exception,key,value);
            }
        }
    }
    return dic;
}

-(id)deserialize{
    NSArray *array = [self allKeys];
    //classModel may be Model or NSDictionary
    id classModel = [CUSSerializerUtils deserializeWithDictionary:self];
    for (NSString *key in array) {
        id value = nil;
        @try {
            value = [self valueForKey:key];
            if (!value) {
                continue;
            }
            [self deserializeBoxing:classModel withKey:key withValue:value];
        }
        @catch (NSException *exception) {
            if ([CUSSerializer getLogStatus]) {
                NSLog(@"exception:%@\nkey:%@   value:%@",exception,key,value);
            }
        }
    }
    return classModel;
}
@end


//////////////////////////////Utils//////////////////////////////
@implementation CUSSerializerUtils

+(NSArray *)getPropertyListByClass: (Class)clazz
{
    NSMutableArray *propertyArray = [NSMutableArray array];
    
    [CUSSerializerUtils addPropertyListByClass:clazz withArray:propertyArray];
    
    return propertyArray;
}

+(NSArray *)addPropertyListByClass: (Class)clazz withArray:(NSMutableArray *)propertyArray{
    u_int count;
    
    objc_property_t *properties  = class_copyPropertyList(clazz, &count);
    
    for (int i = 0; i < count ; i++)
    {
        const char* propertyName = property_getName(properties[i]);
        [propertyArray addObject: [NSString  stringWithUTF8String: propertyName]];
    }
    
    free(properties);
    Class superClass = [clazz superclass];
    if ([NSObject class] != superClass) {
        [self addPropertyListByClass:superClass withArray:propertyArray];
    }
    
    return propertyArray;
}

+(id)deserializeWithDictionary:(NSDictionary *)serializeValue{
    NSString *mappingName = [serializeValue valueForKey:CUS_OC_CLASSNAME];
    NSString *className = [CUSSerializer getClassName:mappingName];
    id classModel;
    if (className) {
        //Model
        Class clazz = NSClassFromString(className);
        id model = CUS_AUTORELEASE([[clazz alloc]init]);
        classModel = model;
    }else{
        //NSDictionary
        classModel = [NSMutableDictionary dictionary];
    }
    return classModel;
}
@end

//////////////////////////////static//////////////////////////////
static BOOL CUSSerializer_LOG_STAUTS = YES;
static NSMutableDictionary *CUS_Mapping0;
static NSMutableDictionary *CUS_Mapping1;//for efficiency
@implementation CUSSerializer

+(void)setClassMapping:(NSString *)className mappingFor:(NSString *)mappingName{
    if (!CUS_Mapping0) {
        CUS_Mapping0 = [NSMutableDictionary dictionary];
    }
    
    if (!CUS_Mapping1) {
        CUS_Mapping1 = [NSMutableDictionary dictionary];
    }
    
    [CUS_Mapping0 setValue:className forKey:mappingName];
    [CUS_Mapping1 setValue:mappingName forKey:className];
}

+(NSString *)getClassName:(NSString *)mappingName{
    NSString *returnValue = [CUS_Mapping0 objectForKey:mappingName];
    if (returnValue == nil) {
        return mappingName;
    }
    return returnValue;
}

+(NSString *)getMappingName:(NSString *)className{
    NSString *returnValue = [CUS_Mapping1 objectForKey:className];
    if (returnValue == nil) {
        return className;
    }
    return returnValue;
}

+(void)setLogStatus:(BOOL)status{
    CUSSerializer_LOG_STAUTS = status;
}

+(BOOL)getLogStatus{
    return CUSSerializer_LOG_STAUTS;
}
@end