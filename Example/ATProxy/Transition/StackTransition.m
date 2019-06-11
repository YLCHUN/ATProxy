//
//  StackTransition.m
//  Transition
//
//  Created by YLCHUN on 2019/3/13.
//  Copyright © 2019年 ylchun. All rights reserved.
//

#import "StackTransition.h"

@implementation StackTransition
@synthesize type = _type;

- (instancetype)initWithTransitionType:(TransitionOperation)type {
    if (self = [super init]) {
        _type = type;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 1;
}

- (void)animateTransition:(nonnull id <UIViewControllerContextTransitioning>)transitionContext {
    switch (_type) {
        case TransitionOperationPush:
            [self doPushAnimation:transitionContext];
            break;
        case TransitionOperationPop:
            [self doPopAnimation:transitionContext];
            break;
    }
}

- (BOOL)makeScale {
    return YES;
}


- (void)doPushAnimation:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];

    [transitionContext.containerView addSubview:fromView];
    [transitionContext.containerView addSubview:toView];
    
    toView.transform = translationTransform(CGRectGetWidth(fromView.bounds));
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        toView.transform = CGAffineTransformIdentity;
        if ([self makeScale])
            fromView.transform = scaleTransform();
    } completion:^(BOOL finished) {
        if ([self makeScale])
            fromView.transform = CGAffineTransformIdentity;
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}

- (void)doPopAnimation:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    [transitionContext.containerView addSubview:toView];
    [transitionContext.containerView addSubview:fromView];
    
    if ([self makeScale])
        toView.transform = scaleTransform();
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromView.transform = translationTransform(CGRectGetWidth(fromView.bounds));
        if ([self makeScale])
            toView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        fromView.transform = CGAffineTransformIdentity;
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}

static CGAffineTransform scaleTransform() {
    return CGAffineTransformScale(CGAffineTransformIdentity, 0.95, 0.95);
}

static CGAffineTransform translationTransform(double offset) {
    return CGAffineTransformConcat(CGAffineTransformIdentity, CGAffineTransformMakeTranslation(offset, 0));
}
@end


