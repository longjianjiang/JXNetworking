//
//  JXResponseObject.h
//  JXNetworking
//
//  Created by zl on 2018/5/4.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, JXResponseStatus) {
    JXResponseStatusSuccess, //作为底层，请求是否成功只考虑是否成功收到服务器反馈。至于签名是否正确，返回的数据是否完整，由上层的APIManager来决定。
    JXResponseStatusErrorTimeout,
    JXResponseStatusErrorCancel,
    JXResponseStatusErrorNoNetwork // 默认除了超时以外的错误都是无网络错误。
};

@interface JXResponseSuccessItem : NSObject

@property (nonatomic, strong, readonly) NSURLRequest *request;
@property (nonatomic, strong, readonly) NSData *responseData;
@property (nonatomic, strong, readonly) id responseJSONDict;
@property (nonatomic, assign, readonly) BOOL isCache;
@property (nonatomic, assign, readonly) JXResponseStatus status;
@property (nonatomic, assign, readonly) NSInteger requestId;

@property (nonatomic, strong) NSDictionary *originalRequestParams;
@property (nonatomic, strong) NSDictionary *actualRequestParams;

- (instancetype)initResponseSuccessItemWithRequest:(NSURLRequest *)request
                                      responseData:(NSData *)responseData
                                         requestId:(NSNumber *)requestId;


// 使用initWithData的response，它的isCache是YES，上面函数生成的response的isCache是NO
- (instancetype)initWithData:(NSData *)data;

@end

@interface JXResponseFailItem : NSObject

@property (nonatomic, strong, readonly) NSURLRequest *request;
@property (nonatomic, strong, readonly) NSString *errorMsg;
@property (nonatomic, assign, readonly) JXResponseStatus status;
@property (nonatomic, assign, readonly) NSInteger requestId;

@property (nonatomic, strong, readonly) NSError *error;

- (instancetype)initWithResponseFailItemWithRequest:(NSURLRequest *)request
                                          requestId:(NSNumber *)requestId
                                              error:(NSError *)error;
- (void)updateErrorMsg:(NSString *)errorMsg;

@end

