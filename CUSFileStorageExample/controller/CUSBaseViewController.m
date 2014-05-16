//
//  CUSBaseViewController.m
//  CUSFileStorageExample
//
//  Created by zhangyu on 14-5-15.
//  Copyright (c) 2014年 zhangyu. All rights reserved.
//

#import "CUSBaseViewController.h"
#import "CUSFileStorageManager.h"
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
    CUSFileStorage *storage = [CUSFileStorageManager getFileStorage:@"TestDB"];
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

-(NSInteger)getAddCount{
    return 1;
}
-(void)addButtonClicked:(id)sender{
    NSInteger counter = [self.dataItems count];
    
    for (int i = counter;i<counter + [self getAddCount];i++) {
        [self.dataItems addObject:[NSString stringWithFormat:@"item%i",i]];
        NSMutableArray *array = [NSMutableArray array];
        NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
        [array addObject:path];
    }
    
//    CGFloat time = BNRTimeBlock(^{
        CUSFileStorage *storage = [CUSFileStorageManager getFileStorage:@"TestDB"];
        [storage setObject:self.dataItems forKey:@"array"];
//    });
//    printf ("save to file time: %f\n", time);
    

    
    [self.tableView reloadData];
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
//    NSArray *array = [self.dataItems objectAtIndex:indexPath.row];
//    if (array && [array count] >= 1) {
//        cell.textLabel.text = [array objectAtIndex:0];
//        cell.detailTextLabel.text = [array objectAtIndex:1];
//    }
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *array = [self.dataItems objectAtIndex:indexPath.row];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    
    [CUSFileStorageManager clearAllCache];
}


//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    self.title = @"CUSFileStorage";
//    [self testCode];
//}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

-(void)testCode{
    //init CUSSerializer environment
    [CUSSerializer setLogStatus:NO];
    [CUSSerializer setClassMapping:@"CUSSchool" mappingFor:@"School"];
    [CUSSerializer setClassMapping:@"CUSTeacher" mappingFor:@"Teacher"];
    [CUSSerializer setClassMapping:@"CUSStudent" mappingFor:@"Student"];
    
    //    //load from file
    //    NSString *path = [[NSBundle mainBundle] pathForResource:@"DictionaryFile" ofType:@"plist"];
    //    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:path];
    //    //deserialize to Model
    //    CUSSchool *school = [dictionary deserialize];
    //    //serialize to NSDictionary.It is similar to the file
    //    NSDictionary *serializeDic = [school serialize];
    //    NSLog(@"school:%@",school);
    
    //    self.textView.text = [NSString stringWithFormat:@"%@",serializeDic];
    
    CUSFileStorage *storage = [CUSFileStorageManager getFileStorage:@"TestDB"];
    //    [storage beginUpdates];
    //    for (int i = 0; i < 1000000; i++) {
    //        NSString *key = [NSString stringWithFormat:@"key%i",i];
    ////        CUSSchool *school = [self createSchool];
    ////        school.schoolId = key;
    //        [storage setObject:key forKey:key];
    //    }
    //    [storage endUpdates];
    id obj = [storage objectForFilter:^BOOL(NSString *key, id item) {
        //        CUSSchool *school = (CUSSchool *)item;
        if ([@"key8888" isEqualToString:key]) {
            return YES;
        }
        return NO;
    }];
    //    id obj = [storage objectForKey:@"key8888"];
    //    NSDictionary *serializeDic = [obj serialize];
//    self.textView.text = [NSString stringWithFormat:@"%@",obj];
    
}

////////////////////Example code////////////////////
-(CUSSchool *)createSchool{
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
-(CUSTeacher *)createTeacher:(NSInteger)index{
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
-(CUSStudent *)createStudent:(NSInteger)index{
    CUSStudent *model = [[CUSStudent alloc]init];
    model.iden = [NSString stringWithFormat:@"studentId%i",index];
    model.name = [NSString stringWithFormat:@"studentName%i",index];
    model.age = 15 +index;
    return model;
}

-(void)dicWriteToFile:(NSDictionary *)dic{
    NSString *filePath = [NSString stringWithFormat:@"%@/Documents/DictionaryFile.plist",NSHomeDirectory()];
    [dic writeToFile:filePath atomically:YES];
}
@end
