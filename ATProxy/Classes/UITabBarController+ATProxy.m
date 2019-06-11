//
//  UITabBarController+ATProxy.m
//  ATProxy
//
//  Created by YLCHUN on 2018/7/14.
//  Copyright © 2018年 ylchun. All rights reserved.
//

#import "UITabBarController+ATProxy.h"
#import "_UIViewControllerTransition.h"
#import "_ATProxyRuntime.h"

@implementation UITabBarController (ATProxy)

- (void)setSelectedIndex:(NSUInteger)selectedIndex transitional:(id<UIViewControllerAnimatedTransitioning>)transitional {
    if (selectedIndex >= self.viewControllers.count || selectedIndex == self.selectedIndex) return;
    if (transitional) {
        UIBarButtonItem *item = (UIBarButtonItem *)self.tabBar.items[selectedIndex];
        if (item.target && item.action) {
            [self setupTransition:transitional];
            [item.target performSelector:item.action withObject:item afterDelay:0];
            return;
        }
    }
    [self setSelectedIndex:selectedIndex];
}

- (void)setSelectedViewController:(UIViewController *)selectedViewController transitional:(id<UIViewControllerAnimatedTransitioning>)transitional {
    if (selectedViewController == self.selectedViewController || ![self.viewControllers containsObject:selectedViewController]) return;
    if (transitional) {
        UIBarButtonItem *item = (UIBarButtonItem *)selectedViewController.tabBarItem;
        if (item.target && item.action) {
            [self setupTransition:transitional];
            [item.target performSelector:item.action withObject:item afterDelay:0];
            return;
        }
    }
    [self setSelectedViewController:selectedViewController];
}

- (void)setupTransition:(id<UIViewControllerAnimatedTransitioning>)transition {
    if (!transition) return;
    [_UIViewControllerTransition setupTransition:transition delegate:self.delegate reset:^(id delegate) {
        atp_setter([UITabBarController class], @selector(setDelegate:), self, delegate);
    }];
}

@end

