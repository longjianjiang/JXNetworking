//
//  JXDiskCacheManager.h
//  JXNetworking
//
//  Created by zl on 2018/5/5.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JXResponseObject.h"


@interface JXDiskCacheManager : NSObject

- (JXResponseSuccessItem *)fetchCachedSuccessItemWithKey:(NSString *)key;

- (void)saveCacheWithSuccessItem:(JXResponseSuccessItem *)successItem
                             key:(NSString *)key
                       cacheTime:(NSTimeInterval)cacheTime;

- (void)clearAll;

@end
