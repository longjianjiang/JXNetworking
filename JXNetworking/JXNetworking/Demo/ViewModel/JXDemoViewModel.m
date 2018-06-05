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

NSString * const kJXDemoViewModelReactiveTypeNormal = @"kJXDemoViewModelReactiveTypeNormal";
NSString * const kJXDemoViewModelReactiveTypePageable = @"kJXDemoViewModelReactiveTypePageable";

@interface JXDemoViewModel()<JXAPIManagerDataSource, JXAPIManagerDelegate>

@property (nonatomic, strong) JXDemoManager *normalManager;
@property (nonatomic, strong) JXPageableDemoManager *pageableManager;

@property (nonatomic, strong) JXPageableDemoDataReformer *pageableDemoReformer;

@end



@implementation JXDemoViewModel

#pragma mark - JXAPIManagerReactiveProtocol
- (JXNetworkingReactiveTable *)reactiveTable {
    return @{kJXDemoViewModelReactiveTypeNormal: self.normalManager,
             kJXDemoViewModelReactiveTypePageable: self.pageableManager
             };
}

#pragma mark - life cycle

- (void)bindViewModel {
    [self.reactiveTable[kJXDemoViewModelReactiveTypePageable].executionSignal subscribeNext:^(JXResponseSuccessItem * _Nullable x) {
        NSMutableArray *added = [NSMutableArray arrayWithArray:self.videoList];
        [added addObjectsFromArray:x.responseJSONDict[@"data"][@"items"]];
        self.videoList = added;
    }];
}


- (instancetype)init {
    self = [super init];
    if (self) {
        _videoList = @[];
        [self bindViewModel];
        [self.reactiveTable[kJXDemoViewModelReactiveTypePageable].refreshPageCommand execute:nil];
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

#pragma mark - getter and setter
- (BOOL)hasNextPage {
    return self.pageableManager.hasNextPage;
}


- (JXPageableDemoManager *)pageableManager {
    if (_pageableManager == nil) {
        _pageableManager = [JXPageableDemoManager new];
        _pageableManager.delegate = self;
        _pageableManager.paramsSource = self;
        _pageableManager.cachePolicy = JXNetworkingCachePolicyMemory;
    }
    return _pageableManager;
    
}

- (JXDemoManager *)normalManager {
    if (_normalManager == nil) {
        _normalManager = [JXDemoManager new];
//        _normalManager.cachePolicy = JXNetworkingCachePolicyDisk;
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


#pragma mark - not use
- (void)loadNextPage {
    [self.pageableManager loadNextPage];
}

#pragma mark - JXAPIManagerDelegate
- (void)jxManagerCallAPIDidSuccess:(JXBaseAPIManager *)manager {
    NSLog(@"call api manager success");
    
    //    NSMutableArray *added = [NSMutableArray arrayWithArray:self.videoList];
    ////  NSArray *videoItems = [manager fetchDataWithReformer:self.pageableDemoReformer];
    //    [added addObjectsFromArray:manager.successItem.responseJSONDict[@"data"][@"items"]];
    //    self.videoList = added;
    
}


- (void)jxManager:(JXBaseAPIManager *)manager callAPIDidFail:(JXResponseFailItem *)failItem {
    NSLog(@"call api manager fail");
    
    //    self.errorMsg = failItem.errorMsg;
}
@end
