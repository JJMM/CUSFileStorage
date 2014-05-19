//
//  CUSExampleViewController3.m
//  CUSFileStorageExample
//
//  Created by zhangyu on 14-5-15.
//  Copyright (c) 2014年 zhangyu. All rights reserved.
//

#import "CUSExampleViewController3.h"

@implementation CUSExampleViewController3
-(NSString *)getDBName{
    return @"TestDB3";
}
-(NSInteger)getAddCount{
    return 10000;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CUS_CELL";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    NSString *value = [self.dataItems objectAtIndex:indexPath.row];
    cell.textLabel.text = value;
    
    return cell;
}
@end