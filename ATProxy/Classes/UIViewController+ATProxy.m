//
//  UIViewController+ATProxy.m
//  ATProxy
//
//  Created by YLCHUN on 2018/8/3.
//  Copyright © 2018年 ylchun. All rights reserved.
//

#import "UIViewController+ATProxy.h"
#import "_UIViewControllerTransition.h"

@implementation UIViewController (ATProxy)

- (void)presentViewController:(UIViewController *)viewControllerToPresent transitional:(id <UIViewControllerAnimatedTransitioning>)transitional completion:(void (^ __nullable)(void))completion {
    [viewControllerToPresent setupTransition:transitional];
    [self presentViewController:viewControllerToPresent animated:transitional != nil completion:completion];
}

- (void)dismissViewControllerTtransitional:(id <UIViewControllerAnimatedTransitioning>)transitional completion: (void (^ __nullable)(void))completion {
    [self setupTransition:transitional];
    [self dismissViewControllerAnimated:transitional != nil completion:completion];
}

- (void)setupTransition:(id <UIViewControllerAnimatedTransitioning>)transition {
    if (!transition) return;
    [_UIViewControllerTransition setupTransition:transition delegate:self.transitioningDelegate reset:^(id delegate) {
        self.transitioningDelegate = delegate;
    }];
}

@end

