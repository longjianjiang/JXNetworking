//
//  JXPageableDemoDataReformer.m
//  JXNetworking
//
//  Created by zl on 2018/5/14.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import "JXPageableDemoDataReformer.h"
#import "JXDemoCell.h"

@implementation JXPageableDemoDataReformer

static NSInteger kCount = 0;

- (id)jxManager:(JXBaseAPIManager *)manager reformerData:(id)data {
    
    NSArray *items = data[@"data"][@"items"];
    kCount += items.count;
    
    NSMutableArray *videoItems = [NSMutableArray array];
    for (NSDictionary *item in items) {
        JXDemoCell *cell = [[JXDemoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kJXDemoCellReuseIdentifier];
        [cell updateMsg:item[@"name"]];
        [videoItems addObject:cell];
    }
    
    return videoItems;
}

@end
