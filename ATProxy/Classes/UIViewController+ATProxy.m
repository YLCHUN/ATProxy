//
//  UIViewController+ATProxy.m
//  ATProxy
//
//  Created by YLCHUN on 2018/8/3.
//  Copyright © 2018年 ylchun. All rights reserved.
//

#import "UIViewController+ATProxy.h"
#import "_UIViewControllerTransition.h"
#import "_ATProxyRuntime.h"

@implementation UIViewController (ATProxy)

- (void)presentViewController:(UIViewController *)viewControllerToPresent transitional:(id<UIViewControllerAnimatedTransitioning>)transitional completion:(void(^)(void))completion {
    [viewControllerToPresent setupTransition:transitional];
    [self presentViewController:viewControllerToPresent animated:transitional != nil completion:completion];
}

- (void)dismissViewControllerTtransitional:(id<UIViewControllerAnimatedTransitioning>)transitional completion:(void (^)(void))completion {
    [self setupTransition:transitional];
    [self dismissViewControllerAnimated:transitional != nil completion:completion];
}

- (void)setupTransition:(id<UIViewControllerAnimatedTransitioning>)transition {
    if (!transition) return;
    [_UIViewControllerTransition setupTransition:transition delegate:self.transitioningDelegate reset:^(id delegate) {
        atp_setter([UIViewController class], @selector(setTransitioningDelegate:), self, delegate);
    }];
}

@end

