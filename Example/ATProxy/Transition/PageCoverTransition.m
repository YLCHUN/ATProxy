//
//  PageCoverTransition.m
//  Transition
//
//  Created by YLCHUN on 2018/7/14.
//  Copyright © 2018年 ylchun. All rights reserved.
//

#import "PageCoverTransition.h"

//@implementation UIView (anchorPoint)
//- (void)setAnchorPointTo:(CGPoint)point{
//    self.frame = CGRectOffset(self.frame, (point.x - self.layer.anchorPoint.x) * self.frame.size.width, (point.y - self.layer.anchorPoint.y) * self.frame.size.height);
//    self.layer.anchorPoint = point;
//}
//@end

@implementation PageCoverTransition
@synthesize type = _type;

+ (instancetype)transitionWithType:(TransitionOperation)type{
    return [[self alloc] initWithTransitionType:type];
}

- (instancetype)initWithTransitionType:(TransitionOperation)type{
    self = [super init];
    if (self) {
        _type = type;
    }
    return self;
}
/**
 *  动画时长
 */
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 1;
}
/**
 *  如何执行过渡动画
 */
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    switch (_type) {
        case TransitionOperationPush:
            [self doPushAnimation:transitionContext];
            break;
        case TransitionOperationPop:
            [self doPopAnimation:transitionContext];
            break;
    }
}

- (UIView *)shadowView:(CGRect)bounds {
    UIView *view = [[UIView alloc] initWithFrame:bounds];
    view.backgroundColor = [UIColor clearColor];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(id)[UIColor blackColor].CGColor,
                            (id)[UIColor lightGrayColor].CGColor];
    gradientLayer.startPoint = CGPointMake(0.0, 0.5);
    gradientLayer.endPoint = CGPointMake(1.0, 0.5);
    gradientLayer.anchorPoint = CGPointMake(0.8, 0.5);
    gradientLayer.frame = view.bounds;
    
    [view.layer addSublayer:gradientLayer];
    return view;
}
/**
 *  执行push过渡动画
 */
- (void)doPushAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:fromView];
    [containerView addSubview:toView];
    
    CATransform3D transfrom3d = CATransform3DIdentity;
    transfrom3d.m34 = -0.002;
    containerView.layer.sublayerTransform = transfrom3d;
    
    UIView *snapshotView = [fromView snapshotViewAfterScreenUpdates:NO];
    setAnchorPoint(snapshotView, CGPointMake(0, 0.5));
    snapshotView.frame = fromView.frame;
    
    [containerView addSubview:snapshotView];
    
    //增加阴影
    UIView *fShadowView = [self shadowView:fromView.bounds];
    UIView *tShadowView = [self shadowView:toView.bounds];
    [snapshotView addSubview:fShadowView];
    [toView addSubview:tShadowView];
    
    fShadowView.alpha = 0.0;
    tShadowView.alpha = 1.0;
    fromView.hidden = YES;
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        snapshotView.layer.transform = CATransform3DRotate(CATransform3DIdentity, -M_PI_2, 0, 1, 0);
        fShadowView.alpha = 1.0;
        tShadowView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        fromView.hidden = NO;
        [snapshotView removeFromSuperview];
        [tShadowView removeFromSuperview];
    }];
}
/**
 *  执行pop过渡动画
 */
- (void)doPopAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toView];
    [containerView addSubview:fromView];
    
    CATransform3D transfrom3d = CATransform3DIdentity;
    transfrom3d.m34 = -0.002;
    containerView.layer.sublayerTransform = transfrom3d;
    
    UIView *snapshotView = [toView snapshotViewAfterScreenUpdates:NO];
    snapshotView.frame = toView.frame;
    setAnchorPoint(snapshotView, CGPointMake(0, 0.5));
    
    [containerView addSubview:snapshotView];
    
    UIView *fShadowView = [self shadowView:fromView.bounds];
    UIView *tShadowView = [self shadowView:toView.bounds];
    [fromView addSubview:fShadowView];
    [snapshotView addSubview:tShadowView];
    
    fShadowView.alpha = 0.0;
    tShadowView.alpha = 1.0;
    toView.hidden = YES;
    snapshotView.layer.transform = CATransform3DRotate(CATransform3DIdentity, -M_PI_2, 0, 1, 0);
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        snapshotView.layer.transform = CATransform3DIdentity;
        fShadowView.alpha = 1.0;
        tShadowView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        toView.hidden = NO;
        [snapshotView removeFromSuperview];
        [fShadowView removeFromSuperview];
    }];
}

static void setAnchorPoint(UIView *view, CGPoint point) {
    view.frame = CGRectOffset(view.frame, (point.x - view.layer.anchorPoint.x) * view.frame.size.width, (point.y - view.layer.anchorPoint.y) * view.frame.size.height);
    view.layer.anchorPoint = point;
}


+ (instancetype)alloc {
    NSLog(@"%s", __func__);
    return [super alloc];
}
- (void)dealloc {
    NSLog(@"____ %s", __func__);
}
@end
