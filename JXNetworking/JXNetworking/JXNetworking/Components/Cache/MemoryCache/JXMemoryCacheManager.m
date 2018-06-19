//
//  JXMemoryCacheManager.m
//  JXNetworking
//
//  Created by longjianjiang on 2018/6/3.
//  Copyright © 2018 longjianjiang. All rights reserved.
//

#import "JXMemoryCacheManager.h"
#import "CTMediator+JXNetworkingContext.h"
#import "JXMemoryCacheRecord.h"

static NSInteger const kCacheCountLimit = 10;

@interface JXMemoryCacheManager()

@property (nonatomic,strong) NSCache *cache;

@end


@implementation JXMemoryCacheManager

#pragma mark - getter and setter
- (NSCache *)cache {
    if (_cache == nil) {
        _cache = [NSCache new];
        _cache.countLimit = [[CTMediator sharedInstance] JXNetworkingContext_cacheResponseCountLimit];
    }
    return _cache;
}

#pragma mark - public method
- (JXResponseSuccessItem *)fetchCachedSuccessItemWithKey:(NSString *)key {
    JXResponseSuccessItem *successItem = nil;
    JXMemoryCacheRecord *record = [self.cache objectForKey:key];
    if (record != nil) {
        if (record.isOutdated || record.isEmpty) {
            [self.cache removeObjectForKey:key];
        } else {
            successItem = [[JXResponseSuccessItem alloc] initWithData:record.content];
        }
    }
    return successItem;
}

- (void)saveCacheWithSuccessItem:(JXResponseSuccessItem *)successItem key:(NSString *)key cacheTime:(NSTimeInterval)cacheTime {
    JXMemoryCacheRecord *record = [self.cache objectForKey:key];
    if (record == nil) {
        record = [[JXMemoryCacheRecord alloc] initWithCacheTime:cacheTime];
    }
    [record updateContent:[NSJSONSerialization dataWithJSONObject:successItem.responseJSONDict options:0 error:NULL]];
    [self.cache setObject:record forKey:key];
}

- (void)clearAll {
    [self.cache removeAllObjects];
}


@end
