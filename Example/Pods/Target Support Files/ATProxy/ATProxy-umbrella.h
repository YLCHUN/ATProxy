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

#import "ATProxy.h"
#import "ATOriginal.h"
#import "UINavigationController+ATProxy.h"
#import "UITabBarController+ATProxy.h"
#import "UIViewController+ATProxy.h"
#import "UIPanGestureRecognizer+ATProxy.h"

FOUNDATION_EXPORT double ATProxyVersionNumber;
FOUNDATION_EXPORT const unsigned char ATProxyVersionString[];

