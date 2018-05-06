//
//  NSDictionary+JXNetworking.m
//  JXNetworking
//
//  Created by zl on 2018/5/5.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import "NSDictionary+JXNetworking.h"

@implementation NSDictionary (JXNetworking)

- (NSString *)jx_jsonString {
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:NULL];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (NSString *)jx_transformToUrlParamString {
    NSMutableString *paramsString = [NSMutableString string];
    for (int i = 0; i < self.count; ++i) {
        NSString *str;
        if (i == 0) {
            str = [NSString stringWithFormat:@"?%@=%@", self.allKeys[i], self[self.allKeys[i]]];
        } else {
            str = [NSString stringWithFormat:@"&%@=%@", self.allKeys[i], self[self.allKeys[i]]];
        }
        
        [paramsString appendString:str];
    }
    
    return paramsString;
}

@end
