//
//  JXMemoryCacheRecord.m
//  JXNetworking
//
//  Created by longjianjiang on 2018/6/3.
//  Copyright © 2018 longjianjiang. All rights reserved.
//

#import "JXMemoryCacheRecord.h"

@interface JXMemoryCacheRecord()

@property (nonatomic, copy, readwrite) NSData *content;
@property (nonatomic, copy, readwrite) NSDate *lastUpdateDate;

@end

@implementation JXMemoryCacheRecord

#pragma mark - getter and setter
- (BOOL)isEmpty {
    return self.content == nil;
}

- (BOOL)isOutdated {
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.lastUpdateDate];
    return timeInterval > self.cacheTime;
}

- (void)setContent:(NSData *)content {
    _content = [content copy];
    self.lastUpdateDate = [NSDate date];
}

#pragma mark - life cycle
- (instancetype)initWithCacheTime:(NSTimeInterval)cacheTime {
    self = [super init];
    if (self) {
        self.cacheTime = cacheTime;
    }
    return self;
}

#pragma mark - public method
- (void)updateContent:(NSData *)content {
    self.content = content;
}

@end
