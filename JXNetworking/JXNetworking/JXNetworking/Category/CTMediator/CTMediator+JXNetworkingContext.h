//
//  CTMediator+JXNetworkingContext.h
//  JXNetworking
//
//  Created by zl on 2018/6/19.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import <CTMediator/CTMediator.h>


@interface CTMediator (JXNetworkingContext)

- (BOOL)JXNetworkingContext_isReachable;

- (NSInteger)JXNetworkingContext_cacheResponseCountLimit;

- (NSString *)JXNetworkingContext_requestNotMeetExpectionErrorMsgKey;

@end

