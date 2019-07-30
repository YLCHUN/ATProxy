//
//  UITabBarController+ATProxy.m
//  ATProxy
//
//  Created by YLCHUN on 2018/7/14.
//  Copyright © 2018年 ylchun. All rights reserved.
//

#import "UITabBarController+ATProxy.h"
#import "ATAnimatedTransitioningDelegateProxy.h"
#import "ATMethodIMP.h"

@implementation UITabBarController (atp)

- (void)atp_setSelectedIndex:(NSUInteger)selectedIndex {
    if (kATOriginal) {
        SEL sel = @selector(setSelectedIndex:);
        void(*imp)(id, SEL, NSUInteger) = (void(*)(id, SEL, NSUInteger))atp_methodOrignImp([UITabBarController class], sel);
        if (imp) {
            imp(self, sel, selectedIndex);
        }else {
            [self setSelectedIndex:selectedIndex];
        }
    }else {
        [self setSelectedIndex:selectedIndex];
    }
}

- (void)atp_setSelectedViewController:(UIViewController *)selectedViewController {
    if (kATOriginal) {
        SEL sel = @selector(setSelectedViewController:);
        void(*imp)(id, SEL, id) = (void(*)(id, SEL, id))atp_methodOrignImp([UITabBarController class], sel);
        if (imp) {
            imp(self, sel, selectedViewController);
        }else {
            [self setSelectedViewController:selectedViewController];
        }
    }else {
        [self setSelectedViewController:selectedViewController];
    }
}

- (void)atp_setDelegate:(id<UITabBarControllerDelegate>)delegate {
    SEL sel = @selector(setDelegate:);
    void(*imp)(id, SEL, id) = (void(*)(id, SEL, id))atp_methodOrignImp([UITabBarController class], sel);
    if (imp) {
        imp(self, sel, delegate);
    }else {
        [self setDelegate:delegate];
    }
}

@end

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
    [self atp_setSelectedIndex:selectedIndex];
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
    [self atp_setSelectedViewController:selectedViewController];
}

- (void)setupTransition:(id<UIViewControllerAnimatedTransitioning>)transition {
    if (!transition) return;
    [ATAnimatedTransitioningDelegateProxy setupTransition:transition delegate:self.delegate reset:^(id delegate) {
        [self atp_setDelegate:delegate];
    }];
}

- (void)atp_setDelegate:(id<UITabBarControllerDelegate>)delegate {
    SEL sel = @selector(setDelegate:);
    void(*setDelegate)(id, SEL, id) = (void(*)(id, SEL, id))atp_methodOrignImp([UITabBarController class], sel);
    if (setDelegate == NULL) return;
    setDelegate(self, sel, delegate);
}

@end

