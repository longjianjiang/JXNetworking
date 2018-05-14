//
//  JXDemoCell.h
//  JXNetworking
//
//  Created by zl on 2018/5/14.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const kJXDemoCellReuseIdentifier;

@interface JXDemoCell : UITableViewCell
- (void)updateMsg:(NSString *)msg;
@end
