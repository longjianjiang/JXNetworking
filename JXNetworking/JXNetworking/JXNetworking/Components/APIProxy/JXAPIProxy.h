//
//  JXAPIProxy.h
//  JXNetworking
//
//  Created by zl on 2018/5/4.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JXResponseObject.h"

typedef void(^LJAPIProxySuccessCallback)(JXResponseSuccessItem *successItem);
typedef void(^LJAPIProxyFailCallback)(JXResponseFailItem *failItem);

@interface JXAPIProxy : NSObject

+ (instancetype)sharedInstance;

- (NSNumber *)callAPIWithRequest:(NSURLRequest *)request
                loadDataSuccess:(LJAPIProxySuccessCallback)successCallback
                loadDataFail:(LJAPIProxyFailCallback)failCallback;


- (void)cancelRequestWithRequestId:(NSNumber *)requestId;
- (void)cancelRequestWithRequestList:(NSArray *)requestList;

@end
