//
//  RRTransition.h
//  Transition
//
//  Created by YLCHUN on 2019/3/23.
//  Copyright © 2019 ylchun. All rights reserved.
//
//  不兼容交互动画

#import <UIKit/UIKit.h>
#import "TransitionOperation.h"

NS_ASSUME_NONNULL_BEGIN

@interface RRTransition : NSObject<UIViewControllerAnimatedTransitioning>
@property (nonatomic, readonly) TransitionOperation type;
- (instancetype)initWithTransitionType:(TransitionOperation)type;

@end

NS_ASSUME_NONNULL_END
