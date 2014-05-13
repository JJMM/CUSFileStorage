//
//  CUSSerializer.m
//  CUSSerializerExample
//
//  Created by zhangyu on 14-5-13.
//  Copyright (c) 2014 zhangyu. All rights reserved.
//

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

//pre interface
@interface CUSSerializerUtils : NSObject
+(NSArray *)getPropertyListByClass: (Class)clazz;
+(id)deserializeWithDictionary:(NSDictionary *)serializeValue;
@end

//////////////////////CUSModel//////////////////////
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
            [self setValueToDictionary:dic withKey:key withValue:value];
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

-(void)setValueToDictionary:(NSMutableDictionary *)dic withKey:(NSString *)key withValue:(id)value{
    if (!value) {
        return;
    }
    
    if ([value conformsToProtocol:@protocol(CUSSerializable)]) {
        [dic setValue:[value serialize] forKey:key];
    }else{
        [dic setValue:value forKey:key];
    }
}

@end


//////////////////////NSArray//////////////////////
@implementation NSArray(CUSSerializer)
-(NSArray *)serialize{
    NSMutableArray *array = [NSMutableArray array];
    for (id value in self) {
        @try {
            if ([value conformsToProtocol:@protocol(CUSSerializable)]) {
                [array addObject:[value serialize]];
            }else{
                [array addObject:value];
            }
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
            if ([value conformsToProtocol:@protocol(CUSDeserializable)]) {
                [array addObject:[value deserialize]];
            }else{
                [array addObject:value];
            }
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

//////////////////////NSDictionary//////////////////////
@implementation NSDictionary(CUSSerializer)
-(NSDictionary *)serialize{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    NSArray *array = [self allKeys];
    for (NSString *key in array) {
        id value = nil;
        @try {
            value = [self valueForKey:key];
            if (!value) {
                continue;
            }
            if ([value conformsToProtocol:@protocol(CUSSerializable)]) {
                [dic setValue:[value serialize] forKey:key];
            }else{
                [dic setValue:value forKey:key];
            }
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
            if ([value conformsToProtocol:@protocol(CUSDeserializable)]) {
                [classModel setValue:[value deserialize] forKey:key];
            }else{
                [classModel setValue:value forKey:key];
            }
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


//////////////////////Utils//////////////////////
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

//////////////////////static//////////////////////
static BOOL CUSSerializer_LOG_STAUTS = YES;
//for efficiency
static NSMutableDictionary *CUSSerializer_Class_Mapping0;
static NSMutableDictionary *CUSSerializer_Class_Mapping1;
@implementation CUSSerializer
+(void)setClassMapping:(NSString *)className mappingFor:(NSString *)mappingName{
    if (!CUSSerializer_Class_Mapping0) {
        CUSSerializer_Class_Mapping0 = [NSMutableDictionary dictionary];
    }
    
    if (!CUSSerializer_Class_Mapping1) {
        CUSSerializer_Class_Mapping1 = [NSMutableDictionary dictionary];
    }
    
    [CUSSerializer_Class_Mapping0 setValue:className forKey:mappingName];
    [CUSSerializer_Class_Mapping1 setValue:mappingName forKey:className];
}

+(NSString *)getClassName:(NSString *)mappingName{
    NSString *returnValue = [CUSSerializer_Class_Mapping0 objectForKey:mappingName];
    if (returnValue == nil) {
        return mappingName;
    }
    return returnValue;
}

+(NSString *)getMappingName:(NSString *)className{
    NSString *returnValue = [CUSSerializer_Class_Mapping1 objectForKey:className];
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