//
//  OvalMaskTransition.h
//  Transition
//
//  Created by YLCHUN on 2018/7/10.
//  Copyright © 2018年 YLCHUN. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "TransitionOperation.h"

@interface OvalMaskTransition : NSObject<UIViewControllerAnimatedTransitioning>
@property (nonatomic, readonly) TransitionOperation type;
- (instancetype)initWithTransitionType:(TransitionOperation)type anchor:(CGPoint)anchor;
@end
