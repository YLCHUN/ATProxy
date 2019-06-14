//
//  _UIInteractiveTransition.h
//  ATProxy
//
//  Created by YLCHUN on 2018/8/5.
//  Copyright © 2018年 ylchun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ATInteractiveDirectionUp,
    ATInteractiveDirectionDown,
    ATInteractiveDirectionLeft,
    ATInteractiveDirectionRight,
} ATInteractiveDirection;

@interface _UIInteractiveTransition : UIPercentDrivenInteractiveTransition
+ (instancetype __nullable)takeAwayCurrent;
- (instancetype __nonnull)initWithGestureRecognizer:(UIPanGestureRecognizer * __nonnull)gestureRecognizer direction:(ATInteractiveDirection)direction interactive:(void(^ __nonnull)(void))interactive;
@end
