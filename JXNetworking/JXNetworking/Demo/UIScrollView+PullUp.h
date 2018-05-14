//
//  UIScrollView+PullUp.h
//  Weibo
//
//  Created by longjianjiang on 2017/3/26.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PullUpBlock)(void);

typedef enum : NSUInteger { 
    LJPullUpStateStopped,
    LJPullUpStateTriggered,
    LJPullUpStateLoading,
} LJPullUpState;


// 加载更多底部显示的“菊花”
@interface LJScrollIndicator : UIView
@property (nonatomic,assign) LJPullUpState state;
@property (nonatomic,assign) UIActivityIndicatorViewStyle style;
- (void)showIndicator;
- (void)hideIndicator;
@end


@interface UIScrollView (PullUp)

- (void)addPullUpWithActionHandler:(PullUpBlock)handler;

@property (nonatomic,strong,readonly) LJScrollIndicator *indicator;
@property (nonatomic,assign) BOOL pullUpGetMore;
@end




