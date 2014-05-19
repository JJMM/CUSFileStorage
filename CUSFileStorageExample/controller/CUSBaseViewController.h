//
//  CUSBaseViewController.h
//  CUSFileStorageExample
//
//  Created by zhangyu on 14-5-15.
//  Copyright (c) 2014年 zhangyu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CUSSerializer.h"
#import "CUSFileStorage.h"
#import "CUSModelFactory.h"

#import "TSMessage.h"

@interface CUSBaseViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong) UITableView *tableView;

-(NSString *)getDBName;
-(NSInteger)getAddCount;
-(NSString *)getKeyByIndex:(NSInteger)index;

-(id)doCreateItem:(NSInteger)index;
-(void)addButtonClicked:(id)sender;
@end
