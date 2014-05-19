//
//  CUSExampleViewController7.m
//  CUSFileStorageExample
//
//  Created by zhangyu on 14-5-19.
//  Copyright (c) 2014年 zhangyu. All rights reserved.
//

#import "CUSExampleViewController7.h"

@implementation CUSExampleViewController7

-(NSString *)getDBName{
    return @"TestDB7";
}

-(NSInteger)getAddCount{
    return 10000;
}

-(id)doCreateItem:(NSInteger)index{
    return [CUSModelFactory createTeacher:index];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CUS_CELL";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    CUSTeacher *value = [self.dataItems objectAtIndex:indexPath.row];
    cell.textLabel.text = value.name;
    
    return cell;
}
@end
