//
//  JXLogger.m
//  JXNetworking
//
//  Created by zl on 2018/5/4.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import "JXLogger.h"
#import "NSURLRequest+JXNetworking.h"
@implementation JXLogger

+ (void)logDebugInfoWithRequest:(NSURLRequest *)request apiPath:(NSString *)apiPath service:(id<JXServiceProtocol>)service {
#if DEBUG
    NSMutableString *log = [NSMutableString string];
    [log appendString:@"\n↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘ [ JXNetworking Request Info Start] ↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙"];
    [log appendFormat:@"\nService            : %@", [service class]];
    [log appendFormat:@"\nReuqest Path       : %@", apiPath];
    [log appendFormat:@"\nReuqest Params     : %@", request.jx_actualRequestParams];
    [log appendFormat:@"\nRequest Type       : %@", request.HTTPMethod];
    [log appendFormat:@"\nRaw Request        : %@", request];
    [log appendString:@"\n↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗ [ JXNetworking Request Info End ] ↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖"];
    NSLog(@"%@",log);
#endif
}

+ (void)logDebugInfoWithResponse:(NSURLResponse *)response responseObject:(id)responseObj {
#if DEBUG
    if ([responseObj isKindOfClass:[JXResponseSuccessItem class]]) {
        JXResponseSuccessItem *item = (JXResponseSuccessItem *)responseObj;
        NSMutableString *log = [NSMutableString string];
        [log appendString:@"\n↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘ [ JXNetworking Response Info Start] ↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙"];
        [log appendFormat:@"\nReuqest Path   : %@", item.request.URL.absoluteString];
        [log appendFormat:@"\nReuqest Params : %@", item.request.jx_actualRequestParams];
        [log appendFormat:@"\nResponse String: %@", item.responseJSONDict];
        [log appendString:@"\n↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗ [ JXNetworking Response Info End ] ↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖"];
        NSLog(@"%@",log);
    }
    
    if ([responseObj isKindOfClass:[JXResponseFailItem class]]) {
        JXResponseFailItem *item = (JXResponseFailItem *)responseObj;
        NSMutableString *log = [NSMutableString string];
        [log appendString:@"\n↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘ [ JXNetworking Response Info Start] ↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙"];
        [log appendFormat:@"\nReuqest Path         : %@", item.request.URL.absoluteString];
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        [log appendFormat:@"\nResponse Status Code : %ld", (long)httpResponse.statusCode];
        [log appendFormat:@"\nReuqest Params       : %@", item.request.jx_actualRequestParams];
        [log appendFormat:@"\nError Msg            : %@", item.errorMsg];
        [log appendString:@"\n↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗ [ JXNetworking Response Info End ] ↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖"];
        NSLog(@"%@",log);
    }
#endif
}

+ (void)logDebugInfoWithCachedResponse:(JXResponseSuccessItem *)successItem apiPath:(NSString *)apiPath apiParams:(NSDictionary *)params {
#if DEBUG
    NSMutableString *log = [NSMutableString string];
    [log appendString:@"\n↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘ [ JXNetworking Cached Response Info Start] ↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙"];
    [log appendFormat:@"\nReuqest Path   : %@", apiPath];
    [log appendFormat:@"\nReuqest Params : %@", params];
    [log appendFormat:@"\nResponse String: %@", successItem.responseJSONDict];
    [log appendString:@"\n↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗ [ JXNetworking Cached Response Info End ] ↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖"];
    NSLog(@"%@",log);
#endif
}
@end
