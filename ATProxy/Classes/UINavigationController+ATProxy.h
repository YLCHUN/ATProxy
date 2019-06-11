//
//  UINavigationController+ATProxy.h
//  ATProxy
//
//  Created by YLCHUN on 2018/7/14.
//  Copyright © 2018年 ylchun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (ATProxy)

-(void)pushViewController:(UIViewController * __nonnull)viewController transitional:(id <UIViewControllerAnimatedTransitioning> __nullable)transitional;

-(UIViewController *_Nonnull)popViewControllerTransitional:(id <UIViewControllerAnimatedTransitioning> __nullable)transitional;

-(NSArray<UIViewController *> *_Nonnull)popToViewController:(UIViewController * __nonnull)viewController transitional:(id <UIViewControllerAnimatedTransitioning> __nullable)transitional;

-(NSArray<UIViewController *> *_Nonnull)popToRootViewControllerTtransitional:(id <UIViewControllerAnimatedTransitioning> __nullable)transitional;

@end
