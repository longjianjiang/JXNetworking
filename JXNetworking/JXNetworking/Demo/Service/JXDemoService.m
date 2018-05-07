//
//  JXDemoService.m
//  JXNetworking
//
//  Created by zl on 2018/5/7.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import "JXDemoService.h"
#import <AFNetworking/AFNetworking.h>

@interface JXDemoService()
@property (nonatomic, copy) NSString *baseURL;


@property (nonatomic, strong) AFHTTPRequestSerializer *httpRequestSerializer;
@end


@implementation JXDemoService

- (NSURLRequest *)requestWithParams:(NSDictionary *)params apiPath:(NSString *)apiPath apiVersion:(NSString *)apiVersion requestType:(JXNetworkingRequestType)requestType {
    NSString *type = requestType == JXNetworkingRequestTypeGet ? @"GET" : @"POST";
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@/%@",self.baseURL, apiVersion, apiPath];
    NSMutableURLRequest *request = [self.httpRequestSerializer requestWithMethod:type URLString:urlStr parameters:params error:nil];
    return request;
}


#pragma mark - getters and setters
- (NSString *)baseURL {
    if (self.apiEnviroment == JXNetworkingServiceEnviromentRelease) {
         return @"https://mobapi.xsj21.com/api";
    }
    return @"https://mobapi.xsj21.com/api";
}

- (JXNetworkingServiceEnviroment)apiEnviroment {
    return JXNetworkingServiceEnviromentRelease;
}

- (AFHTTPRequestSerializer *)httpRequestSerializer {
    if (_httpRequestSerializer == nil) {
        _httpRequestSerializer = [AFHTTPRequestSerializer serializer];
        [_httpRequestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    }
    return _httpRequestSerializer;
}
@end
