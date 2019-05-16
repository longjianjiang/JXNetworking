//
//  JXDiskCacheManager.m
//  JXNetworking
//
//  Created by zl on 2018/5/5.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import "JXDiskCacheManager.h"

NSString * const kJXDiskCacheManagerCachedItemKeyPrefix = @"kJXDiskCacheManagerCachedItemKeyPrefix";

NSString * const kJXDiskCacheManagerCacheItemParameterLastUpdateTime = @"kJXDiskCacheManagerCacheItemParameterLastUpdateTime";
NSString * const kJXDiskCacheManagerCacheItemParameterCacheTime = @"kJXDiskCacheManagerCacheItemParameterCacheTime";
NSString * const kJXDiskCacheManagerCacheItemParameterResponseJSONDict = @"kJXDiskCacheManagerCacheItemParameterResponseJSONDict";


@implementation JXDiskCacheManager

- (void)saveCacheWithSuccessItem:(JXResponseSuccessItem *)successItem
                             key:(NSString *)key
                       cacheTime:(NSTimeInterval)cacheTime {
    
    if (successItem.responseJSONDict) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:@{kJXDiskCacheManagerCacheItemParameterResponseJSONDict: successItem.responseJSONDict,
                                                                 kJXDiskCacheManagerCacheItemParameterLastUpdateTime: @([NSDate date].timeIntervalSince1970),
                                                                 kJXDiskCacheManagerCacheItemParameterCacheTime: @(cacheTime)
                                                                 }
                                                       options:0
                                                         error:NULL];
        if (data) {
            NSString *actualKey = [NSString stringWithFormat:@"%@%@",kJXDiskCacheManagerCachedItemKeyPrefix,key];
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:actualKey];
        }
    }
    
}

- (JXResponseSuccessItem *)fetchCachedSuccessItemWithKey:(NSString *)key {
    NSString *actualKey = [NSString stringWithFormat:@"%@%@",kJXDiskCacheManagerCachedItemKeyPrefix, key];
    JXResponseSuccessItem *successItem = nil;
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:actualKey];
    if (data) {
        NSDictionary *cacheItem = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
        
        NSNumber *lastUpdateTimeInterval = cacheItem[kJXDiskCacheManagerCacheItemParameterLastUpdateTime];
        NSDate *lastUpdateDate = [[NSDate alloc] initWithTimeIntervalSince1970:lastUpdateTimeInterval.doubleValue];
        NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:lastUpdateDate];
        
        if (timeInterval < [cacheItem[kJXDiskCacheManagerCacheItemParameterCacheTime] doubleValue]) {
            NSData *successItemData = [NSJSONSerialization dataWithJSONObject:cacheItem[kJXDiskCacheManagerCacheItemParameterResponseJSONDict] options:0 error:NULL];
            successItem = [[JXResponseSuccessItem alloc] initWithData:successItemData];
        } else {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:actualKey];
        }
    }
    
    return successItem;
}

- (void)clearAll {
    NSDictionary *defaultsDict = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
    NSArray *keys = [[defaultsDict allKeys] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF beginswith[c] %@", kJXDiskCacheManagerCachedItemKeyPrefix]];
    for(NSString *key in keys) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    }
}


@end
