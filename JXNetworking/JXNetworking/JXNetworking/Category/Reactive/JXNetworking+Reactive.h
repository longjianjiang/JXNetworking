//
//  JXNetworking+Reactive.h
//  JXNetworking
//
//  Created by zl on 2018/5/14.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import "JXBaseAPIManager.h"

#import <ReactiveObjC/ReactiveObjC.h>

@protocol JXNetworkingReactiveExtension <NSObject>

- (RACCommand *)requestCommmand;
- (RACCommand *)cancelCommand;
- (RACSignal *)requestErrorSignal;
- (RACSignal *)executionSignal;

// pageable api manager
- (RACCommand *)loadNextPageCommand;

@end


@interface JXBaseAPIManager (Reactive) <JXNetworkingReactiveExtension>

@property (nonatomic, strong, readonly) RACCommand *requestCommand;
@property (nonatomic, strong, readonly) RACCommand *cancelCommand;
@property (nonatomic, strong, readonly) RACSignal *requestErrorSignal;
@property (nonatomic, strong, readonly) RACSignal *executionSignal;

@property (nonatomic, strong, readonly) RACCommand *loadNextPageCommand;

- (RACSignal *)requestSignal;

@end
