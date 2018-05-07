//
//  JXResponseObject.m
//  JXNetworking
//
//  Created by zl on 2018/5/4.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import "JXResponseObject.h"
#import "NSURLRequest+JXNetworking.h"

#pragma mark - JXResponseSuccessItem
@interface JXResponseSuccessItem()

@property (nonatomic, strong, readwrite) NSURLRequest *request;
@property (nonatomic, strong, readwrite) NSData *responseData;
@property (nonatomic, strong, readwrite) id responseJSONDict;
@property (nonatomic, assign, readwrite) BOOL isCache;
@property (nonatomic, assign, readwrite) JXResponseStatus status;
@property (nonatomic, assign, readwrite) NSInteger requestId;

@end

@implementation JXResponseSuccessItem

- (instancetype)initResponseSuccessItemWithRequest:(NSURLRequest *)request
                                      responseData:(NSData *)responseData
                                         requestId:(NSNumber *)requestId {
    if (self = [super init]) {
        self.request = request;
        self.responseData = responseData;
        self.responseJSONDict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:NULL];
        self.status = JXResponseStatusSuccess;
        self.requestId = [requestId integerValue];
        self.isCache = NO;
        
        self.originalRequestParams = request.jx_originalRequestParams;
        self.actualRequestParams = request.jx_actualRequestParams;
    }
    return self;
}

- (instancetype)initWithData:(NSData *)data {
    if (self = [super init]) {
        self.request = nil;
        self.responseData = data;
        self.responseJSONDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
        self.status = JXResponseStatusSuccess;
        self.requestId = 0;
        self.isCache = YES;
    }
    return self;
}

@end



#pragma mark - JXResponseFailItem
@interface JXResponseFailItem()

@property (nonatomic, strong, readwrite) NSURLRequest *request;
@property (nonatomic, strong, readwrite) NSData *responseData;
@property (nonatomic, assign, readwrite) JXResponseStatus status;
@property (nonatomic, assign, readwrite) NSInteger requestId;

@property (nonatomic, strong, readwrite) NSString *errorMsg;
@property (nonatomic, strong, readwrite) NSError *error;

@end

@implementation JXResponseFailItem


- (instancetype)initWithResponseFailItemWithRequest:(NSURLRequest *)request
                                          requestId:(NSNumber *)requestId
                                              error:(NSError *)error {
    if (self = [super init]) {
        self.request = request;
        
        self.requestId = [requestId integerValue];
        self.error = error;
        self.errorMsg = [self getErrorMsgWithError:error];
        self.status = [self responseStatusWithError:error];
    }
    return self;
}

- (void)updateErrorMsg:(NSString *)errorMsg {
    self.errorMsg = errorMsg;
}

#pragma mark - private method
- (NSString *)getErrorMsgWithError:(NSError *)error {
#ifdef DEBUG
    NSString *errorMsg = @"【JXResponseFailItem】没有错误 ";
#else
    NSString *errorMsg = @"";
#endif
    
    if (error) {
        if (error.code == NSURLErrorTimedOut) {
            errorMsg = @"网络超时";
        }
        if (error.code == NSURLErrorCancelled) {
            errorMsg = @"取消请求";
        }
        if (error.code == NSURLErrorNotConnectedToInternet) {
            errorMsg = @"网络不通";
        }
        return errorMsg;
    } else {
        return errorMsg;
    }
}

- (JXResponseStatus)responseStatusWithError:(NSError *)error {
    if (error) {
        JXResponseStatus status = JXResponseStatusErrorNoNetwork;
        if (error.code == NSURLErrorTimedOut) {
            status = JXResponseStatusErrorTimeout;
        }
        if (error.code == NSURLErrorCancelled) {
            status = JXResponseStatusErrorCancel;
        }
        if (error.code == NSURLErrorNotConnectedToInternet) {
            status = JXResponseStatusErrorNoNetwork;
        }
        return status;
    } else {
        return JXResponseStatusSuccess;
    }
}
@end

