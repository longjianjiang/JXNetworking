//
//  JXPageableDemoManager.m
//  JXNetworking
//
//  Created by zl on 2018/5/11.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import "JXPageableDemoManager.h"
#import "Target_JXDemoService.h"


@interface JXPageableDemoManager()<JXAPIManagerValidator> {
    NSUInteger _currentPage;
    BOOL _hasNextPage;
    NSUInteger _totalPage;
}

@end

@implementation JXPageableDemoManager

-(instancetype)init {
    if (self = [super init]) {
        _currentPage = 1;
        _hasNextPage = YES;
        self.validator = self;
    }
    return self;
}

- (NSDictionary *)reformParams:(NSDictionary *)params {
    NSMutableDictionary *mutableParams = [params mutableCopy];
    [mutableParams setObject:@(_currentPage) forKey:@"page"];
    [mutableParams setObject:@(self.pageSize) forKey:@"per_page"];
    [mutableParams setObject:@(3) forKey:@"video_type"];
    return mutableParams;
}


#pragma mark - JXPageableAPIManager

// delegate
- (NSUInteger)currentPageSize {
    return [self.successItem.responseJSONDict[@"data"][@"review"] count];
}
- (NSUInteger)pageSize {
    return 20;
}

// method
- (NSInteger)loadNextPage {
    if (self.isLoading) {
        return -1;
    }
    
    return [super loadData];
}
- (void)resetPage {
    [self resetPage:1];
}
- (void)resetPage:(NSUInteger)page {
    
    if (page == 1) {
        _currentPage = 1;
        _hasNextPage = YES;
        return;
    }
    
    if (_totalPage == 0 || page > _totalPage) {
        return;
    }
    
    _currentPage = page;
    
    _hasNextPage = page < _totalPage;
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
    return @"msg/review/list";
}

- (NSString *)apiVersion {
    return @"v1.0";
}

- (NSString *)apiServiceIdentifier {
    return JXNetworkingDemoServiceIdentifier;
}


#pragma mark - JXAPIManagerValidator
- (JXNetworkingAPIManagerErrorType)jxManager:(JXBaseAPIManager *)manager isCorrectWithResponseData:(id)responseData {
    if ([responseData[@"code"] integerValue] == 20000) {
        return JXNetworkingAPIManagerErrorTypeParamsCorrect;
    }
    
    return JXNetworkingAPIManagerErrorTypeContentError;
}

- (JXNetworkingAPIManagerErrorType)jxManager:(JXBaseAPIManager *)manager isCorrectWithParamsForCallAPI:(NSDictionary *)params {
    return JXNetworkingAPIManagerErrorTypeParamsCorrect;
}


#pragma mark - Interceptor
- (BOOL)beforePerformSuccessItem:(JXResponseSuccessItem *)successItem {
    if (self.currentPageSize < self.pageSize) {
        _hasNextPage = NO;
        _totalPage = _currentPage;
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
