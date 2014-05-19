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

-(NSMutableArray *)loadDataItems{
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    CUSFileStorage *storage = [CUSFileStorageManager getFileStorage:[self getDBName]];
    return [storage count];
}

-(NSString *)getKeyByIndex:(NSInteger)index{
    return [NSString stringWithFormat:@"key%i",index];
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
