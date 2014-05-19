//
//  CUSBaseViewController.m
//  CUSFileStorageExample
//
//  Created by zhangyu on 14-5-15.
//  Copyright (c) 2014年 zhangyu. All rights reserved.
//

#import "CUSBaseViewController.h"

@implementation CUSBaseViewController
@synthesize tableView = _tableView;

-(NSString *)getKeyByIndex:(NSInteger)index{
    return [NSString stringWithFormat:@"key%i",index];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
        
        self.navigationController.navigationBar.translucent = NO;
        self.tabBarController.tabBar.translucent = NO;
    }
#endif
    
    self.tableView = [[UITableView alloc]init];
    self.tableView.frame = self.view.bounds;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc]initWithTitle:[NSString stringWithFormat:@"Add %i",[self getAddCount]] style:UIBarButtonItemStyleDone target:self action:@selector(addButtonClicked:)];
    
    self.navigationItem.rightBarButtonItem = buttonItem;
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

-(NSString *)getDBName{
    return @"TestDB";
}

-(NSInteger)getAddCount{
    return 1;
}

-(void)addButtonClicked:(id)sender{
    CUSFileStorage *storage = [CUSFileStorageManager getFileStorage:[self getDBName]];
    NSInteger counter = [storage count];
    
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    for (int i = counter;i<counter + [self getAddCount];i++) {
        [tempDic setObject:[self doCreateItem:i] forKey:[self getKeyByIndex:i]];
    }
    
    NSArray *keyArray = [tempDic allKeys];
    
    CGFloat time = BNRTimeBlock(^{
        //Multiple values
        [storage beginUpdates];
        for (NSString *key in keyArray) {
            [storage setObject:[tempDic objectForKey:key] forKey:key];
        }
        [storage endUpdates];
        
    });
    NSString *timeStr = [NSString stringWithFormat:@"second: %f\n", time];
    NSLog(@"%@",timeStr);
    if ([TSMessage isNotificationActive]) {
        [TSMessage dismissActiveNotification];
    }
    [TSMessage showNotificationInViewController:self title:@"save to file time" subtitle:timeStr type:TSMessageNotificationTypeMessage];
    
    [self.tableView reloadData];
}

-(id)doCreateItem:(NSInteger)index{
    return [NSString stringWithFormat:@"item%i",index];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    CUSFileStorage *storage = [CUSFileStorageManager getFileStorage];
//    NSString *value = [storage objectForKey:@"key01"];
    
    CUSFileStorage *storage = [CUSFileStorageManager getFileStorage];
    CUSStudent *model = [storage objectForKey:@"key01"];
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    CUSFileStorage *storage = [CUSFileStorageManager getFileStorage:[self getDBName]];
    return [storage count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CUSFileStorage *storage = [CUSFileStorageManager getFileStorage:[self getDBName]];
    static NSString *CellIdentifier = @"CUS_CELL";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    NSString *rowKey = [self getKeyByIndex:indexPath.row];
    NSString *value = [storage objectForKey:rowKey];
    cell.textLabel.text = rowKey;
    cell.detailTextLabel.text = value;
    
    return cell;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    [CUSFileStorageManager clearAllCache];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if ([TSMessage isNotificationActive]) {
        [TSMessage dismissActiveNotification];
    }
}
@end
