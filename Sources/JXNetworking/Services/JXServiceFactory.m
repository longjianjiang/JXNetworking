//
//  JXServiceFactory.m
//  JXNetworking
//
//  Created by zl on 2018/5/4.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import "JXServiceFactory.h"
#import <CTMediator/CTMediator.h>

@interface JXServiceFactory()
@property (nonatomic, strong) NSMutableDictionary *serviceCache;
@end


@implementation JXServiceFactory

#pragma mark - getter and setter
- (NSMutableDictionary *)serviceCache {
    if (_serviceCache == nil) {
        _serviceCache = [NSMutableDictionary new];
    }
    return _serviceCache;
}

#pragma mark - life cycle
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static JXServiceFactory *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [JXServiceFactory new];
    });
    return instance;
}

#pragma mark - public method
- (id<JXServiceProtocol>)serviceWithIdentifier:(NSString *)identifier {
    if ([self.serviceCache objectForKey:identifier] == nil) {
        self.serviceCache[identifier] = [self createServiceWithIdentifier:identifier];
    }
    
    return self.serviceCache[identifier];
}

#pragma mark - private method
- (id<JXServiceProtocol>)createServiceWithIdentifier:(NSString *)identifier {
    return [[CTMediator sharedInstance] performTarget:identifier action:identifier params:nil shouldCacheTarget:NO];
}
@end
