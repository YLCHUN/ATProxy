//
//  ViewTransition.m
//  Transition
//
//  Created by YLCHUN on 2019/3/16.
//  Copyright © 2019 ylchun. All rights reserved.
//

#import "ViewTransition.h"

@interface ViewTransition ()<CAAnimationDelegate>
@end

@implementation ViewTransition
{
    id<UIViewControllerContextTransitioning> _transitionContext;
    UIView *_maskView;
    UIView *_snapshotView;
}
@synthesize type = _type;

- (instancetype)initWithTransitionType:(TransitionOperation)type {
    if (self = [super init]) {
        _type = type;
    }
    return self;
}


- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 1;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    _transitionContext = transitionContext;
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
    UIView *view = [[UIView alloc] initWithFrame:transitionContext.containerView.bounds];
    [fromView layoutIfNeeded];
    [toView layoutIfNeeded];
    
    view.backgroundColor = [UIColor whiteColor];
    [transitionContext.containerView addSubview:fromView];
    [transitionContext.containerView addSubview:toView];
    [transitionContext.containerView addSubview:view];

    UIView *snapshotView = [self.from snapshotViewAfterScreenUpdates:NO];
    snapshotView.center = self.from.center;
    [view addSubview:snapshotView];
    
    _maskView = view;
    _snapshotView = snapshotView;
    [UIView animateWithDuration:[self transitionDuration:transitionContext]/2.0 animations:^{
        snapshotView.center = self.to.center;
    } completion:^(BOOL finished) {
        CAShapeLayer *layer  = [CAShapeLayer layer];
        view.layer.mask = layer;
        ovalTransition(snapshotView.center, view.bounds, ^(CGPathRef min, CGPathRef max) {
            layer.path = min;
            double duration = [self transitionDuration:transitionContext]/2.0;
            CABasicAnimation *animation = pathAnimation(min, max, duration, self);
            [layer addAnimation:animation forKey:@"spread"];
        });
    }];
}

- (void)doPopAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *view = [[UIView alloc] initWithFrame:transitionContext.containerView.bounds];
    [fromView layoutIfNeeded];
    [toView layoutIfNeeded];
    
    view.backgroundColor = [UIColor whiteColor];
    [transitionContext.containerView addSubview:toView];
    [transitionContext.containerView addSubview:fromView];
    [transitionContext.containerView addSubview:view];
    
    UIView *snapshotView = [self.from snapshotViewAfterScreenUpdates:NO];
    snapshotView.center = self.from.center;
    [view addSubview:snapshotView];
    
    _maskView = view;
    _snapshotView = snapshotView;
    CAShapeLayer *layer  = [CAShapeLayer layer];
    view.layer.mask = layer;
    ovalTransition(snapshotView.center, view.bounds, ^(CGPathRef min, CGPathRef max) {
        layer.path = max;
        double duration = [self transitionDuration:transitionContext]/2.0;
        CABasicAnimation *animation = pathAnimation(max, min, duration, self);
        [layer addAnimation:animation forKey:@"spread"];
    });
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    switch (_type) {
        case TransitionOperationPush:
            [self pushOvalAnimationDidStop:anim finished:flag];
            break;
        case TransitionOperationPop:
            [self popOvalAnimationDidStop:anim finished:flag];
            break;
    }
}

- (void)animationDidStop {
    [_maskView removeFromSuperview];
    [_transitionContext completeTransition:!_transitionContext.transitionWasCancelled];
}

- (void)pushOvalAnimationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {
        [self animationDidStop];
    }else {
        [UIView animateWithDuration:[self transitionDuration:_transitionContext]/2.0 animations:^{
            self->_snapshotView.center = self.from.center;
        } completion:^(BOOL finished) {
            [self animationDidStop];
        }];
    }
}

- (void)popOvalAnimationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {
        [UIView animateWithDuration:[self transitionDuration:_transitionContext]/2.0 animations:^{
            self->_snapshotView.center = self.to.center;
        } completion:^(BOOL finished) {
            [self animationDidStop];
        }];
    }else {
        [self animationDidStop];
    }
}

static CGFloat getRadius(CGRect rect, CGPoint point) {
    CGFloat x, y;
    if (point.x > CGRectGetMidX(rect)) {
        x = point.x - CGRectGetMinX(rect);
    }else {
        x = point.x - CGRectGetMaxX(rect);
    }
    if (point.y > CGRectGetMidY(rect)) {
        y = point.y - CGRectGetMinY(rect);
    }else {
        y = point.y - CGRectGetMaxY(rect);
    }
    return sqrt(x * x + y * y);
}

static void ovalTransition(CGPoint origin, CGRect inRect, void(^callback)(CGPathRef min, CGPathRef max)) {
    if (!callback) return;
    CGFloat radius = getRadius(inRect, origin);
    UIBezierPath *minPath = [UIBezierPath bezierPathWithRect:inRect];
    [minPath appendPath:[UIBezierPath bezierPathWithArcCenter:origin radius:0.1 startAngle:0 endAngle:2 * M_PI clockwise:NO]];
    UIBezierPath *maxPath = [UIBezierPath bezierPathWithRect:inRect];
    [maxPath appendPath:[UIBezierPath bezierPathWithArcCenter:origin radius:radius startAngle:0 endAngle:2 * M_PI clockwise:NO]];
    callback(minPath.CGPath, maxPath.CGPath);
}

static CABasicAnimation* pathAnimation(CGPathRef from, CGPathRef to, CFTimeInterval duration, id<CAAnimationDelegate> delegate) {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.fromValue = (__bridge id)(from);
    animation.toValue = (__bridge id)(to);
    animation.duration = duration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.delegate = delegate;
    return animation;
}
@end
