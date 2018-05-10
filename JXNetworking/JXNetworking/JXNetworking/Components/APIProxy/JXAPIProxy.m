//
//  JXAPIProxy.m
//  JXNetworking
//
//  Created by zl on 2018/5/4.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import "JXAPIProxy.h"
#import "JXLogger.h"

#import <AFNetworking/AFNetworking.h>

@interface JXAPIProxy()

@property (nonatomic, strong) NSMutableDictionary *requestMap;
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
@end


@implementation JXAPIProxy

#pragma mark getter and setter
- (NSMutableDictionary *)requestMap {
    if (_requestMap == nil) {
        _requestMap = [NSMutableDictionary new];
    }
    return _requestMap;
}

- (AFHTTPSessionManager *)sessionManager {
    if (_sessionManager == nil) {
        _sessionManager = [AFHTTPSessionManager manager];
        _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return _sessionManager;
}


+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static JXAPIProxy *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [JXAPIProxy new];
    });
    return instance;
}

- (void)cancelRequestWithRequestId:(NSNumber *)requestId {
    NSURLSessionDataTask *dataTask = [self.requestMap objectForKey:requestId];
    [dataTask cancel];
    [self.requestMap removeObjectForKey:requestId];
}

- (void)cancelRequestWithRequestList:(NSArray *)requestList {
    for (NSNumber *requestId in requestList) {
        [self cancelRequestWithRequestId:requestId];
    }
}

- (NSNumber *)callAPIWithRequest:(NSURLRequest *)request
                loadDataSuccess:(LJAPIProxySuccessCallback)successCallback
                   loadDataFail:(LJAPIProxyFailCallback)failCallback  {
    
    __block NSURLSessionDataTask *dataTask = nil;
    
    dataTask = [self.sessionManager dataTaskWithRequest:request
                              uploadProgress:nil
                            downloadProgress:nil
                           completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                               
                               NSData *responseData = nil;
                               if ([responseObject isKindOfClass:[NSData class]]) {
                                   responseData = responseObject;
                               }
                               
                               NSNumber *requestId = @(dataTask.taskIdentifier);
                               [self.requestMap removeObjectForKey:requestId];
                               
                               if (error) {
                                   
                                   JXResponseFailItem *failItem = [[JXResponseFailItem alloc] initWithResponseFailItemWithRequest:request requestId:requestId error:error];
                                   failCallback?failCallback(failItem):nil;
                                   
                                   [JXLogger logDebugInfoWithResponse:response responseObject:failItem];
                                   
                               } else {
                                   
                                   JXResponseSuccessItem *successItem = [[JXResponseSuccessItem alloc] initResponseSuccessItemWithRequest:request responseData:responseData requestId:requestId];
                                   successCallback?successCallback(successItem):nil;
                                   
                                   [JXLogger logDebugInfoWithResponse:response responseObject:successItem];
                                   
                                   
                               }
                           }];
    
    NSNumber *requestId = @(dataTask.taskIdentifier);
    [self.requestMap setObject:dataTask forKey:requestId];
    
    [dataTask resume];
    
    return requestId;
    
}

@end
