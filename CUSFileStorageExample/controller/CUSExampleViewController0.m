//
//  CUSExampleViewController0.m
//  CUSFileStorageExample
//
//  Created by zhangyu on 14-5-15.
//  Copyright (c) 2014年 zhangyu. All rights reserved.
//

#import "CUSExampleViewController0.h"
@implementation CUSExampleViewController0

-(NSString *)getDBName{
    return @"TestDB0";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CUSFileStorage *storage = [CUSFileStorageManager getFileStorage:[self getDBName]];
    static NSString *CellIdentifier = @"CUS_CELL";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    NSString *rowKey = [self getKeyByIndex:indexPath.row];
    
    NSString *value = (NSString *)[storage objectForFilter:^BOOL(NSString *key, id item) {
        if ([rowKey isEqualToString:key]) {
            return YES;
        }else{
            return NO;
        }
    }];
    cell.textLabel.text = rowKey;
    cell.detailTextLabel.text = value;
    return cell;
}
@end
