//
//  CUSBaseViewController.h
//  CUSFileStorageExample
//
//  Created by zhangyu on 14-5-15.
//  Copyright (c) 2014年 zhangyu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CUSSerializer.h"
#import "CUSSchool.h"
#import "CUSTeacher.h"
#import "CUSStudent.h"
#import "CUSFileStorageManager.h"

#import <mach/mach_time.h>
//CGFloat BNRTimeBlock (void (^block)(void)) {
//    mach_timebase_info_data_t info;
//    if (mach_timebase_info(&info) != KERN_SUCCESS) return -1.0;
//    
//    uint64_t start = mach_absolute_time ();
//    block ();
//    uint64_t end = mach_absolute_time ();
//    uint64_t elapsed = end - start;
//    
//    uint64_t nanos = elapsed * info.numer / info.denom;
//    return (CGFloat)nanos / NSEC_PER_SEC;
//    
//}


@interface CUSBaseViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *dataItems;

-(void)addButtonClicked:(id)sender;

-(NSInteger)getAddCount;
-(NSMutableArray *)loadDataItems;
@end
