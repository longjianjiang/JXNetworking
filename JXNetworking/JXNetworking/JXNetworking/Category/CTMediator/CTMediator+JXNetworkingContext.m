//
//  CTMediator+JXNetworkingContext.m
//  JXNetworking
//
//  Created by zl on 2018/6/19.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import "CTMediator+JXNetworkingContext.h"

@implementation CTMediator (JXNetworkingContext)

- (BOOL)JXNetworkingContext_isReachable {
    return [[[CTMediator sharedInstance] performTarget:@"JXNetworkingContext" action:@"isReachable" params:nil shouldCacheTarget:YES] boolValue];
}

- (NSInteger)JXNetworkingContext_cacheResponseCountLimit {
    return [[[CTMediator sharedInstance] performTarget:@"JXNetworkingContext" action:@"cacheResponseCountLimit" params:nil shouldCacheTarget:YES] integerValue];
}

@end
