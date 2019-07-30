//
//  UITabBarController+ATProxy.h
//  ATProxy
//
//  Created by YLCHUN on 2018/7/14.
//  Copyright © 2018年 ylchun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBarController (ATProxy)

- (void)setSelectedIndex:(NSUInteger)selectedIndex transitional:(id<UIViewControllerAnimatedTransitioning> __nullable)transitional;

- (void)setSelectedViewController:(UIViewController * __nonnull)selectedViewController transitional:(id<UIViewControllerAnimatedTransitioning> __nullable)transitional;

@end

