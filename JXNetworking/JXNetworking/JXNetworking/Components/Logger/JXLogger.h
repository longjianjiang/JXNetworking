//
//  JXLogger.h
//  JXNetworking
//
//  Created by zl on 2018/5/4.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JXServiceProtocol.h"
#import "JXResponseObject.h"

@interface JXLogger : NSObject

+ (void)logDebugInfoWithRequest:(NSURLRequest *)request apiPath:(NSString *)apiPath service:(id<JXServiceProtocol>)service;
+ (void)logDebugInfoWithResponse:(NSURLResponse *)response responseObject:(id)responseObj;
+ (void)logDebugInfoWithCachedResponse:(JXResponseSuccessItem *)successItem apiPath:(NSString *)apiPath apiParams:(NSDictionary *)params;
@end
