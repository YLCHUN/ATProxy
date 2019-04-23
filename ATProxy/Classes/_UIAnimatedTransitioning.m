//
//  _UIAnimatedTransitioning.m
//  ATProxy
//
//  Created by YLCHUN on 2018/7/15.
//  Copyright © 2018年 ylchun. All rights reserved.
//

#import "_UIAnimatedTransitioning.h"
#import <objc/runtime.h>

@implementation _UIAnimatedTransitioning {
    id <UIViewControllerAnimatedTransitioning> _transition;
    void(^_completion)(void);
}

- (instancetype)initWithTransition:(id <UIViewControllerAnimatedTransitioning>)transition completion:(void(^)(void))completion {
    _transition = transition;
    _completion = completion;
    return self;
}

#pragma mark proxy
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    return [(NSObject *)_transition methodSignatureForSelector:aSelector];
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    if (sel_isEqual(aSelector, @selector(animationEnded:))) {
        return YES;
    }
    return [_transition respondsToSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    if ([_transition respondsToSelector:invocation.selector]) {
        [invocation invokeWithTarget:_transition];
    }
    if (sel_isEqual(invocation.selector, @selector(animationEnded:))) {
        [self completion];
    }
}

-(void)completion {
    !_completion?:_completion();
    _completion = nil;
}

@end

