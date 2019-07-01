//
//  UIPanGestureRecognizer+ATProxy.h
//  ATProxy
//
//  Created by YLCHUN on 2018/8/5.
//  Copyright © 2018年 ylchun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ATGestureDirectionUp,
    ATGestureDirectionDown,
    ATGestureDirectionLeft,
    ATGestureDirectionRight,
} ATGestureDirection;

@interface UIPanGestureRecognizer (ATProxy)
- (void)setInteractiveDirection:(ATGestureDirection)direction transitional:(void(^__nonnull)(void))transitional;
@end
