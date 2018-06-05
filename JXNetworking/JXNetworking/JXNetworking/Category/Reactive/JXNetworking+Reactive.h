//
//  JXNetworking+Reactive.h
//  JXNetworking
//
//  Created by zl on 2018/5/14.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import "JXBaseAPIManager.h"

#import <ReactiveObjC/ReactiveObjC.h>

@protocol JXAPIManagerReactiveExtension;
typedef NSDictionary<NSString *,id<JXAPIManagerReactiveExtension>> JXNetworkingReactiveTable;

/*************************************************************************************/

@protocol JXAPIManagerReactiveExtension <NSObject>

- (RACCommand *)requestCommand;
- (RACCommand *)cancelCommand;

- (RACCommand *)refreshPageCommand;
- (RACCommand *)loadNextPageCommand;

- (RACSignal<NSError *> *)requestErrorSignal;
- (RACSignal<JXResponseSuccessItem *> *)executionSignal;
- (RACSignal<NSNumber *> *)executing;

@end

/*************************************************************************************/

@protocol JXAPIManagerReactiveProtocol <NSObject>

@optional
- (id <JXAPIManagerReactiveExtension>)reactive;
- (JXNetworkingReactiveTable *)reactiveTable;

@end


/*************************************************************************************/

@interface JXBaseAPIManager (Reactive) <JXAPIManagerReactiveExtension>

@property (nonatomic, strong, readonly) RACCommand *requestCommand;
@property (nonatomic, strong, readonly) RACCommand *cancelCommand;

@property (nonatomic, strong, readonly) RACSignal *requestErrorSignal;
@property (nonatomic, strong, readonly) RACSignal *executionSignal;
@property (nonatomic, strong, readonly) RACSignal *executing;

@property (nonatomic, strong, readonly) RACCommand *refreshPageCommand;
@property (nonatomic, strong, readonly) RACCommand *loadNextPageCommand;


@end
