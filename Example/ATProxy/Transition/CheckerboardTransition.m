//
//  CheckerboardTransition.m
//  Transition
//
//  Created by YLCHUN on 2019/3/21.
//  Copyright © 2019年 ylchun. All rights reserved.
//

#import "CheckerboardTransition.h"

@implementation CheckerboardTransition
@synthesize type = _type;
- (instancetype)initWithTransitionType:(TransitionOperation)type {
    if (self = [super init]) {
        _type = type;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 3.0;
}

- (void)animateTransition:(nonnull id <UIViewControllerContextTransitioning>)transitionContext {
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *containerView = transitionContext.containerView;
    [containerView addSubview:toView];
    
    UIView *transitionContainer = getTransitionContainer(containerView.bounds);
    [containerView addSubview:transitionContainer];
    
    CGFloat sliceSize = round(CGRectGetWidth(transitionContainer.frame) / 10.f);
    NSUInteger xSlices = ceil(CGRectGetWidth(transitionContainer.frame) / sliceSize);
    NSUInteger ySlices = ceil(CGRectGetHeight(transitionContainer.frame) / sliceSize);
    CGVector transitionVector = getTransitionVector(transitionContainer.bounds, _type);
    CGFloat transitionVectorLen = getVectorLength(transitionVector);
    CGVector transitionVectorUnit = getVectorUnit(transitionVector);
    
    UIImage *fromViewSnapshot = getSnapshotImg(fromView, containerView.bounds);
    UIImage *toViewSnapshot = getSnapshotImg(toView, containerView.bounds);
    
    __block NSUInteger sliceAnimationsPending = 0;
    NSTimeInterval transitionDuration = [self transitionDuration:transitionContext];
    
    for (NSUInteger y = 0; y < ySlices; y++)
    {
        for (NSUInteger x = 0; x < xSlices; x++)
        {
            CGRect frame = CGRectMake(x * sliceSize, y * sliceSize, sliceSize, sliceSize);
            UIView* fromSquareView = squareView(fromViewSnapshot, frame);
            UIView* toSquareView = squareView(toViewSnapshot, frame);
            toSquareView.layer.transform = CATransform3DRotate(CATransform3DIdentity, M_PI, 0, 1, 0);
            fromSquareView.layer.transform = CATransform3DIdentity;
            [transitionContainer addSubview:toSquareView];
            [transitionContainer addSubview:fromSquareView];
            
            CGVector sliceOriginVector = getSliceOriginVector(frame, transitionContainer.bounds, _type);
            NSTimeInterval startTime = 0, duration = 0;
            transitionTime(transitionDuration, transitionVector, transitionVectorLen, transitionVectorUnit, sliceOriginVector, &startTime, &duration);
            
            sliceAnimationsPending++;
            [UIView animateWithDuration:duration delay:startTime options:0 animations:^{
                toSquareView.layer.transform = CATransform3DIdentity;
                fromSquareView.layer.transform = CATransform3DRotate(CATransform3DIdentity, M_PI, 0, 1, 0);
            } completion:^(BOOL finished) {
                if (--sliceAnimationsPending == 0) {
                    [transitionContainer removeFromSuperview];
                    [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
                }
            }];
        }
    }
}

static UIView *getTransitionContainer(CGRect frame) {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.opaque = YES;
    view.backgroundColor = UIColor.blackColor;
    CATransform3D t = CATransform3DIdentity;
    t.m34 = 1.0 / -900.0;
    view.layer.sublayerTransform = t;
    return view;
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

static void transitionTime(NSTimeInterval duration, CGVector vector, CGFloat vectorLength, CGVector vectorUnit, CGVector slice, NSTimeInterval *startTime, NSTimeInterval *durationUnit) {
    CGFloat dot = slice.dx * vector.dx + slice.dy * vector.dy;
    CGVector projection = CGVectorMake(vectorUnit.dx * dot / vectorLength,
                                       vectorUnit.dy * dot / vectorLength);
    
    // 计算投影的长度。
    CGFloat projectionLength = sqrtf( projection.dx * projection.dx + projection.dy * projection.dy );
    static const CGFloat transitionSpacing = 160.f;
    NSTimeInterval start = projectionLength / (vectorLength + transitionSpacing) * duration;
    NSTimeInterval time = ((projectionLength + transitionSpacing)/(vectorLength + transitionSpacing) * duration) - start;
    *startTime = start;
    *durationUnit = time;
}

static CGVector getTransitionVector(CGRect rect, TransitionOperation type) {
    switch (type) {
        case TransitionOperationPush:
            return CGVectorMake(CGRectGetMaxX(rect) - CGRectGetMinX(rect),
                                            CGRectGetMaxY(rect) - CGRectGetMinY(rect));
            break;
        case TransitionOperationPop:
            return CGVectorMake(CGRectGetMinX(rect) - CGRectGetMaxX(rect),
                                            CGRectGetMinY(rect) - CGRectGetMaxY(rect));
            break;
    }
}

static CGVector getSliceOriginVector(CGRect insider, CGRect rect, TransitionOperation type) {
    switch (type) {
        case TransitionOperationPush:
            return CGVectorMake(CGRectGetMinX(insider) - CGRectGetMinX(rect),
                                CGRectGetMinY(insider) - CGRectGetMinY(rect));
            break;
        case TransitionOperationPop:
            return CGVectorMake(CGRectGetMaxX(insider) - CGRectGetMaxX(rect),
                                CGRectGetMaxY(insider) - CGRectGetMaxY(rect));
            break;
    }
}

static CGFloat getVectorLength(CGVector vector) {
    return sqrtf(vector.dx * vector.dx + vector.dy * vector.dy);
}

static CGVector getVectorUnit(CGVector vector) {
    CGFloat vlen = getVectorLength(vector);
    return CGVectorMake(vector.dx / vlen, vector.dy / vlen);
}

@end
