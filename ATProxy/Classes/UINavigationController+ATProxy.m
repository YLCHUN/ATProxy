//
//  UINavigationController+ATProxy.m
//  ATProxy
//
//  Created by YLCHUN on 2018/7/14.
//  Copyright © 2018年 ylchun. All rights reserved.
//

#import "UINavigationController+ATProxy.h"
#import "_UIViewControllerTransition.h"
#import "_ATProxyRuntime.h"

@implementation UINavigationController (ATProxy)

- (void)pushViewController:(UIViewController *)viewController transitional:(id<UIViewControllerAnimatedTransitioning>)transitional {
    [self setupTransition:transitional];
    [self pushViewController:viewController animated:transitional != nil];
}

- (UIViewController *)popViewControllerTransitional:(id<UIViewControllerAnimatedTransitioning>)transitional {
    [self setupTransition:transitional];
    return [self popViewControllerAnimated:transitional != nil];
}

- (NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController transitional:(id<UIViewControllerAnimatedTransitioning>)transitional {
    [self setupTransition:transitional];
    return [self popToViewController:viewController animated:transitional != nil];
}

- (NSArray<UIViewController *> *)popToRootViewControllerTtransitional:(id<UIViewControllerAnimatedTransitioning>)transitional {
    [self setupTransition:transitional];
    return [self popToRootViewControllerAnimated:transitional != nil];
}

- (void)setupTransition:(id<UIViewControllerAnimatedTransitioning>)transition {
    if (!transition) return;
    [_UIViewControllerTransition setupTransition:transition delegate:self.delegate reset:^(id delegate) {
        atp_setter([UINavigationController class], @selector(setDelegate:), self, delegate);
    }];
}

@end
