//
//  JXDemoService.m
//  JXNetworking
//
//  Created by zl on 2018/5/7.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import "JXDemoService.h"
#import <AFNetworking/AFNetworking.h>

static NSTimeInterval kTimeoutInterval = 20;

@interface JXDemoService()
@property (nonatomic, copy) NSString *baseURL;


@property (nonatomic, strong) AFJSONRequestSerializer *httpRequestSerializer;
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
         return @"https://testapp.hexiaoxiang.com/api";
    }
    return @"http://192.168.3.236:4002/api";
}

- (JXNetworkingServiceEnviroment)apiEnviroment {
    return JXNetworkingServiceEnviromentRelease;
}


- (AFJSONRequestSerializer *)httpRequestSerializer {
    if (_httpRequestSerializer == nil) {
        _httpRequestSerializer = [AFJSONRequestSerializer serializer];
        _httpRequestSerializer.timeoutInterval = kTimeoutInterval;
    }
    return _httpRequestSerializer;
}
@end
