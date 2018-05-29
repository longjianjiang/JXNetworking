//
//  JXDemoViewModel.h
//  JXNetworking
//
//  Created by zl on 2018/5/14.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JXNetworking.h"

extern NSString * const kJXDemoViewModelReactiveTypeNormal;
extern NSString * const kJXDemoViewModelReactiveTypePageable;

@interface JXDemoViewModel : NSObject <JXAPIManagerReactiveProtocol>

@property (nonatomic, assign, readonly) BOOL hasNextPage;

@property (nonatomic, copy) NSArray *videoList;



// not use

//@property (nonatomic, copy) NSString *errorMsg;
//- (void)loadNextPage;
//- (__kindof UITableViewCell *)cellAtIndexPath:(NSIndexPath *)indexPath atTableView:(UITableView *)tableView;

@end
