//
//  CUSModelFactory.m
//  CUSFileStorageExample
//
//  Created by zhangyu on 14-5-17.
//  Copyright (c) 2014年 zhangyu. All rights reserved.
//

#import "CUSModelFactory.h"
#import <mach/mach_time.h>
CGFloat BNRTimeBlock (void (^block)(void)) {
    mach_timebase_info_data_t info;
    if (mach_timebase_info(&info) != KERN_SUCCESS) return -1.0;
    
    uint64_t start = mach_absolute_time ();
    block ();
    uint64_t end = mach_absolute_time ();
    uint64_t elapsed = end - start;
    
    uint64_t nanos = elapsed * info.numer / info.denom;
    return (CGFloat)nanos / NSEC_PER_SEC;
    
}

@implementation CUSModelFactory
+(CUSSchool *)createSchool{
    CUSSchool *school = [[CUSSchool alloc]init];
    school.schoolId = @"id0123456";
    school.schoolName = @"qinghuadaxue";
    school.schoolAddress = nil;
    school.schoolPost = 123;
    school.schoolFloat = 1234.5678;
    school.boolValue = YES;
    school.ch = 's';
    school.schoolNumber = [NSNumber numberWithInt:6];
    school.schoolDate = [NSDate date];
    school.headmaster = [self createTeacher:99];
    NSMutableArray *teacherArray = [NSMutableArray array];
    for (int i = 0; i < 3; i++) {
        [teacherArray addObject:[self createTeacher:i]];
    }
    school.teacherArray = teacherArray;
    
    NSMutableDictionary *teacherDictionary = [NSMutableDictionary dictionary];
    for (int i = 0; i < 5; i++) {
        NSString *key = [NSString stringWithFormat:@"key%i",i];
        [teacherDictionary setObject:[self createTeacher:i] forKey:key];
    }
    school.teacherDictionary = teacherDictionary;
    return school;
}

+(CUSTeacher *)createTeacher:(NSInteger)index{
    CUSTeacher *model = [[CUSTeacher alloc]init];
    model.iden = [NSString stringWithFormat:@"teacherId%i",index];
    model.name = [NSString stringWithFormat:@"teacherName%i",index];
    model.age = 30 +index;
    model.courseName = [NSString stringWithFormat:@"courseName%i",index];
    
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < 2; i++) {
        [array addObject:[self createStudent:i]];
    }
    model.studentArray = array;
    
    return model;
}

+(CUSStudent *)createStudent:(NSInteger)index{
    CUSStudent *model = [[CUSStudent alloc]init];
    model.iden = [NSString stringWithFormat:@"studentId%i",index];
    model.name = [NSString stringWithFormat:@"studentName%i",index];
    model.age = 15 +index;
    return model;
}
@end
