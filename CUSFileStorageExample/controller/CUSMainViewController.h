//
//  CUSMainViewController.h
//  CUSSerializerExample
//
//  Created by zhangyu on 14-5-13.
//  Copyright (c) 2014 zhangyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CUSMainViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) NSMutableArray *dataItems;
@end
