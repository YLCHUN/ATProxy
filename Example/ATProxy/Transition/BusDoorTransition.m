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

- (void)doPushAnimation:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    [transitionContext.containerView addSubview:fromView];
    [transitionContext.containerView addSubview:toView];
    
    UIView *snapshotView = [toView snapshotViewAfterScreenUpdates:YES];
    [transitionContext.containerView addSubview:snapshotView];
    
    snapshotView.layer.anchorPoint = CGPointMake(0, 0.5);
    snapshotView.layer.position = CGPointMake(CGRectGetWidth(toView.bounds), CGRectGetMidY(toView.bounds));
    snapshotView.layer.transform = rotateTransform();
    
    toView.hidden = true;
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        snapshotView.layer.transform = CATransform3DIdentity;
        snapshotView.layer.position = CGPointMake(0, CGRectGetMidY(toView.bounds));
    } completion:^(BOOL finished) {
        toView.hidden = false;
        [snapshotView removeFromSuperview];
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}

- (void)doPopAnimation:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    [transitionContext.containerView addSubview:toView];
    [transitionContext.containerView addSubview:fromView];
    
    UIView *snapshotView = [fromView snapshotViewAfterScreenUpdates:YES];
    [transitionContext.containerView addSubview:snapshotView];
    
    snapshotView.layer.anchorPoint = CGPointMake(0, 0.5);
    snapshotView.layer.position = CGPointMake(0, CGRectGetMidY(fromView.bounds));
    
    fromView.hidden = true;
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        snapshotView.layer.position = CGPointMake(CGRectGetWidth(fromView.bounds), CGRectGetMidY(fromView.bounds));
        snapshotView.layer.transform = rotateTransform();
    } completion:^(BOOL finished) {
        fromView.hidden = false;
        [snapshotView removeFromSuperview];
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}

static CATransform3D rotateTransform() {
    CATransform3D transform = CATransform3DRotate(CATransform3DIdentity, -M_PI_2, 0, 1, 0);
    transform.m34 = -1.0 / 500.0;
    return transform;
}

@end
