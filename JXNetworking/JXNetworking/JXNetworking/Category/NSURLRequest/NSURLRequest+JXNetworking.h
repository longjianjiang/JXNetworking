//
//  NSURLRequest+JXNetworking.h
//  JXNetworking
//
//  Created by zl on 2018/5/4.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JXServiceProtocol.h"


@interface NSURLRequest (JXNetworking)

@property (nonatomic, copy) NSDictionary *jx_originalRequestParams;
@property (nonatomic, copy) NSDictionary *jx_actualRequestParams;
@property (nonatomic, strong) id<JXServiceProtocol> jx_service;

@end
