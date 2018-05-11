//
//  JXDemoAPIManager.m
//  JXNetworking
//
//  Created by zl on 2018/5/7.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import "JXDemoAPIManager.h"
#import "Target_JXDemoService.h"



@interface JXDemoAPIManager()<JXAPIManagerValidator> {
    BOOL _hasNextPage;
    NSUInteger _currentPage;
    NSUInteger _totalPage;
}

@end


@implementation JXDemoAPIManager

- (instancetype)init {
    if (self = [super init]) {
        _currentPage = 1;
        _hasNextPage = YES;
        self.validator = self;
    }
    return self;
}


#pragma mark - JXPageableAPIManager
- (NSUInteger)currentPageSize {
    return [self.successItem.responseJSONDict[@"data"][@"items"] count];
}

- (NSUInteger)pageSize {
    return 10;
}

// public method
- (void)resetPage {
    [self resetPage:1];
}

- (void)resetPage:(NSUInteger)page {
    if (_totalPage && page > _totalPage) {
        return;
    }
    _currentPage = page;
    
    _hasNextPage = page < _totalPage;
}

- (NSInteger)loadNextPage {
    if (self.isLoading) {
        return -1;
    }
    return [super loadData];
}

// property
- (NSUInteger)currentPageNumber {
    return _currentPage;
}
- (BOOL)hasNextPage {
    return _hasNextPage;
}


#pragma mark - JXAPIManager
- (NSString *)apiPath {
    return @"student/video/all";
}

- (NSString *)apiVersion {
    return @"v1.0";
}

- (NSString *)apiServiceIdentifier {
    return JXNetworkingDemoServiceIdentifier;
}

- (NSDictionary *)reformParams:(NSDictionary *)params {
    NSMutableDictionary *mutableParams = [params mutableCopy];
    [mutableParams setObject:@(_currentPage) forKey:@"page"];
    [mutableParams setObject:@(2) forKey:@"video_type"];
    [mutableParams setObject:@(self.pageSize) forKey:@"per_page"];
    return mutableParams;
}


#pragma mark - JXAPIManagerValidator
- (JXNetworkingAPIManagerErrorType)jxManager:(JXBaseAPIManager *)manager isCorrectWithResponseData:(id)responseData {
    return JXNetworkingAPIManagerErrorTypeParamsCorrect;
}

- (JXNetworkingAPIManagerErrorType)jxManager:(JXBaseAPIManager *)manager isCorrectWithParamsForCallAPI:(NSDictionary *)params {
    return JXNetworkingAPIManagerErrorTypeParamsCorrect;
}

#pragma mark - JXAPIManagerInterceptor
- (BOOL)beforePerformSuccessItem:(JXResponseSuccessItem *)successItem {
   
    if (self.currentPageSize < self.pageSize) {
        _totalPage = _currentPage;
        _hasNextPage = NO;
    } else {
         _currentPage += 1;
    }
    return [super beforePerformSuccessItem:successItem];
}

- (BOOL)beforePerformFailItem:(JXResponseFailItem *)failItem {
    if (_currentPage > 1) {
        _currentPage -= 1;
    }
    return [super beforePerformFailItem:failItem];
}

@end
