//
//  PageTransition.m
//  Transition
//
//  Created by YLCHUN on 2019/3/25.
//  Copyright © 2019年 ylchun. All rights reserved.
//

#import "PageTransition.h"

@implementation PageTransition
@synthesize type = _type;
- (instancetype)initWithTransitionType:(TransitionOperation)type{
    self = [super init];
    if (self) {
        _type = type;
    }
    return self;
}


- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 2.0f;
}

//TODO: 动画过程中中间黑线
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *containerView = transitionContext.containerView;
    [containerView addSubview:toView];
    
    UIImage *fromViewSnapshot = getSnapshotImg(fromView, containerView.bounds);
    UIImage *toViewSnapshot = getSnapshotImg(toView, containerView.bounds);
    
    CGRect lFrame = CGRectMake(0, 0, CGRectGetMidX(containerView.bounds), CGRectGetHeight(containerView.bounds));
    CGRect rFrame = CGRectMake(CGRectGetMidX(containerView.bounds), 0, CGRectGetMidX(containerView.bounds), CGRectGetHeight(containerView.bounds));
    
    UIView * fl = squareView(fromViewSnapshot, lFrame);
    UIView * fr = squareView(fromViewSnapshot, rFrame);
    UIView * tl = squareView(toViewSnapshot, lFrame);
    UIView * tr = squareView(toViewSnapshot, rFrame);
    
    UIView *transitionContainer = getTransitionContainer(containerView.bounds);
    [containerView addSubview:transitionContainer];
    
    CATransform3D tA0, tA1, tB0, tB1;
    UIView *viewA, *viewB;
    CGPoint anchorA, anchorB;
    switch (_type) {
        case TransitionOperationPush:
            tA0 = CATransform3DIdentity;
            tA1 = CATransform3DRotate(CATransform3DIdentity, -M_PI_2, 0, 1, 0);
            tB0 = CATransform3DRotate(CATransform3DIdentity, M_PI_2, 0, 1, 0);
            tB1 = CATransform3DIdentity;
            viewA = fr;
            viewB = tl;
            anchorA = CGPointMake(0, 0.5);
            anchorB = CGPointMake(1, 0.5);
            
            [transitionContainer addSubview:tr];
            [transitionContainer addSubview:fr];
            [transitionContainer addSubview:fl];
            [transitionContainer addSubview:tl];
            break;
        case TransitionOperationPop:
            tA0 = CATransform3DIdentity;
            tA1 = CATransform3DRotate(CATransform3DIdentity, M_PI_2, 0, 1, 0);
            tB0 = CATransform3DRotate(CATransform3DIdentity, -M_PI_2, 0, 1, 0);
            tB1 = CATransform3DIdentity;
            viewA = fl;
            viewB = tr;
            anchorA = CGPointMake(1, 0.5);
            anchorB = CGPointMake(0, 0.5);
            
            [transitionContainer addSubview:tl];
            [transitionContainer addSubview:fr];
            [transitionContainer addSubview:fl];
            [transitionContainer addSubview:tr];
            break;
    }
    setAnchorPoint(viewA, anchorA);
    setAnchorPoint(viewB, anchorB);
    
    viewA.layer.transform = tA0;
    viewB.layer.transform = tB0;

    [UIView animateKeyframesWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.5 animations:^{
            viewA.layer.transform = tA1;
        }];
        [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:0.5 animations:^{
            viewB.layer.transform = tB1;
        }];
    } completion:^(BOOL finished) {
        [transitionContainer removeFromSuperview];
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

static UIImage *getSnapshotImg(UIView * view, CGRect bounds) {
    [view layoutIfNeeded];
    UIGraphicsBeginImageContextWithOptions(bounds.size, YES, UIScreen.mainScreen.scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

static UIView* squareView(UIImage *image, CGRect frame) {
    UIView *squareView = [UIView new];
    squareView.frame = frame;
    squareView.opaque = NO;
    squareView.layer.masksToBounds = YES;
    squareView.layer.doubleSided = NO;
    
    frame.origin.x = -frame.origin.x;
    frame.origin.y = -frame.origin.y;
    frame.size = image.size;
    
    CALayer *layer = [CALayer new];
    layer.frame = frame;
    layer.rasterizationScale = image.scale;
    layer.contents = (__bridge id)image.CGImage;
    
    [squareView.layer addSublayer:layer];
    return squareView;
}

static UIView *getTransitionContainer(CGRect frame) {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.opaque = YES;
    CATransform3D t = CATransform3DIdentity;
    t.m34 = 1.0 / -500.0;
    view.layer.sublayerTransform = t;
    return view;
}

static void setAnchorPoint(UIView *view, CGPoint point) {
    view.frame = CGRectOffset(view.frame, (point.x - view.layer.anchorPoint.x) * view.frame.size.width, (point.y - view.layer.anchorPoint.y) * view.frame.size.height);
    view.layer.anchorPoint = point;
}

@end
