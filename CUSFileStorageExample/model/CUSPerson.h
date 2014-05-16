//
//  CUSPerson.h
//  CUSSerializerExample
//
//  Created by zhangyu on 14-5-12.
//  Copyright (c) 2014年 zhangyu. All rights reserved.
//

#import "CUSSerializer.h"

@interface CUSPerson : CUSModel
@property(nonatomic,strong)NSString *iden;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,assign)NSInteger age;
@end
