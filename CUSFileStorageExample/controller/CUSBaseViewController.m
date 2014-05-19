//
//  CUSBaseViewController.m
//  CUSFileStorageExample
//
//  Created by zhangyu on 14-5-15.
//  Copyright (c) 2014年 zhangyu. All rights reserved.
//

#import "CUSBaseViewController.h"

@interface CUSBaseViewController ()

@end

@implementation CUSBaseViewController
@synthesize tableView = _tableView;
@synthesize dataItems;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dataItems = [NSMutableArray arrayWithArray:[self loadDataItems]];
    }
    return self;
}

-(NSMutableArray *)loadDataItems{
    CUSFileStorage *storage = [CUSFileStorageManager getFileStorage:[self getDBName]];
    NSMutableArray *array = [storage objectForKey:@"array"];
    if (array) {
        return array;
    }else{
        return [NSMutableArray array];
    }
}

- (void)viewDidLoad
{
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
-(NSString *)getDBName{
    return @"TestDB";
}
-(NSInteger)getAddCount{
    return 1;
}
-(void)addButtonClicked:(id)sender{
    NSInteger counter = [self.dataItems count];
    
    for (int i = counter;i<counter + [self getAddCount];i++) {
        [self.dataItems addObject:[self doCreateItem:i]];
    }
    
    CGFloat time = BNRTimeBlock(^{
        CUSFileStorage *storage = [CUSFileStorageManager getFileStorage:[self getDBName]];
        [storage setObject:self.dataItems forKey:@"array"];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataItems count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CUS_CELL";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    return cell;
}

- (void)didReceiveMemoryWarning
{
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
