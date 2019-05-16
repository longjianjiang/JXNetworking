//
//  NSURLRequest+JXNetworking.m
//  JXNetworking
//
//  Created by zl on 2018/5/4.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import "NSURLRequest+JXNetworking.h"
#import <objc/runtime.h>


@implementation NSURLRequest (JXNetworking)

#pragma mark - getter and setter
- (void)setJx_originalRequestParams:(NSDictionary *)jx_originalRequestParams {
    objc_setAssociatedObject(self, @selector(jx_originalRequestParams), jx_originalRequestParams, OBJC_ASSOCIATION_COPY);
}

- (NSDictionary *)jx_originalRequestParams {
    return objc_getAssociatedObject(self, @selector(jx_originalRequestParams));
}

- (void)setJx_actualRequestParams:(NSDictionary *)jx_actualRequestParams {
    objc_setAssociatedObject(self, @selector(jx_actualRequestParams), jx_actualRequestParams, OBJC_ASSOCIATION_COPY);
}

- (NSDictionary *)jx_actualRequestParams {
    return objc_getAssociatedObject(self, @selector(jx_actualRequestParams));
}

-(void)setJx_service:(id<JXServiceProtocol>)jx_service {
    objc_setAssociatedObject(self, @selector(jx_service), jx_service, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (id<JXServiceProtocol>)jx_service {
    return objc_getAssociatedObject(self, @selector(jx_service));
}


@end
