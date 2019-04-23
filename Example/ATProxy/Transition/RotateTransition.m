//
//  RotateTransition.m
//  Transition
//
//  Created by YLCHUN on 2019/3/13.
//  Copyright © 2019年 ylchun. All rights reserved.
//

#import "RotateTransition.h"

@implementation RotateTransition
@synthesize type = _type;
- (instancetype)initWithTransitionType:(TransitionOperation)type {
    if (self = [super init]) {
        _type = type;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return 1;
}

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    switch (_type) {
        case TransitionOperationPush:
            [self doPushAnimation:transitionContext];
            break;
        case TransitionOperationPop:
            [self doPopAnimation:transitionContext];
            break;
    }
}

- (void)doPushAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];

    [transitionContext.containerView addSubview:fromView];
    [transitionContext.containerView addSubview:toView];
    
    toView.layer.anchorPoint = CGPointMake(0.5, 1.5);
    toView.layer.position = CGPointMake(CGRectGetWidth(toView.bounds) * 0.5, CGRectGetHeight(toView.bounds) * 1.5);
    toView.transform = rotateTransform();
    
    toView.alpha = 0;
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        toView.alpha = 1;
        toView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        toView.layer.anchorPoint = CGPointMake(0.5, 0.5);
        toView.layer.position = CGPointMake(CGRectGetMidX(toView.bounds), CGRectGetMidY(toView.bounds));
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}

- (void)doPopAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    [transitionContext.containerView addSubview:toView];
    [transitionContext.containerView addSubview:fromView];
    
    fromView.layer.anchorPoint = CGPointMake(0.5, 1.5);
    fromView.layer.position = CGPointMake(CGRectGetWidth(fromView.bounds) * 0.5, CGRectGetHeight(fromView.bounds) * 1.5);
    
    fromView.alpha = 1;
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromView.transform = rotateTransform();
        fromView.alpha = 0;
    } completion:^(BOOL finished) {
        fromView.alpha = 1;
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}

static CGAffineTransform rotateTransform() {
    return CGAffineTransformRotate(CGAffineTransformIdentity, M_PI_4);
}

@end
