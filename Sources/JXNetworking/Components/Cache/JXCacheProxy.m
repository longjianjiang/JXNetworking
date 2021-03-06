//
//  JXCacheProxy.m
//  JXNetworking
//
//  Created by zl on 2018/5/4.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import "JXCacheProxy.h"
#import "JXDiskCacheManager.h"
#import "JXMemoryCacheManager.h"
#import "JXLogger.h"
#import "JXServiceFactory.h"
#import "NSDictionary+JXNetworking.h"

@interface JXCacheProxy()

@property (nonatomic, strong) JXDiskCacheManager *diskCacheManager;
@property (nonatomic,strong) JXMemoryCacheManager *memoryCacheManager;

@end


@implementation JXCacheProxy

#pragma mark - getter and setter
- (JXDiskCacheManager *)diskCacheManager {
    if (_diskCacheManager == nil) {
        _diskCacheManager = [JXDiskCacheManager new];
    }
    return _diskCacheManager;
}

- (JXMemoryCacheManager *)memoryCacheManager {
    if (_memoryCacheManager == nil) {
        _memoryCacheManager = [JXMemoryCacheManager new];
    }
    return _memoryCacheManager;
}

#pragma mark - public method

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static JXCacheProxy *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [JXCacheProxy new];
    });
    return instance;
}

- (void)saveDiskCacheWithResponseSuccessItem:(JXResponseSuccessItem *)successItem
                        apiServiceIdentifier:(NSString *)apiServiceIdentifier
                                     apiPath:(NSString *)apiPath
                                   cacheTime:(NSTimeInterval)cacheTime {
    if (successItem.actualRequestParams && successItem.responseJSONDict
        && apiPath.length && apiServiceIdentifier.length) {
        
        NSString *key = [self keyWithServiceIdentifier:apiServiceIdentifier apiPath:apiPath requestParams:successItem.actualRequestParams];
        
        [self.diskCacheManager saveCacheWithSuccessItem:successItem key:key cacheTime:cacheTime];
        
    }
}

- (JXResponseSuccessItem *)fetchDiskCacheWithAPIServiceIdentifier:(NSString *)apiServiceIdentifier
                                                          apiPath:(NSString *)apiPath
                                                        apiParams:(NSDictionary *)apiParams {
    
    NSString *key = [self keyWithServiceIdentifier:apiServiceIdentifier apiPath:apiPath requestParams:apiParams];
    
    JXResponseSuccessItem *successItem = [self.diskCacheManager fetchCachedSuccessItemWithKey:key];
    
    if (successItem) {
         [JXLogger logDebugInfoWithCachedResponse:successItem apiPath:apiPath apiParams:apiParams];
    }
   
    return successItem;
}

- (void)clearAllDiskCache {
    [self.diskCacheManager clearAll];
}


- (void)saveMemoryCacheWithResponseSuccessItem:(JXResponseSuccessItem *)successItem apiServiceIdentifier:(NSString *)apiServiceIdentifier apiPath:(NSString *)apiPath cacheTime:(NSTimeInterval)cacheTime {
    
    if (successItem.actualRequestParams && successItem.responseJSONDict
        && apiPath.length && apiServiceIdentifier.length) {
        
        NSString *key = [self keyWithServiceIdentifier:apiServiceIdentifier apiPath:apiPath requestParams:successItem.actualRequestParams];
        
        [self.memoryCacheManager saveCacheWithSuccessItem:successItem key:key cacheTime:cacheTime];
        
    }
}

- (JXResponseSuccessItem *)fetchMemoryCacheWithAPIServiceIdentifier:(NSString *)apiServiceIdentifier apiPath:(NSString *)apiPath apiParams:(NSDictionary *)apiParams {
    
    NSString *key = [self keyWithServiceIdentifier:apiServiceIdentifier apiPath:apiPath requestParams:apiParams];
    
    JXResponseSuccessItem *successItem = [self.memoryCacheManager fetchCachedSuccessItemWithKey:key];
    
    if (successItem) {
        [JXLogger logDebugInfoWithCachedResponse:successItem apiPath:apiPath apiParams:apiParams];
    }
    
    return successItem;
}

- (void)clearAllMemeoryCache {
    [self.memoryCacheManager clearAll];
}

#pragma mark - private method
- (NSString *)keyWithServiceIdentifier:(NSString *)serviceIdentifier
                            apiPath:(NSString *)apiPath
                         requestParams:(NSDictionary *)requestParams {
    NSString *key = [NSString stringWithFormat:@"%@%@%@", serviceIdentifier, apiPath, [requestParams jx_transformToUrlParamString]];
    return key;
}
@end
