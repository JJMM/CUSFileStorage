//
//  CUSExampleViewController4.m
//  CUSFileStorageExample
//
//  Created by zhangyu on 14-5-15.
//  Copyright (c) 2014年 zhangyu. All rights reserved.
//

#import "CUSExampleViewController4.h"

@implementation CUSExampleViewController4

-(NSString *)getDBName{
    return @"TestDB4";
}

-(id)doCreateItem:(NSInteger)index{
    return [CUSModelFactory createStudent:index];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CUS_CELL";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    CUSStudent *value = [self.dataItems objectAtIndex:indexPath.row];
    cell.textLabel.text = value.name;
    
    return cell;
}
@end
