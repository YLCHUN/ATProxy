//
//  RRTransition.m
//  Transition
//
//  Created by YLCHUN on 2019/3/23.
//  Copyright © 2019 ylchun. All rights reserved.
//

#import "RRTransition.h"

@implementation RRTransition
@synthesize type = _type;
- (instancetype)initWithTransitionType:(TransitionOperation)type {
    if (self = [super init]) {
        _type = type;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 3.0;
}

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *containerView = transitionContext.containerView;
    
    UIImage *fromViewSnapshot;
    __block NSTimeInterval startTime;
    double alphaA, alphaB;
    switch (_type) {
        case TransitionOperationPush:
            [containerView addSubview:toView];
            fromViewSnapshot = getSnapshotImg(fromView, containerView.bounds);
            startTime = 0;
            alphaA = 1;
            alphaB = 0;
            break;
        case TransitionOperationPop:
            [containerView addSubview:fromView];
            fromViewSnapshot = getSnapshotImg(toView, containerView.bounds);
            startTime = [self transitionDuration:transitionContext];
            alphaA = 0;
            alphaB = 1;
            break;
    }
    UIView *transitionContainer = [[UIView alloc] initWithFrame:containerView.bounds];
    [containerView addSubview:transitionContainer];
    
    NSUInteger count = 20;
    CGFloat xLen = CGRectGetWidth(containerView.bounds) / count;
    CGFloat yLen = CGRectGetHeight(containerView.bounds) / count;
    for (NSUInteger y = 0; y < count; y++)
    {
        for (NSUInteger x = 0; x < count; x++)
        {
            CGRect frame = CGRectMake(x * xLen, y * yLen, xLen, yLen);
            UIView* view = squareView(fromViewSnapshot, frame);
            [transitionContainer addSubview:view];
        }
    }
    NSTimeInterval duration = [self transitionDuration:transitionContext] / count / count;
    __block NSUInteger sliceAnimationsPending = 0;
    traverse(count, count, ^(NSUInteger x, NSUInteger y) {
        NSUInteger idx = y * count + x;
        UIView *squareView = transitionContainer.subviews[idx];
        sliceAnimationsPending++;
        squareView.alpha = alphaA;
        [UIView animateWithDuration:duration delay:startTime options:0 animations:^{
            squareView.alpha = alphaB;
        } completion:^(BOOL finished) {
            if (--sliceAnimationsPending == 0) {
                [transitionContainer removeFromSuperview];
                [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
            }
        }];
        
        switch (self->_type) {
            case TransitionOperationPush:
                startTime += duration;
                break;
            case TransitionOperationPop:
                startTime -= duration;
                break;
        }
    });
}

static void traverse(NSUInteger xCount, NSUInteger yCount, void(^index)(NSUInteger x, NSUInteger y)) {
    NSInteger x0 = 0, x1 = xCount, y0 = 0, y1 = yCount;
    NSInteger x = 0, y = 0;
    while (x0 != x1 || y0 != y1) {
        for (NSUInteger i = x0; i < x1; i++) {
            x = i;
            index(x, y);
        }
        y0++;
        for (NSUInteger i = y0; i < y1; i++) {
            y = i;
            index(x, y);
        }
        x1--;
        for (NSInteger i = x1-1; i >= x0; i--) {
            x = i;
            index(x, y);
        }
        y1--;
        for (NSInteger i = y1-1; i >= y0 ; i--) {
            y = i;
            index(x, y);
        }
        x0++;
    }
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

@end
