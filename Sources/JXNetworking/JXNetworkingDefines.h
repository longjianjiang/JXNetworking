//
//  JXNetworkingDefines.h
//  JXNetworking
//
//  Created by zl on 2018/5/4.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#ifndef JXNetworkingDefines_h
#define JXNetworkingDefines_h

NS_ASSUME_NONNULL_BEGIN

@class JXBaseAPIManager;
@class JXResponseFailItem;
@class JXResponseSuccessItem;

typedef NS_ENUM(NSUInteger, JXNetworkingServiceEnviroment) {
    JXNetworkingServiceEnviromentDevelop,
    JXNetworkingServiceEnviromentRelease
};

typedef NS_ENUM(NSUInteger, JXNetworkingRequestType) {
    JXNetworkingRequestTypeGet,
    JXNetworkingRequestTypePost
};

typedef NS_ENUM(NSUInteger, JXNetworkingCachePolicy) {
    JXNetworkingCachePolicyNoCache = 0,
    JXNetworkingCachePolicyMemory = 1 << 0,
    JXNetworkingCachePolicyDisk = 1 << 1
};

typedef NS_ENUM(NSUInteger, JXNetworkingAPIManagerErrorType) {
    JXNetworkingAPIManagerErrorTypeNeedLogin,       // token过期需要重新登录
    JXNetworkingAPIManagerErrorTypeDefault,         // 默认状态，此时还没发生网络请求
    JXNetworkingAPIManagerErrorTypeSuccess,         // 请求成功，此时服务器返回数据符合预期
    JXNetworkingAPIManagerErrorTypeContentError,    // 请求成功，此时服务器返回数据不符合预期
    JXNetworkingAPIManagerErrorTypeParamsError,     // 请求参数错误，调用API之前会进行参数校验
    JXNetworkingAPIManagerErrorTypeParamsCorrect,   // 请求参数校验正确 & 服务器返回参数校验正确
    JXNetworkingAPIManagerErrorTypeTimeout,         // 请求超时
    JXNetworkingAPIManagerErrorTypeOffline,         // 离线状态，调用API之前会检查网络状态
    JXNetworkingAPIManagerErrorTypeCancel,          // 取消请求
    JXNetworkingAPIManagerErrorTypeServerCrash,     // 500错误
    JXNetworkingAPIManagerErrorTypeServerMessage,   // 服务端自定义消息
};


extern NSString * const kJXBaseAPIManagerRequestID;
extern NSString * const kJXResponseFailItemErrorMessageKey;

/*************************************************************************************/

@protocol JXAPIManager <NSObject>

@required
- (nonnull NSString *)apiPath;
- (nonnull NSString *)apiVersion;
- (nonnull NSString *)apiServiceIdentifier;

@optional
- (JXNetworkingRequestType)apiRequestType; // 默认是POST请求
- (NSDictionary *)reformParams:(NSDictionary *)params;
@end


/*************************************************************************************/

@protocol JXPageableAPIManager <NSObject>

@required
- (NSUInteger)currentPageSize;
- (NSUInteger)pageSize;

@optional
- (NSInteger)loadNextPage;
- (void)resetPage;
- (void)resetPage:(NSUInteger)page;

@property (nonatomic, assign, readonly) NSUInteger currentPageNumber;
@property (nonatomic, assign, readonly) BOOL hasNextPage;

@end



/*************************************************************************************/

@protocol JXAPIManagerDataSource <NSObject>

@required
- (nonnull NSDictionary *)paramsForCallAPI:(JXBaseAPIManager *)manager;
@end


/*************************************************************************************/

@protocol JXAPIManagerDelegate <NSObject>

@required
- (void)jxManagerCallAPIDidSuccess:(JXBaseAPIManager *)manager;
- (void)jxManager:(JXBaseAPIManager *)manager callAPIDidFail:(JXResponseFailItem *)failItem;

@end


/*************************************************************************************/

@protocol JXAPIManagerInterceptor <NSObject>

@optional
- (BOOL)jxManager:(JXBaseAPIManager *)manager beforePerformSuccessItem:(JXResponseSuccessItem *)successItem;
- (void)jxManager:(JXBaseAPIManager *)manager afterPerformSuccessItem:(JXResponseSuccessItem *)successItem;

- (BOOL)jxManager:(JXBaseAPIManager *)manager beforePerformFailItem:(JXResponseFailItem *)failItem;
- (void)jxManager:(JXBaseAPIManager *)manager afterPerformFailItem:(JXResponseFailItem *)failItem;

- (BOOL)jxManager:(JXBaseAPIManager *)manager shouldCallAPIWithParams:(NSDictionary *)params;
- (void)jxManager:(JXBaseAPIManager *)manager afterCallAPIWithParams:(NSDictionary *)params;

- (void)jxManager:(JXBaseAPIManager *)manager didReceiveServerResponse:(id)response;

@end



/*************************************************************************************/

@protocol JXAPIManagerValidator <NSObject>
- (JXNetworkingAPIManagerErrorType)jxManager:(JXBaseAPIManager *)manager isCorrectWithParamsForCallAPI:(NSDictionary *)params;
- (JXNetworkingAPIManagerErrorType)jxManager:(JXBaseAPIManager *)manager isCorrectWithResponseData:(id)responseData;
@end


/*************************************************************************************/

@protocol JXAPIManagerDataReformer <NSObject>
- (nonnull id)jxManager:(JXBaseAPIManager *)manager reformerData:(id)data;
@end

NS_ASSUME_NONNULL_END

#endif /* JXNetworkingDefines_h */
