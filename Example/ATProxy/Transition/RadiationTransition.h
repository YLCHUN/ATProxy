//
//  RadiationTransition.h
//  Transition
//
//  Created by YLCHUN on 2019/3/22.
//  Copyright © 2019年 ylchun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransitionOperation.h"

typedef enum : NSUInteger {
    RadiationDirectionVertical,
    RadiationDirectionHorizontal,
} RadiationDirection;

NS_ASSUME_NONNULL_BEGIN

@interface RadiationTransition : NSObject<UIViewControllerAnimatedTransitioning>
@property (nonatomic, readonly) RadiationDirection direction;
@property (nonatomic, readonly) TransitionOperation type;

- (instancetype)initWithTransitionType:(TransitionOperation)type direction:(RadiationDirection)direction;

@end

NS_ASSUME_NONNULL_END
