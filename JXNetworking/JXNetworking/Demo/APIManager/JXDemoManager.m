//
//  JXDemoManager.m
//  JXNetworking
//
//  Created by zl on 2018/5/11.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import "JXDemoManager.h"
#import "Target_JXDemoService.h"

@interface JXDemoManager()<JXAPIManagerValidator>

@end


@implementation JXDemoManager

-(instancetype)init {
    if (self = [super init]) {
        self.validator = self;
    }
    return self;
}

#pragma mark - JXAPIManager
- (NSString *)apiPath {
    return @"student/lesson/all";
}

- (NSString *)apiVersion {
    return @"v1.0";
}

- (NSString *)apiServiceIdentifier {
    return JXNetworkingDemoServiceIdentifier;
}


#pragma mark - JXAPIManagerValidator
- (JXNetworkingAPIManagerErrorType)jxManager:(JXBaseAPIManager *)manager isCorrectWithResponseData:(id)responseData {
    return JXNetworkingAPIManagerErrorTypeParamsCorrect;
}

- (JXNetworkingAPIManagerErrorType)jxManager:(JXBaseAPIManager *)manager isCorrectWithParamsForCallAPI:(NSDictionary *)params {
    return JXNetworkingAPIManagerErrorTypeParamsCorrect;
}

@end
