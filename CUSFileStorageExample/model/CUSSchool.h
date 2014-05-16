//
//  CUSSchool.h
//  CUSSerializerExample
//
//  Created by zhangyu on 14-5-12.
//  Copyright (c) 2014年 zhangyu. All rights reserved.
//

#import "CUSSerializer.h"
#import "CUSTeacher.h"
@interface CUSSchool : CUSModel
@property(nonatomic,strong)NSString *schoolId;
@property(nonatomic,strong)NSString *schoolName;
@property(nonatomic,strong)NSString *schoolAddress;
@property(nonatomic,assign)NSInteger schoolPost;
@property(nonatomic,assign)CGFloat schoolFloat;
@property(nonatomic,assign)BOOL boolValue;
@property(nonatomic,assign)char ch;
@property(nonatomic,strong)NSNumber *schoolNumber;
@property(nonatomic,strong)NSDate *schoolDate;
@property(nonatomic,strong)CUSTeacher *headmaster;
@property(nonatomic,strong)NSArray *teacherArray;
@property(nonatomic,strong)NSDictionary *teacherDictionary;
@property(nonatomic,strong)UIImage *image;
//The property can't be serialized;
//@property(nonatomic,assign)int *valueArray;
@end
