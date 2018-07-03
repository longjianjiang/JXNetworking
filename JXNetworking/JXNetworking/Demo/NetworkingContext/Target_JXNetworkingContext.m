//
//  Target_JXNetworkingContext.m
//  JXNetworking
//
//  Created by zl on 2018/6/19.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import "Target_JXNetworkingContext.h"

@implementation Target_JXNetworkingContext

- (BOOL)Action_isReachable:(NSDictionary *)params {
    return YES;
}

- (NSInteger)Action_cacheResponseCountLimit:(NSDictionary *)params {
    return 10;
}

- (NSString *)Action_requestNotMeetExpectionErrorMsgKey:(NSDictionary *)params {
    return @"msgs";
}


@end
