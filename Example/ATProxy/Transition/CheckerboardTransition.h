//
//  CheckerboardTransition.h
//  Transition
//
//  Created by YLCHUN on 2019/3/21.
//  Copyright © 2019年 ylchun. All rights reserved.
//
//  不兼容交互动画

#import <UIKit/UIKit.h>
#import "TransitionOperation.h"

NS_ASSUME_NONNULL_BEGIN

@interface CheckerboardTransition : NSObject<UIViewControllerAnimatedTransitioning>
@property (nonatomic, readonly) TransitionOperation type;
- (instancetype)initWithTransitionType:(TransitionOperation)type;
@end

NS_ASSUME_NONNULL_END
