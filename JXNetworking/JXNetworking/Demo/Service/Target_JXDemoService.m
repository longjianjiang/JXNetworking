//
//  Target_JXDemoService.m
//  JXNetworking
//
//  Created by zl on 2018/5/7.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import "Target_JXDemoService.h"

NSString * const JXNetworkingDemoServiceIdentifier = @"JXDemoService";

@implementation Target_JXDemoService

- (JXDemoService *)Action_JXDemoService:(NSDictionary *)params {
    return [JXDemoService new];
}

@end
