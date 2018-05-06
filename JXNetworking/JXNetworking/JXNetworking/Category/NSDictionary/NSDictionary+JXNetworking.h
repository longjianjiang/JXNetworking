//
//  NSDictionary+JXNetworking.h
//  JXNetworking
//
//  Created by zl on 2018/5/5.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (JXNetworking)

- (NSString *)jx_jsonString;
- (NSString *)jx_transformToUrlParamString;
@end
