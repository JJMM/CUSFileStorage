//
//  CUSExampleViewController5.m
//  CUSFileStorageExample
//
//  Created by zhangyu on 14-5-15.
//  Copyright (c) 2014年 zhangyu. All rights reserved.
//

#import "CUSExampleViewController5.h"

@implementation CUSExampleViewController5

-(NSString *)getDBName{
    return @"TestDB5";
}


-(NSInteger)getAddCount{
    return 10000;
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
