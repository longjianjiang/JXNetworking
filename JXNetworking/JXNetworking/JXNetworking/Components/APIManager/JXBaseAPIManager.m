//
//  JXBaseAPIManager.m
//  JXNetworking
//
//  Created by zl on 2018/5/4.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import "JXBaseAPIManager.h"
#import "JXAPIProxy.h"
#import "JXResponseObject.h"
#import "JXCacheProxy.h"
#import "JXServiceFactory.h"

#import "NSURLRequest+JXNetworking.h"

NSString * const kJXBaseAPIManagerRequestID = @"kJXBaseAPIManagerRequestID";

@interface JXBaseAPIManager()

@property (nonatomic, copy, readwrite) NSString *errorMessage;
@property (nonatomic, assign, readwrite) BOOL isReachable;
@property (nonatomic, assign, readwrite) BOOL isLoading;
@property (nonatomic, assign, readwrite) JXNetworkingAPIManagerErrorType errorType;

@property (nonatomic, strong) id fetchedRawData;
@property (nonatomic, strong) NSMutableArray *requestIdList;
@end


@implementation JXBaseAPIManager

#pragma mark - life cycle
- (instancetype)init {
    self = [super init];
    if (self) {
        _delegate = nil;
        _validator = nil;
        _paramsSource = nil;
        
        _errorMessage = nil;
        _errorType = JXNetworkingAPIManagerErrorTypeDefault;
        _fetchedRawData = nil;
        
        _memoryCacheSecond = 3 * 60;
        _diskCacheSecond = 3 * 60;
        
        if ([self conformsToProtocol:@protocol(JXAPIManager)]) {
            self.child = (id<JXAPIManager>)self;
        } else {
            NSException *exception = [[NSException alloc] init];
            @throw exception;
        }
    }
  
    return self;
}

- (void)dealloc {
    [self cancelAllRequests];
    self.requestIdList = nil;
}

#pragma mark - data reformer
- (id)fetchDataWithReformer:(id<JXAPIManagerDataReformer>)reformer {
    id resultData = nil;
    if ([reformer respondsToSelector:@selector(jxManager:reformerData:)]) {
        resultData = [reformer jxManager:self reformerData:self.fetchedRawData];
    } else {
        resultData = [self.fetchedRawData mutableCopy];
    }
    return resultData;
}


#pragma mark - cancel
- (void)cancelAllRequests {
    [[JXAPIProxy sharedInstance] cancelRequestWithRequestList:self.requestIdList];
    [self.requestIdList removeAllObjects];
}

- (void)cancelRequestWithRequestId:(NSInteger)requestId {
    [[JXAPIProxy sharedInstance] cancelRequestWithRequestId:@(requestId)];
    [self removeRequestIdWithRequestID:requestId];
}

#pragma mark - call api
- (NSInteger)loadData {
    NSDictionary *params = [self.paramsSource paramsForCallAPI:self];
    NSInteger requestId = [self loadDataWithParams:params];
    return requestId;
}

- (NSInteger)loadDataWithParams:(NSDictionary *)params {
    NSInteger requestsId = 0;
    NSDictionary *reformParams = [self reformParams:params];
    if (reformParams == nil) {
        reformParams = @{};
    }
    if ([self shouldCallAPIWithParams:reformParams]) {
        JXNetworkingAPIManagerErrorType errorType = [self.validator jxManager:self isCorrectWithParamsForCallAPI:reformParams];
        if (errorType == JXNetworkingAPIManagerErrorTypeParamsCorrect) {
            JXResponseSuccessItem *successItem = nil;
            
            if ((self.cachePolicy & JXNetworkingCachePolicyMemory) && self.shouldIgnoreCache == NO) {
                successItem = [[JXCacheProxy sharedInstance] fetchMemoryCacheWithAPIServiceIdentifier:self.child.apiServiceIdentifier apiPath:self.child.apiPath apiParams:reformParams];
            }
            
            if ((self.cachePolicy & JXNetworkingCachePolicyDisk) && self.shouldIgnoreCache == NO) {
                successItem = [[JXCacheProxy sharedInstance] fetchDiskCacheWithAPIServiceIdentifier:self.child.apiServiceIdentifier apiPath:self.child.apiPath apiParams:reformParams];
            }
            
            if (successItem) {
                [self successedOnCallingAPI:successItem];
                return requestsId;
            }
            
            if ([self isReachable]) {
                self.isLoading = YES;
                
                id<JXServiceProtocol> apiService = [[JXServiceFactory sharedInstance] serviceWithIdentifier:self.child.apiServiceIdentifier];
                NSURLRequest *request = [apiService requestWithParams:reformParams apiPath:self.child.apiPath requestType:self.child.apiRequestType];
                request.jx_actualRequestParams = reformParams;
                request.jx_originalRequestParams = params;
                request.jx_service = apiService;
                
                NSNumber *requestId = [[JXAPIProxy sharedInstance] callAPIWithRequest:request loadDataSuccess:^(JXResponseSuccessItem *successItem) {
                    [self successedOnCallingAPI:successItem];
                } loadDataFail:^(JXResponseFailItem *failItem) {
                    JXNetworkingAPIManagerErrorType errorType = JXNetworkingAPIManagerErrorTypeDefault;
                    if (failItem.status == JXResponseStatusErrorCancel) {
                        errorType = JXNetworkingAPIManagerErrorTypeCancel;
                    }
                    if (failItem.status == JXResponseStatusErrorTimeout) {
                        errorType = JXNetworkingAPIManagerErrorTypeTimeout;
                    }
                    if (failItem.status == JXResponseStatusErrorNoNetwork) {
                        errorType = JXNetworkingAPIManagerErrorTypeOffline;
                    }
                    [self failedOnCallingAPI:failItem withErrorType:errorType];
                }];
                
                [self.requestIdList addObject:requestId];
                
                NSMutableDictionary *mutableParams = [reformParams mutableCopy];
                mutableParams[kJXBaseAPIManagerRequestID] = requestId;
                [self afterCallAPIWithParams:mutableParams];
                return [requestId integerValue];
            } else {
                [self failedOnCallingAPI:nil withErrorType:JXNetworkingAPIManagerErrorTypeOffline];
                return requestsId;
            }
        } else {
            [self failedOnCallingAPI:nil withErrorType:errorType];
        }
    }
    
    return requestsId;
}


#pragma mark - api callbacks
- (void)successedOnCallingAPI:(JXResponseSuccessItem *)successItem {
    self.isLoading = NO;
    self.successItem = successItem;
    
    self.fetchedRawData = [successItem.responseData copy];
    [self removeRequestIdWithRequestID:successItem.requestId];
    
    JXNetworkingAPIManagerErrorType errorType = [self.validator jxManager:self isCorrectWithResponseData:successItem.responseJSONDict];
    if (errorType == JXNetworkingAPIManagerErrorTypeParamsCorrect) {
        
        if (self.cachePolicy != JXNetworkingCachePolicyNoCache && successItem.isCache == NO) {
            
            if (self.cachePolicy & JXNetworkingCachePolicyMemory) {
                [[JXCacheProxy sharedInstance] saveMemoryCacheWithResponseSuccessItem:successItem
                                                                 apiServiceIdentifier:self.child.apiServiceIdentifier
                                                                              apiPath:self.child.apiPath
                                                                            cacheTime:self.memoryCacheSecond];
            }
            
            
            if (self.cachePolicy & JXNetworkingCachePolicyDisk) {
                [[JXCacheProxy sharedInstance] saveDiskCacheWithResponseSuccessItem:successItem
                                                               apiServiceIdentifier:self.child.apiServiceIdentifier
                                                                            apiPath:self.child.apiPath
                                                                          cacheTime:self.diskCacheSecond];
            }
        }
        
        if ([self.interceptor respondsToSelector:@selector(jxManager:didReceiveServerResponse:)]) {
            [self.interceptor jxManager:self didReceiveServerResponse:successItem];
        }
        
        if ([self beforePerformSuccessItem:successItem]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.delegate respondsToSelector:@selector(jxManagerCallAPIDidSuccess:)]) {
                    [self.delegate jxManagerCallAPIDidSuccess:self];
                }
            });
        }
        [self afterPerformSuccessItem:successItem];
    } else {
        
        JXResponseFailItem *failItem = [[JXResponseFailItem alloc] initWithResponseFailItemWithRequest:successItem.request requestId:@(successItem.requestId) error:nil];
        
        [failItem updateErrorMsg:successItem.responseJSONDict[@"msgs"]];
        [self failedOnCallingAPI:failItem withErrorType:errorType];
        
    }
}

- (void)failedOnCallingAPI:(JXResponseFailItem *)failItem withErrorType:(JXNetworkingAPIManagerErrorType)errorType {
    self.isLoading = NO;
    self.errorType = errorType;
    
    [self removeRequestIdWithRequestID:failItem.requestId];
    
    self.errorMessage = failItem.errorMsg;
    
    if ([self.interceptor respondsToSelector:@selector(jxManager:didReceiveServerResponse:)]) {
        [self.interceptor jxManager:self didReceiveServerResponse:failItem];
    }
    
    if ([self beforePerformFailItem:failItem]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.delegate respondsToSelector:@selector(jxManager:callAPIDidFail:)]) {
                [self.delegate jxManager:self callAPIDidFail:failItem];
            }
        });
    }
    
    [self afterPerformFailItem:failItem];
    
}

#pragma mark - method for interceptor
- (BOOL)beforePerformSuccessItem:(JXResponseSuccessItem *)successItem {
    BOOL result = YES;
    
    self.errorType = JXNetworkingAPIManagerErrorTypeSuccess;
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(jxManager:beforePerformSuccessItem:)]) {
        result = [self.interceptor jxManager:self beforePerformSuccessItem:successItem];
    }
    return result;
}
- (void)afterPerformSuccessItem:(JXResponseSuccessItem *)successItem {
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(jxManager:afterPerformSuccessItem:)]) {
        [self.interceptor jxManager:self afterPerformSuccessItem:successItem];
    }
}

- (BOOL)beforePerformFailItem:(JXResponseFailItem *)failItem {
    BOOL result = YES;
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(jxManager:beforePerformFailItem:)]) {
        result = [self.interceptor jxManager:self beforePerformFailItem:failItem];
    }
    return result;
}
- (void)afterPerformFailItem:(JXResponseFailItem *)failItem {
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(jxManager:beforePerformFailItem:)]) {
        [self.interceptor jxManager:self afterPerformFailItem:failItem];
    }
}

- (BOOL)shouldCallAPIWithParams:(NSDictionary *)params {
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(shouldCallAPIWithParams:)]) {
        return [self.interceptor jxManager:self shouldCallAPIWithParams:params];
    } else {
        return YES;
    }
}
- (void)afterCallAPIWithParams:(NSDictionary *)params {
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(afterCallAPIWithParams:)]) {
        [self.interceptor jxManager:self afterCallAPIWithParams:params];
    }
}


#pragma mark - method for child
//如果需要在调用API之前额外添加一些参数，比如pageNumber和pageSize之类的就在这里添加
//子类中覆盖这个函数的时候就不需要调用[super reformParams:params]了
- (NSDictionary *)reformParams:(NSDictionary *)params {
    IMP childIMP = [self.child methodForSelector:@selector(reformParams:)];
    IMP selfIMP = [self methodForSelector:@selector(reformParams:)];
    
    if (childIMP == selfIMP) {
        return params;
    } else {
        // 如果child是继承得来的，那么这里就不会跑到，会直接跑子类中的IMP。
        // 如果child是另一个对象，就会跑到这里
        NSDictionary *result = nil;
        result = [self.child reformParams:params];
        if (result) {
            return result;
        } else {
            return params;
        }
    }
}

- (void)clearData {
    self.fetchedRawData = nil;
    self.errorType = JXNetworkingAPIManagerErrorTypeDefault;
}

#pragma mark - private methods
- (void)removeRequestIdWithRequestID:(NSInteger)requestId {
    NSNumber *requestIDToRemove = nil;
    for (NSNumber *storedRequestId in self.requestIdList) {
        if ([storedRequestId integerValue] == requestId) {
            requestIDToRemove = storedRequestId;
        }
    }
    if (requestIDToRemove) {
        [self.requestIdList removeObject:requestIDToRemove];
    }
}

#pragma mark - getters and setters
- (NSMutableArray *)requestIdList {
    if (_requestIdList == nil) {
        _requestIdList = [NSMutableArray array];
    }
    return _requestIdList;
}

- (BOOL)isReachable {
    return YES;
}

- (BOOL)isLoading {
    if (self.requestIdList.count == 0) {
        _isLoading = NO;
    }
    return _isLoading;
}
@end
