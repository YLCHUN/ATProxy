//
//  TierTransition.m
//  Transition
//
//  Created by YLCHUN on 2019/3/13.
//  Copyright © 2019年 ylchun. All rights reserved.
//

#import "BusDoorTransition.h"

@implementation BusDoorTransition
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
    
    toView.layer.anchorPoint = CGPointMake(0, 0.5);
    toView.layer.position = CGPointMake(CGRectGetWidth(toView.bounds), CGRectGetMidY(toView.bounds));
    toView.layer.transform = rotateTransform();
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        toView.layer.transform = CATransform3DIdentity;
        toView.layer.position = CGPointMake(0, CGRectGetMidY(toView.bounds));
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}

- (void)doPopAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    [transitionContext.containerView addSubview:toView];
    [transitionContext.containerView addSubview:fromView];
    
    fromView.layer.anchorPoint = CGPointMake(0, 0.5);
    fromView.layer.position = CGPointMake(0, CGRectGetMidY(fromView.bounds));
    fromView.layer.transform = CATransform3DIdentity;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromView.layer.position = CGPointMake(CGRectGetWidth(fromView.bounds), CGRectGetMidY(fromView.bounds));
        fromView.layer.transform = rotateTransform();
    } completion:^(BOOL finished) {
        fromView.layer.transform = CATransform3DIdentity;
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}

static CATransform3D rotateTransform() {
    CATransform3D transform = CATransform3DRotate(CATransform3DIdentity, -M_PI_2, 0, 1, 0);
    transform.m34 = -1.0 / 500.0;
    return transform;
}

@end
