//
//  RadiationTransition.m
//  Transition
//
//  Created by YLCHUN on 2019/3/22.
//  Copyright © 2019年 ylchun. All rights reserved.
//

#import "RadiationTransition.h"

@implementation RadiationTransition
@synthesize direction = _direction, type = _type;
- (instancetype)initWithTransitionType:(TransitionOperation)type direction:(RadiationDirection)direction {
    if (self = [super init]) {
        _type = type;
        _direction = direction;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 2.0f;
}

static double random_float(double min, double max) {
    return (double)arc4random() / 0x100000000 * (max - min) + min;
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

- (CGFloat)slicesWithRect:(CGRect)rect size:(NSUInteger)size {
    switch (_direction) {
        case RadiationDirectionVertical:
            return ceil(CGRectGetWidth(rect) / size);
        case RadiationDirectionHorizontal:
            return ceil(CGRectGetHeight(rect) / size);
    }
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *containerView = transitionContext.containerView;
    
    UIImage *fromViewSnapshot;
    switch (_type) {
        case TransitionOperationPush:
            fromViewSnapshot = getSnapshotImg(fromView, fromView.bounds);
            [containerView addSubview:toView];
            break;
        case TransitionOperationPop:
            fromViewSnapshot = getSnapshotImg(toView, toView.bounds);
            [containerView addSubview:fromView];
            break;
    }
    
    UIView *transitionContainer = [[UIView alloc] initWithFrame:containerView.bounds];
    [containerView addSubview:transitionContainer];
    
    CGFloat sliceSize = 3;
    NSUInteger slices;
    switch (_direction) {
        case RadiationDirectionVertical:
            slices = ceil(CGRectGetWidth(transitionContainer.frame) / sliceSize);
            break;
        case RadiationDirectionHorizontal:
            slices = ceil(CGRectGetHeight(transitionContainer.frame) / sliceSize);
            break;
    }
    
    __block NSUInteger sliceAnimationsPending = 0;
    NSTimeInterval transitionDuration = [self transitionDuration:transitionContext];

    for (int i = 0; i <= slices; i++) {
        bool direction = (i % 2 == 0);
        CGRect frame;
        CGAffineTransform transform;
        switch (_direction) {
            case RadiationDirectionVertical:{
                frame = CGRectMake(i*sliceSize, 0, sliceSize, CGRectGetHeight(fromView.bounds));
                CGFloat offset = CGRectGetHeight(frame);
                offset = direction ? -offset : offset;
                transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, offset);
            }break;
            case RadiationDirectionHorizontal:{
                frame = CGRectMake(0, i*sliceSize, CGRectGetWidth(fromView.bounds), sliceSize);
                CGFloat offset = CGRectGetWidth(frame);
                offset = direction ? -offset : offset;
                transform = CGAffineTransformTranslate(CGAffineTransformIdentity, offset, 0);
            }break;
        }
        
        CGAffineTransform transformA, transformB;
        switch (_type) {
            case TransitionOperationPush:
                transformA = CGAffineTransformIdentity;
                transformB = transform;
                break;
            case TransitionOperationPop:
                transformA = transform;
                transformB = CGAffineTransformIdentity;
                break;
        }
        
        UIView *view = squareView(fromViewSnapshot, frame);
        [transitionContainer addSubview:view];
        
        sliceAnimationsPending ++;
        view.transform = transformA;
        [UIView animateWithDuration:random_float(0.2, transitionDuration) animations:^{
            view.transform = transformB;
        } completion:^(BOOL finished) {
            if (--sliceAnimationsPending == 0) {
                [transitionContainer removeFromSuperview];
                [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
            }
        }];
    }
}

@end

