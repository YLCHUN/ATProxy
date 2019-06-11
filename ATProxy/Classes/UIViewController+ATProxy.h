//
//  UIViewController+ATProxy.h
//  ATProxy
//
//  Created by YLCHUN on 2018/8/3.
//  Copyright © 2018年 ylchun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ATProxy)

- (void)presentViewController:(UIViewController * __nonnull)viewControllerToPresent transitional:(id <UIViewControllerAnimatedTransitioning> __nullable)transitional completion:(void (^ __nullable)(void))completion;

- (void)dismissViewControllerTtransitional:(id <UIViewControllerAnimatedTransitioning> __nullable)transitional completion: (void (^ __nullable)(void))completion;

@end
