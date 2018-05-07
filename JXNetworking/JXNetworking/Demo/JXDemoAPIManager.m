//
//  JXDemoAPIManager.m
//  JXNetworking
//
//  Created by zl on 2018/5/7.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import "JXDemoAPIManager.h"
#import "Target_JXDemoService.h"

@interface JXBaseAPIManager()<JXAPIManagerValidator, JXAPIManagerDataSource>
@end


@implementation JXDemoAPIManager

- (instancetype)init {
    if (self = [super init]) {
        self.paramsSource = self;
        self.validator = self;
    }
    return self;
}

#pragma mark - JXAPIManager
- (NSString *)apiPath {
    return @"teacher/banner";
}

- (NSString *)apiVersion {
    return @"v1.0";
}

- (JXNetworkingRequestType)apiRequestType {
    return JXNetworkingRequestTypePost;
}

- (NSString *)apiServiceIdentifier {
    return JXNetworkingDemoServiceIdentifier;
}

#pragma mark - JXAPIManagerDataSource
- (NSDictionary *)paramsForCallAPI:(JXBaseAPIManager *)manager {
    return @{@"token": @"baa80b57-47f5-4217-8c07-41b7c042cfb7&"};
}

#pragma mark - JXAPIManagerValidator
- (JXNetworkingAPIManagerErrorType)jxManager:(JXBaseAPIManager *)manager isCorrectWithResponseData:(id)responseData {
    return JXNetworkingAPIManagerErrorTypeParamsCorrect;
}

- (JXNetworkingAPIManagerErrorType)jxManager:(JXBaseAPIManager *)manager isCorrectWithParamsForCallAPI:(NSDictionary *)params {
    return JXNetworkingAPIManagerErrorTypeParamsCorrect;
}
@end
