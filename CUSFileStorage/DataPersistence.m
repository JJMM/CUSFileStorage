//
//  DataPersistence.m
//  JQJXC
//
//  Created by apple on 11-12-31.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//
#import "DataPersistence.h"


@implementation DataPersistence

+(NSString*)getFilePath:(NSString *)fileName{
    //检索Documents目录路径。第二个参数表示将搜索限制在我们的应用程序沙盒中   
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);  
    //每个应用程序只有一个Documents目录   
    NSString *documentsDirectory = [paths objectAtIndex:0];  
    //创建文件名   
    return [documentsDirectory stringByAppendingPathComponent:fileName];  
}

@end
