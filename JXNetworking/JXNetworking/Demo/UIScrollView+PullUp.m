//
//  UIScrollView+PullUp.m
//  Weibo
//
//  Created by longjianjiang on 2017/3/26.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "UIScrollView+PullUp.h"
#import <objc/runtime.h>

static CGFloat const LJScrollIndicatorHeight = 60;
static char LJIndicator;

@interface LJScrollIndicator()
@property (nonatomic,copy) PullUpBlock handler;
@property (nonatomic,weak) UIScrollView *scrollView;
@property (nonatomic,strong) UIActivityIndicatorView *indicator;
@property (nonatomic, assign) CGFloat originalBottomInset; // 设置UIScrollView的contentInset属性放置indicator

@property (nonatomic,assign,getter=isObserving) BOOL observing;


- (void)resetScrollViewContentInset; // 去除indicator所占的contentInset
- (void)setScrollViewContentInsetForIndicator; // 设置contentInset显示indicator
@end


@implementation UIScrollView (PullUp)


- (void)addPullUpWithActionHandler:(PullUpBlock)handler {
    if (!self.indicator) {
//        if (self.contentInset.bottom >= ddScreenHeight) {
            LJScrollIndicator* indicator = [[LJScrollIndicator alloc] initWithFrame:CGRectMake(0, self.contentSize.height, self.bounds.size.width, LJScrollIndicatorHeight)];
            indicator.handler = handler;
            indicator.scrollView = self;
            [self addSubview:indicator];
            
            indicator.originalBottomInset = self.contentInset.bottom;
            self.indicator = indicator;
            self.pullUpGetMore = YES;
//        }
        
    }
}

- (void)setPullUpGetMore:(BOOL)pullUpGetMore {
    self.indicator.hidden = !pullUpGetMore;
    
    if (pullUpGetMore) {
        if (!self.indicator.isObserving) {
            [self addObserver:self.indicator forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
            [self addObserver:self.indicator forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
            [self.indicator setScrollViewContentInsetForIndicator];
            self.indicator.observing = YES;
            [self.indicator setNeedsLayout];
            self.indicator.frame = CGRectMake(0, self.contentSize.height, self.bounds.size.width, LJScrollIndicatorHeight);
        }
    } else {
        if (self.indicator.isObserving) {
            [self removeObserver:self.indicator forKeyPath:@"contentOffset"];
            [self removeObserver:self.indicator forKeyPath:@"contentSize"];
            [self.indicator resetScrollViewContentInset];
            self.indicator.observing = NO;
        }
    }
}

- (BOOL)pullUpGetMore {
    return !self.indicator.isHidden;
}
// 使用runtime为分类增加新的属性
- (void)setIndicator:(LJScrollIndicator *)indicator {
    [self willChangeValueForKey:@"LJIndicator"];
    objc_setAssociatedObject(self,
                             &LJIndicator,
                             indicator,
                             OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"LJIndicator"];
}
- (LJScrollIndicator *)indicator {
    return objc_getAssociatedObject(self, &LJIndicator);
}
@end



@implementation LJScrollIndicator

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _style = UIActivityIndicatorViewStyleGray;
        _state = LJPullUpStateStopped;
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (self.superview && newSuperview == nil) {
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        if (scrollView.pullUpGetMore) {
            if (self.isObserving) {
                [scrollView removeObserver:self forKeyPath:@"contentOffset"];
                [scrollView removeObserver:self forKeyPath:@"contentSize"];
                self.observing = NO;
            }
        }
    }
}

- (void)layoutSubviews {
    self.indicator.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
}


#pragma mark scrollview contentInset
- (void)resetScrollViewContentInset {
    UIEdgeInsets contentInset = self.scrollView.contentInset;
    contentInset.bottom = self.originalBottomInset;
    [self setScrollViewContentInset:contentInset];
}
- (void)setScrollViewContentInsetForIndicator {
    UIEdgeInsets contentInset = self.scrollView.contentInset;
    contentInset.bottom = self.originalBottomInset + LJScrollIndicatorHeight;
    [self setScrollViewContentInset:contentInset];
}
- (void)setScrollViewContentInset:(UIEdgeInsets)contentInset {
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.scrollView.contentInset = contentInset;
                     }
                     completion:NULL];
}

#pragma mark - Observing
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        [self scrollViewDidScroll:[[change valueForKey:NSKeyValueChangeNewKey] CGPointValue]];
    } else if ([keyPath isEqualToString:@"contentSize"]) {
        [self layoutSubviews];
        self.frame = CGRectMake(0, self.scrollView.contentSize.height, self.bounds.size.width, LJScrollIndicatorHeight);
    }
}

- (void)scrollViewDidScroll:(CGPoint)contentOffset {
    if (self.state != LJPullUpStateLoading) {
        CGFloat scrollViewContentHeight = self.scrollView.contentSize.height;
        CGFloat scrollOffsetThreshold = scrollViewContentHeight - self.scrollView.bounds.size.height;
        
        if (!self.scrollView.isDragging && self.state == LJPullUpStateTriggered) {
            self.state = LJPullUpStateLoading;
        } else if (contentOffset.y > scrollOffsetThreshold && self.state == LJPullUpStateStopped && self.scrollView.isDragging) {
            self.state = LJPullUpStateTriggered;
        } else if (contentOffset.y < scrollOffsetThreshold && self.state != LJPullUpStateStopped) {
            self.state = LJPullUpStateStopped;
        }
    }
}

#pragma mark - Getters
- (UIActivityIndicatorView *)indicator {
    if (!_indicator) {
        _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicator.hidesWhenStopped = YES;
        [self addSubview:_indicator];
    }
    return _indicator;
}

- (UIActivityIndicatorViewStyle)activityIndicatorViewStyle {
    return self.indicator.activityIndicatorViewStyle;
}
#pragma mark - Setters
- (void)setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)viewStyle {
    self.indicator.activityIndicatorViewStyle = viewStyle;
}

- (void)setState:(LJPullUpState)state {
    if(_state == state)
        return;
    
    LJPullUpState previousState = _state;
    _state = state;
    
   
    CGRect viewBounds = [self.indicator bounds];
    CGPoint origin = CGPointMake(roundf((self.bounds.size.width-viewBounds.size.width)/2), roundf((self.bounds.size.height-viewBounds.size.height)/2));
    [self.indicator setFrame:CGRectMake(origin.x, origin.y, viewBounds.size.width, viewBounds.size.height)];
    
    switch (state) {
        case LJPullUpStateStopped:
            [self.indicator stopAnimating];
            break;
            
        case LJPullUpStateTriggered:
            [self.indicator startAnimating];
            break;
            
        case LJPullUpStateLoading:
            [self.indicator startAnimating];
            break;
    }
    
    
    if(previousState == LJPullUpStateTriggered && state == LJPullUpStateLoading && self.handler)
        self.handler();

}

#pragma mark public control method
- (void)showIndicator {
    self.state = LJPullUpStateLoading;
}

- (void)hideIndicator {
    self.state = LJPullUpStateStopped;
}

@end
