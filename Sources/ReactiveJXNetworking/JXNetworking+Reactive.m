//
//  JXNetworking+Reactive.m
//  JXNetworking
//
//  Created by zl on 2018/5/14.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import "JXNetworking+Reactive.h"
#import "JXResponseObject.h"

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
        }] subscribeNext:^(JXResponseFailItem *failItem) {
            [subscriber sendError:failItem.error];
        }];
        
        return nil;
    }] replayLazily] takeUntil:self.rac_willDeallocSignal];
    
    return requestSignal;
}


- (RACCommand *)requestCommand {
    
    if ([self conformsToProtocol:@protocol(JXPageableAPIManager)]) {
        @throw [NSException exceptionWithName:[NSString stringWithFormat:@"%@ loadData fail",[self class]]
                                       reason:@"You should not use load data but loadNextPage when api manager implement <JXPageableAPIManager>"
                                     userInfo:nil];
    }
    
    RACCommand *requestCommand = objc_getAssociatedObject(self, @selector(requestCommand));
    if (requestCommand == nil) {
        @weakify(self);
        requestCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            self.requestId = [self loadData];
            return [self.requestSignal takeUntil:self.cancelCommand.executionSignals];
        }];
        objc_setAssociatedObject(self, @selector(requestCommand), requestCommand, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return requestCommand;
}

- (RACCommand *)cancelCommand {
    RACCommand *cancelCommand = objc_getAssociatedObject(self, @selector(cancelCommand));
    if (cancelCommand == nil) {
        @weakify(self);
        cancelCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            [self cancelRequestWithRequestId:self.requestId];
            return [RACSignal empty];
        }];
        objc_setAssociatedObject(self, @selector(cancelCommand), cancelCommand, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return cancelCommand;
}


- (RACCommand *)loadNextPageCommand {
    RACCommand *loadNextPageCommand = objc_getAssociatedObject(self, @selector(loadNextPageCommand));
    if (loadNextPageCommand == nil) {
        @weakify(self);
        loadNextPageCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self);
            if ([self conformsToProtocol:@protocol(JXPageableAPIManager)]) {
                self.requestId = [(id<JXPageableAPIManager>)(self) loadNextPage];
            } else {
                @throw [NSException exceptionWithName:[NSString stringWithFormat:@"%@ loadNextPage fail",[self class]]
                                               reason:@"If want to call loadNextPage, Subclass of JXBaseAPIManager should implement <JXPageableAPIManager>"
                                             userInfo:nil];
            }
            return self.requestSignal;
        }];
        objc_setAssociatedObject(self, @selector(loadNextPageCommand), loadNextPageCommand, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return loadNextPageCommand;
}

- (RACCommand *)refreshPageCommand {
    RACCommand *refreshPageCommand = objc_getAssociatedObject(self, @selector(refreshPageCommand));
    if (refreshPageCommand == nil) {
        @weakify(self);
        refreshPageCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self);
            if ([self conformsToProtocol:@protocol(JXPageableAPIManager)]) {
                [(id<JXPageableAPIManager>)(self) resetPage];
                self.requestId = [(id<JXPageableAPIManager>)(self) loadNextPage];
            } else {
                @throw [NSException exceptionWithName:[NSString stringWithFormat:@"%@ refresh page fail",[self class]]
                                               reason:@"If want to call refresh page, Subclass of JXBaseAPIManager should implement <JXPageableAPIManager>"
                                             userInfo:nil];
            }
            return self.requestSignal;
        }];
        objc_setAssociatedObject(self, @selector(refreshPageCommand), refreshPageCommand, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return refreshPageCommand;
}

- (RACSignal *)requestErrorSignal {
    if ( [self conformsToProtocol:@protocol(JXPageableAPIManager)] ) {
        return [[RACSignal merge:@[self.refreshPageCommand.errors, self.loadNextPageCommand.errors]] subscribeOn:[RACScheduler mainThreadScheduler]];
    }
    
    return [self.requestCommand.errors subscribeOn:[RACScheduler mainThreadScheduler]];
}

- (RACSignal *)executionSignal {
    if ([self conformsToProtocol:@protocol(JXPageableAPIManager)]) {
        RACSignal *refreshPageSignal = [self.refreshPageCommand.executionSignals switchToLatest];
        RACSignal *loadNextPageSignal = [self.loadNextPageCommand.executionSignals switchToLatest];
        return [RACSignal merge:@[refreshPageSignal, loadNextPageSignal]];
    }
    return [self.requestCommand.executionSignals switchToLatest];
}

- (RACSignal *)executing {
    if ( [self conformsToProtocol:@protocol(JXPageableAPIManager)] ) {
        return [RACSignal merge:@[self.refreshPageCommand.executing, self.loadNextPageCommand.executing]];
    }
    
    return self.requestCommand.executing;
}

@end


