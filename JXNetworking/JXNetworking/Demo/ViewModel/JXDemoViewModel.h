//
//  JXDemoViewModel.h
//  JXNetworking
//
//  Created by zl on 2018/5/14.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JXDemoViewModel : NSObject 

@property (nonatomic, assign, readonly) BOOL hasNextPage;

@property (nonatomic, copy) NSArray *videoList;
@property (nonatomic, copy) NSString *errorMsg;

- (void)loadNextPage;

@end
