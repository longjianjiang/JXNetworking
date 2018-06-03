//
//  JXMemoryCacheManager.h
//  JXNetworking
//
//  Created by longjianjiang on 2018/6/3.
//  Copyright © 2018 longjianjiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JXResponseObject.h"

@interface JXMemoryCacheManager : NSObject


- (JXResponseSuccessItem *)fetchCachedSuccessItemWithKey:(NSString *)key;

- (void)saveCacheWithSuccessItem:(JXResponseSuccessItem *)successItem
                             key:(NSString *)key
                       cacheTime:(NSTimeInterval)cacheTime;

- (void)clearAll;

@end
