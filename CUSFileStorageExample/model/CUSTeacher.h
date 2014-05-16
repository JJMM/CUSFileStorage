//
//  CUSTeacher.h
//  CUSSerializerExample
//
//  Created by zhangyu on 14-5-12.
//  Copyright (c) 2014年 zhangyu. All rights reserved.
//

#import "CUSPerson.h"

@interface CUSTeacher : CUSPerson
@property(nonatomic,strong)NSString *courseName;
@property(nonatomic,strong)NSArray *studentArray;
@end
