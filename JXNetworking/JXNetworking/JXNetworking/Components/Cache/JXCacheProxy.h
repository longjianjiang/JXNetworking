//
//  JXCacheProxy.h
//  JXNetworking
//
//  Created by zl on 2018/5/4.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JXResponseObject.h"


@interface JXCacheProxy : NSObject
+ (instancetype)sharedInstance;

- (void)saveMemoryCacheWithResponseSuccessItem:(JXResponseSuccessItem *)successItem
                          apiServiceIdentifier:(NSString *)apiServiceIdentifier
                                       apiPath:(NSString *)apiPath
                                     cacheTime:(NSTimeInterval)cacheTime;

- (void)saveDiskCacheWithResponseSuccessItem:(JXResponseSuccessItem *)successItem
                          apiServiceIdentifier:(NSString *)apiServiceIdentifier
                                       apiPath:(NSString *)apiPath
                                   cacheTime:(NSTimeInterval)cacheTime;

- (JXResponseSuccessItem *)fetchMemoryCacheWithAPIServiceIdentifier:(NSString *)apiServiceIdentifier
                                                            apiPath:(NSString *)apiPath
                                                          apiParams:(NSDictionary *)apiParams;

- (JXResponseSuccessItem *)fetchDiskCacheWithAPIServiceIdentifier:(NSString *)apiServiceIdentifier
                                                            apiPath:(NSString *)apiPath
                                                          apiParams:(NSDictionary *)apiParams;

- (void)clearAllMemeoryCache;
- (void)clearAllDiskCache;

@end
