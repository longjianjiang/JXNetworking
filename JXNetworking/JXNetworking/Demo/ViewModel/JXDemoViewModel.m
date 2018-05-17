//
//  JXDemoViewModel.m
//  JXNetworking
//
//  Created by zl on 2018/5/14.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import "JXDemoViewModel.h"
#import "JXPageableDemoManager.h"
#import "JXDemoManager.h"

#import "JXPageableDemoDataReformer.h"
#import "JXNetworking.h"

@interface JXDemoViewModel()<JXAPIManagerDataSource, JXAPIManagerDelegate>

@property (nonatomic, strong) JXDemoManager *normalManager;
@property (nonatomic, strong) JXPageableDemoManager *pageableManager;

@property (nonatomic, strong) JXPageableDemoDataReformer *pageableDemoReformer;

@end



@implementation JXDemoViewModel


- (void)loadNextPage {
    [self.pageableManager loadNextPage];
}

#pragma mark - life cycle

- (void)bindViewModel {
//    [self.pageableManager.requestSignal subscribeNext:^(id  _Nullable x) {
//        NSLog(@"items is %@",x);
//    } error:^(NSError * _Nullable error) {
//        NSLog(@"error is %@", error);
//    }];
    
    [self.pageableManager.executionSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"items is %@",x);
    }];
    
    [self.pageableManager.requestErrorSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"error is %@", x);
    }];

    [self.pageableManager.refreshPageCommand execute:nil];
   
}


- (instancetype)init {
    self = [super init];
    if (self) {
        _videoList = @[];
//        [self bindViewModel];
    }
    return self;
}


#pragma mark - JXAPIManagerDataSource
- (NSDictionary *)paramsForCallAPI:(JXBaseAPIManager *)manager {
    if (manager == self.normalManager) {
        return @{@"token": @"0e7e8f19-401b-47d4-8658-e296bea5411c",
                 @"type": @(1)
                 };
    } else if (manager == self.pageableManager) {
        return @{@"token": @"0e7e8f19-401b-47d4-8658-e296bea5411c"};
    }
    
    return nil;
}

#pragma mark - JXAPIManagerDelegate
- (void)jxManagerCallAPIDidSuccess:(JXBaseAPIManager *)manager {
    NSLog(@"call api manager success");
    
    NSMutableArray *added = [NSMutableArray arrayWithArray:self.videoList];
//  NSArray *videoItems = [manager fetchDataWithReformer:self.pageableDemoReformer];
    [added addObjectsFromArray:manager.successItem.responseJSONDict[@"data"][@"items"]];
    self.videoList = added;
    
}


- (void)jxManager:(JXBaseAPIManager *)manager callAPIDidFail:(JXResponseFailItem *)failItem {
    NSLog(@"call api manager fail");
    
    self.errorMsg = failItem.errorMsg;
}

#pragma mark - getter and setter
- (BOOL)hasNextPage {
    return self.pageableManager.hasNextPage;
}


- (JXPageableDemoManager *)pageableManager {
    if (_pageableManager == nil) {
        _pageableManager = [JXPageableDemoManager new];
        _pageableManager.delegate = self;
        _pageableManager.paramsSource = self;
    }
    return _pageableManager;
    
}

- (JXDemoManager *)normalManager {
    if (_normalManager == nil) {
        _normalManager = [JXDemoManager new];
        _normalManager.cachePolicy = JXNetworkingCachePolicyDisk;
        _normalManager.delegate = self;
        _normalManager.paramsSource = self;
    }
    return _normalManager;
}

- (JXPageableDemoDataReformer *)pageableDemoReformer {
    if (_pageableDemoReformer == nil) {
        _pageableDemoReformer = [JXPageableDemoDataReformer new];
    }
    return _pageableDemoReformer;
}
@end
