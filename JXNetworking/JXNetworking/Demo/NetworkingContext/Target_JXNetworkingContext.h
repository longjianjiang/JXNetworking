//
//  Target_JXNetworkingContext.h
//  JXNetworking
//
//  Created by zl on 2018/6/19.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Target_JXNetworkingContext : NSObject

- (BOOL)Action_isReachable:(NSDictionary *)params;

- (NSInteger)Action_cacheResponseCountLimit:(NSDictionary *)params;

@end

NS_ASSUME_NONNULL_END
