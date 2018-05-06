//
//  JXServiceFactory.h
//  JXNetworking
//
//  Created by zl on 2018/5/4.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JXServiceProtocol.h"

@interface JXServiceFactory : NSObject

+ (instancetype)sharedInstance;

- (id<JXServiceProtocol>)serviceWithIdentifier:(NSString *)identifier;

@end
