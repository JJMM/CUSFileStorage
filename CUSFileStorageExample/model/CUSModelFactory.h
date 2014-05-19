//
//  CUSModelFactory.h
//  CUSFileStorageExample
//
//  Created by zhangyu on 14-5-17.
//  Copyright (c) 2014年 zhangyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CUSSchool.h"
#import "CUSTeacher.h"
#import "CUSStudent.h"

@interface CUSModelFactory : NSObject
+(CUSSchool *)createSchool;

+(CUSTeacher *)createTeacher:(NSInteger)index;

+(CUSStudent *)createStudent:(NSInteger)index;

CGFloat BNRTimeBlock (void (^block)(void));
@end
