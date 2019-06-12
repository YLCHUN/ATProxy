//
//  BrokenTransition.m
//  Transition
//
//  Created by YLCHUN on 2019/3/25.
//  Copyright © 2019年 ylchun. All rights reserved.
//

#import "BrokenTransition.h"

@implementation BrokenTransition
{
    UIDynamicAnimator * _dynamicAnimator;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 2.0f;
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

static UIDynamicBehavior *getItemDynamicBehavior(id<UIDynamicItem> item) {
    UIDynamicBehavior *dynamicBehavior = [[UIDynamicBehavior alloc] init];
    UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc] init];
    gravityBehavior.magnitude = 2.5;
    [gravityBehavior addItem:item];
    
    UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] init];
    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    collisionBehavior.collisionMode = UICollisionBehaviorModeBoundaries;
    [collisionBehavior addItem:item];
    
    UIDynamicItemBehavior *dynamicItemBehavior = [[UIDynamicItemBehavior alloc] init];
    dynamicItemBehavior.elasticity = (rand() % 5) / 8.0;
    dynamicItemBehavior.density = (rand() % 5 / 3.0);
    [dynamicItemBehavior addItem:item];
    
    [dynamicBehavior addChildBehavior:gravityBehavior];
    [dynamicBehavior addChildBehavior:collisionBehavior];
    [dynamicBehavior addChildBehavior:dynamicItemBehavior];
    return dynamicBehavior;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *containerView = transitionContext.containerView;
    [containerView addSubview:fromView];
    [containerView addSubview:toView];
    
    UIView *transitionContainer = [[UIView alloc] initWithFrame:containerView.bounds];
    [containerView addSubview:transitionContainer];
    
    UIImage *fromViewSnapshot = getSnapshotImg(fromView, containerView.bounds);
    
    CGFloat sliceSize = round(CGRectGetWidth(transitionContainer.frame) / 5.f);
    CGFloat xSlices = ceil(CGRectGetWidth(containerView.bounds) / sliceSize);
    CGFloat ySlices = ceil(CGRectGetHeight(containerView.bounds) / sliceSize);
    
    _dynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:transitionContainer];
    __block NSUInteger sliceAnimationsPending = 0;
    for (NSUInteger y = 0; y < ySlices; y++)
    {
        for (NSUInteger x = 0; x < xSlices; x++)
        {
            sliceAnimationsPending ++;
            
            CGRect frame = CGRectMake(x * sliceSize, y * sliceSize, sliceSize, sliceSize);
            UIView* view = squareView(fromViewSnapshot, frame);
            CGFloat angle = (sliceAnimationsPending % 2 ? 1 : -1) * (rand() % 5 / 10.0);
            [transitionContainer addSubview:view];
            
            [_dynamicAnimator addBehavior:getItemDynamicBehavior(view)];
            
            [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
                view.alpha = 0;
                view.transform = CGAffineTransformRotate(CGAffineTransformIdentity, angle);
            } completion:^(BOOL finished) {
                if (--sliceAnimationsPending == 0) {
                    [transitionContainer removeFromSuperview];
                    [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
                }
            }];
        }
    }
}

@end
