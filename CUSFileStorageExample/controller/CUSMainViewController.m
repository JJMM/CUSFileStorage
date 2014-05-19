//
//  CUSMainViewController.m
//  CUSSerializerExample
//
//  Created by zhangyu on 14-5-13.
//  Copyright (c) 2014 zhangyu. All rights reserved.
//

#import "CUSMainViewController.h"

@interface CUSMainViewController ()

@end

@implementation CUSMainViewController
@synthesize dataItems;

-(void)loadData{
    self.dataItems = [NSMutableArray array];
    [self.dataItems addObject:[NSArray arrayWithObjects:@"One string dictionary",@"",@"CUSExampleViewController0", nil]];
    [self.dataItems addObject:[NSArray arrayWithObjects:@"Multi string dictionary",@"",@"CUSExampleViewController1", nil]];
    [self.dataItems addObject:[NSArray arrayWithObjects:@"One string array",@"",@"CUSExampleViewController2", nil]];
    [self.dataItems addObject:[NSArray arrayWithObjects:@"Multi string array",@"",@"CUSExampleViewController3", nil]];
    [self.dataItems addObject:[NSArray arrayWithObjects:@"One object array",@"",@"CUSExampleViewController4", nil]];
    [self.dataItems addObject:[NSArray arrayWithObjects:@"Multi object array",@"",@"CUSExampleViewController5", nil]];
    [self.dataItems addObject:[NSArray arrayWithObjects:@"One recursion object array",@"",@"CUSExampleViewController6", nil]];
    [self.dataItems addObject:[NSArray arrayWithObjects:@"Multi recursion object array",@"",@"CUSExampleViewController7", nil]];
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
    self.title = @"CUSFileStorage";
    [self loadData];
    UITableView *talbeView = [[UITableView alloc]init];
    talbeView.dataSource = self;
    talbeView.delegate = self;
    talbeView.frame = self.view.bounds;
    [self.view addSubview:talbeView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    NSArray *array = [self.dataItems objectAtIndex:indexPath.row];
    if (array && [array count] >= 1) {
        cell.textLabel.text = [array objectAtIndex:0];
        cell.detailTextLabel.text = [array objectAtIndex:1];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *array = [self.dataItems objectAtIndex:indexPath.row];
    if (array && [array count] > 2) {
        BOOL flag = [self loadViewWithClassName:[array objectAtIndex:2] title:[array objectAtIndex:0]];
        if(!flag){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"message" message:@"Unimplement. After,we will add it." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [alert show];
        }
    }else{
        NSLog(@"dataItems format error");
    }
}

-(BOOL)loadViewWithClassName:(NSString*)name title:(NSString*)title {
    Class controllerClass=NSClassFromString(name);
    if(controllerClass){
        UIViewController* backController=[[controllerClass alloc]init];
        backController.title = title;
        [self.navigationController pushViewController:backController animated:YES];
        return YES;
    }
    return NO;
}


@end

