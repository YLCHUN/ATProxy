//
//  TierTransition.h
//  Transition
//
//  Created by YLCHUN on 2019/3/13.
//  Copyright © 2019年 ylchun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransitionOperation.h"

NS_ASSUME_NONNULL_BEGIN

@interface BusDoorTransition : NSObject<UIViewControllerAnimatedTransitioning>
@property (nonatomic, readonly) TransitionOperation type;
- (instancetype)initWithTransitionType:(TransitionOperation)type;

@end

NS_ASSUME_NONNULL_END
