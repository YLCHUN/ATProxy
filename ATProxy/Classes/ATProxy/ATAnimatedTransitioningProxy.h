//
//  ATAnimatedTransitioningProxy.h
//  ATProxy
//
//  Created by YLCHUN on 2018/7/15.
//  Copyright © 2018年 ylchun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ATAnimatedTransitioningProxy : NSProxy
- (instancetype __nonnull)initWithTransition:(id<UIViewControllerAnimatedTransitioning> __nonnull)transition completion:(void(^ __nullable)(void))completion;
@end
