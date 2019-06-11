//
//  OvalMaskTransition.m
//  Transition
//
//  Created by YLCHUN on 2018/7/10.
//  Copyright © 2018年 YLCHUN. All rights reserved.
//

#import "OvalMaskTransition.h"

@interface OvalMaskTransition ()<CAAnimationDelegate>
@end

@implementation OvalMaskTransition {
    id<UIViewControllerContextTransitioning> _transitionContext;
    CGPoint _anchor;
    UIView *_maskView;
}

@synthesize type = _type;
- (instancetype)initWithTransitionType:(TransitionOperation)type anchor:(CGPoint)anchor {
    if (self = [super init]) {
        _type = type;
        _anchor = anchor;
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
        default:
            break;
    }
}

- (void)doPushAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    [transitionContext.containerView addSubview:fromView];
    [transitionContext.containerView addSubview:toView];
    
    _maskView = toView;
    CAShapeLayer *layer  = [CAShapeLayer layer];
    toView.layer.mask = layer;
    ovalTransition(_anchor, toView.bounds, ^(CGPathRef min, CGPathRef max) {
        layer.path = min;
        double duration = [self transitionDuration:transitionContext];
        CABasicAnimation *animation = pathAnimation(min, max, duration, self);
        [layer addAnimation:animation forKey:@"spread"];
    });
}

- (void)doPopAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    [transitionContext.containerView addSubview:toView];
    [transitionContext.containerView addSubview:fromView];
    
    _maskView = fromView;
    CAShapeLayer *layer = [CAShapeLayer layer];
    fromView.layer.mask = layer;
    ovalTransition(_anchor, fromView.bounds, ^(CGPathRef min, CGPathRef max) {
        layer.path = max;
        double duration = [self transitionDuration:transitionContext];
        CABasicAnimation *animation = pathAnimation(max, min, duration, self);
        [layer addAnimation:animation forKey:@"spread"];
    });
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    _maskView.layer.mask = nil;
    [_transitionContext completeTransition:!_transitionContext.transitionWasCancelled];
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
//    CGRect minRect = CGRectZero;
//    minRect.origin = origin;
//    CGRect maxRect = CGRectInset(minRect, -radius, -radius);
//    UIBezierPath *minPath = [UIBezierPath bezierPathWithOvalInRect:minRect];
//    UIBezierPath *maxPath = [UIBezierPath bezierPathWithOvalInRect:maxRect];
    
    UIBezierPath *minPath = [UIBezierPath bezierPathWithArcCenter:origin radius:0.1 startAngle:0 endAngle:2 * M_PI clockwise:NO];
    UIBezierPath *maxPath = [UIBezierPath bezierPathWithArcCenter:origin radius:radius startAngle:0 endAngle:2 * M_PI clockwise:NO];
    
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


+ (instancetype)alloc {
    NSLog(@"%s", __func__);
    return [super alloc];
}
- (void)dealloc {
    NSLog(@"%s", __func__);
}

@end


