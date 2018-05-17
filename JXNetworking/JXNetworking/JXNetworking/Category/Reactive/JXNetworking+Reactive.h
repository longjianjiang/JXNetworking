//
//  JXNetworking+Reactive.h
//  JXNetworking
//
//  Created by zl on 2018/5/14.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import "JXBaseAPIManager.h"

#import <ReactiveObjC/ReactiveObjC.h>

/*************************************************************************************/

@protocol JXAPIManagerReactiveExtension <NSObject>

- (RACCommand *)requestCommand;
- (RACCommand *)cancelCommand;
- (RACSignal *)requestErrorSignal;
- (RACSignal *)executionSignal;

@end

/*************************************************************************************/

@protocol JXPageableAPIManagerReactiveExtension <JXAPIManagerReactiveExtension>

- (RACCommand *)refreshPageCommand;
- (RACCommand *)loadNextPageCommand;

@end

/*************************************************************************************/

@protocol JXAPIManagerReactiveProtocol <NSObject>

@required
- (id <JXAPIManagerReactiveExtension>)reactive;

@end


/*************************************************************************************/

@protocol JXPageableAPIManagerReactiveProtocol <NSObject>

@required
- (id <JXPageableAPIManagerReactiveExtension>)reactive;

@end


/*************************************************************************************/

@interface JXBaseAPIManager (Reactive) <JXAPIManagerReactiveExtension, JXPageableAPIManagerReactiveExtension>

@property (nonatomic, strong, readonly) RACCommand *requestCommand;
@property (nonatomic, strong, readonly) RACCommand *cancelCommand;
@property (nonatomic, strong, readonly) RACSignal *requestErrorSignal;
@property (nonatomic, strong, readonly) RACSignal *executionSignal;

@property (nonatomic, strong, readonly) RACCommand *refreshPageCommand;
@property (nonatomic, strong, readonly) RACCommand *loadNextPageCommand;

- (RACSignal *)requestSignal;

@end
