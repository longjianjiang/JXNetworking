//
//  JXBaseAPIManager.h
//  JXNetworking
//
//  Created by zl on 2018/5/4.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JXNetworkingDefines.h"
#import "JXResponseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface JXBaseAPIManager : NSObject

// foundation
@property (nullable, nonatomic, weak) id<JXAPIManagerDataSource> paramsSource;
@property (nullable, nonatomic, weak) id<JXAPIManagerDelegate> delegate;
@property (nullable, nonatomic, weak) id<JXAPIManagerValidator> validator;
@property (nullable, nonatomic, weak) id<JXAPIManagerInterceptor> interceptor;
@property (nullable, nonatomic, weak) NSObject<JXAPIManager> * child;

// cache
@property (nonatomic, assign) JXNetworkingCachePolicy cachePolicy;
@property (nonatomic, assign) NSTimeInterval memoryCacheSecond;
@property (nonatomic, assign) NSTimeInterval diskCacheSecond;
@property (nonatomic, assign) BOOL shouldIgnoreCache;

// data
@property (nonatomic, strong) JXResponseSuccessItem *successItem;
@property (nonatomic, assign, readonly) JXNetworkingAPIManagerErrorType errorType;
@property (nonatomic, copy, readonly) NSString *errorMessage;

// before loading
@property (nonatomic, assign, readonly) BOOL isReachable;
@property (nonatomic, assign, readonly) BOOL isLoading;

// call api
- (NSInteger)loadData;
@property (nonatomic, assign) BOOL shouldRetry; // default is NO, if YES only status is `JXResponseStatusErrorTimeout` will retry
@property (nonatomic, assign) NSUInteger retryCount; // default times is 1

// cancel
- (void)cancelAllRequests;
- (void)cancelRequestWithRequestId:(NSInteger)requestId;

// finish
- (nonnull id)fetchDataWithReformer:(id <JXAPIManagerDataReformer> )reformer;
- (void)clearData;

// default
- (JXNetworkingRequestType)apiRequestType; // default is `POST`
@end

@interface JXBaseAPIManager (InnerInterceptor)

- (BOOL)beforePerformSuccessItem:(JXResponseSuccessItem *)successItem;
- (void)afterPerformSuccessItem:(JXResponseSuccessItem *)successItem;

- (BOOL)beforePerformFailItem:(JXResponseFailItem *)failItem;
- (void)afterPerformFailItem:(JXResponseFailItem *)failItem;

- (BOOL)shouldCallAPIWithParams:(NSDictionary *)params;
- (void)afterCallAPIWithParams:(NSDictionary *)params;

NS_ASSUME_NONNULL_END

@end

