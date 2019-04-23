//
//  ATProxy.m
//  ATProxy
//
//  Created by YLCHUN on 2018/7/13.
//  Copyright © 2018年 YLCHUN. All rights reserved.
//

#import "_UIViewControllerTransition.h"
#import "_UIAnimatedTransitioning.h"
#import "_UIInteractiveTransition.h"
#import <objc/runtime.h>

#pragma mark - _UIViewControllerTransition
@interface _UIViewControllerTransition() <UINavigationControllerDelegate, UITabBarControllerDelegate, UIViewControllerTransitioningDelegate>
@end

@implementation _UIViewControllerTransition {
    _UIAnimatedTransitioning *_transition;
    _UIInteractiveTransition *_interaction;
    void(^_completion)(void);
    id _delegate;
}

+ (void)setupTransition:(id <UIViewControllerAnimatedTransitioning>)transition delegate:(id)delegate reset:(void(^)(id delegate))reset {
    if (!transition) return;
    if (delegate && object_getClass(delegate) == [_UIViewControllerTransition class]) {
        [(_UIViewControllerTransition *)delegate completion];
    }
    _UIInteractiveTransition *interaction = [_UIInteractiveTransition takeAwayCurrent];
    __block _UIViewControllerTransition *t = [[self alloc] initWithTransition:transition interaction:interaction delegate:delegate completion:^{
        t = nil;
        reset(delegate);
    }];
    reset(t);
}

- (instancetype)initWithTransition:(id <UIViewControllerAnimatedTransitioning>)transition interaction:(id<UIViewControllerInteractiveTransitioning>)interaction delegate:(id)delegate completion:(void(^)(void))completion {
    _delegate = delegate;
    _completion = completion;
    __weak typeof(self) wself = self;
    _interaction = interaction;
    _transition = [[_UIAnimatedTransitioning alloc] initWithTransition:transition completion:^{
        [wself completion];
    }];
    return self;
}

-(void)completion {
    !_completion?:_completion();
    _completion = nil;
}

#pragma mark proxy
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    return [(NSObject *)_delegate methodSignatureForSelector:aSelector];
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    if (sel_isEqual(aSelector, @selector(navigationController:animationControllerForOperation:fromViewController:toViewController:))) {
        return YES;
    }
    if (sel_isEqual(aSelector, @selector(navigationController:interactionControllerForAnimationController:))) {
        return YES;
    }
    
    if (sel_isEqual(aSelector, @selector(tabBarController:animationControllerForTransitionFromViewController:toViewController:))) {
        return YES;
    }
    if (sel_isEqual(aSelector, @selector(tabBarController:interactionControllerForAnimationController:))) {
        return YES;
    }

    if (sel_isEqual(aSelector, @selector(animationControllerForPresentedController:presentingController:sourceController:))) {
        return YES;
    }
    if (sel_isEqual(aSelector, @selector(animationControllerForDismissedController:))) {
        return YES;
    }
    if (sel_isEqual(aSelector, @selector(interactionControllerForPresentation:))) {
        return YES;
    }
    if (sel_isEqual(aSelector, @selector(interactionControllerForDismissal:))) {
        return YES;
    }
    return [_delegate respondsToSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    if ([_delegate respondsToSelector:invocation.selector]) {
        [invocation invokeWithTarget:_delegate];
    }
}

#pragma mark delegate
- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC {
    return (id <UIViewControllerAnimatedTransitioning>)_transition;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                                   interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController {
    return _interaction;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)tabBarController:(UITabBarController *)tabBarController
                     animationControllerForTransitionFromViewController:(UIViewController *)fromVC
                                                       toViewController:(UIViewController *)toVC {
    return (id <UIViewControllerAnimatedTransitioning>)_transition;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)tabBarController:(UITabBarController *)tabBarController
                               interactionControllerForAnimationController: (id <UIViewControllerAnimatedTransitioning>)animationController {
    return _interaction;
}

-(nullable id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return (id <UIViewControllerAnimatedTransitioning>)_transition;
}

- (nullable id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return (id <UIViewControllerAnimatedTransitioning>)_transition;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator {
    return _interaction;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator {
    return _interaction;
}
@end

