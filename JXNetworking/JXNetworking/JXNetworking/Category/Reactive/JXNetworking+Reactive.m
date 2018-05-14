//
//  JXNetworking+Reactive.m
//  JXNetworking
//
//  Created by zl on 2018/5/14.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import "JXNetworking+Reactive.h"
#import <objc/runtime.h>


@interface JXBaseAPIManager (_Reactive)
@property (nonatomic, assign) NSInteger requestId;
@end

@implementation JXBaseAPIManager (_Reactive)
- (void)setRequestId:(NSInteger)requestId {
    objc_setAssociatedObject(self, @selector(requestId), @(requestId), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSInteger)requestId {
    return [objc_getAssociatedObject(self, @selector(requestId)) integerValue];
}
@end

@implementation JXBaseAPIManager (Reactive)

- (RACSignal *)requestSignal {
    @weakify(self);
    RACSignal *requestSignal = [[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self);
        RACSignal *successSignal = [self rac_signalForSelector:@selector(afterPerformSuccessItem:)];
        
        [[successSignal map:^id _Nullable(RACTuple *tuple) {
            return tuple.first;
        }] subscribeNext:^(id  _Nullable x) {
            [subscriber sendNext:x];
            [subscriber sendCompleted];
        }];
        
        RACSignal *failSignal = [self rac_signalForSelector:@selector(afterPerformFailItem:)];
        
        [[failSignal map:^id _Nullable(RACTuple *tuple) {
            return tuple.first;
        }] subscribeNext:^(id  _Nullable x) {
            [subscriber sendError:x];
        }];
        
        return nil;
    }] replayLazily] takeUntil:self.rac_willDeallocSignal];
    
    return requestSignal;
}

@end


