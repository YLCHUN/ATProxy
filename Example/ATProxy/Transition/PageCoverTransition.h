//
//  PageCoverTransition.h
//  Transition
//
//  Created by YLCHUN on 2018/7/14.
//  Copyright © 2018年 ylchun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransitionOperation.h"

@interface PageCoverTransition : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic, readonly) TransitionOperation type;

+ (instancetype)transitionWithType:(TransitionOperation)type;
- (instancetype)initWithTransitionType:(TransitionOperation)type;
@end
