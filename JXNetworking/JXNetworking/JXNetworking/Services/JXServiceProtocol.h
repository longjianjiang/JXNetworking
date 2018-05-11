//
//  JXServiceProtocol.h
//  JXNetworking
//
//  Created by zl on 2018/5/4.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JXNetworkingDefines.h"

@protocol JXServiceProtocol <NSObject>

@property (nonatomic, assign) JXNetworkingServiceEnviroment apiEnviroment;

- (NSURLRequest *)requestWithParams:(NSDictionary *)params
                            apiPath:(NSString *)apiPath
                         apiVersion:(NSString *)apiVersion
                        requestType:(JXNetworkingRequestType)requestType;



@end
