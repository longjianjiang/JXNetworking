//
//  JXMemoryCacheRecord.h
//  JXNetworking
//
//  Created by longjianjiang on 2018/6/3.
//  Copyright © 2018 longjianjiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JXMemoryCacheRecord : NSObject

@property (nonatomic, copy, readonly) NSData *content;
@property (nonatomic, copy, readonly) NSDate *lastUpdateDate;
@property (nonatomic, assign) NSTimeInterval cacheTime;

@property (nonatomic, assign, readonly) BOOL isOutdated;
@property (nonatomic, assign, readonly) BOOL isEmpty;

- (void)updateContent:(NSData *)content;
- (instancetype)initWithCacheTime:(NSTimeInterval)cacheTime;

@end
