#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "ATOriginal.h"
#import "ATProxy.h"
#import "UINavigationController+ATProxy.h"
#import "UIPanGestureRecognizer+ATProxy.h"
#import "UITabBarController+ATProxy.h"
#import "UIViewController+ATProxy.h"
#import "ATAnimatedTransitioningDelegateProxy.h"
#import "ATAnimatedTransitioningProxy.h"
#import "ATMethodIMP.h"
#import "ATPercentDrivenInteractiveTransition.h"

FOUNDATION_EXPORT double ATProxyVersionNumber;
FOUNDATION_EXPORT const unsigned char ATProxyVersionString[];

