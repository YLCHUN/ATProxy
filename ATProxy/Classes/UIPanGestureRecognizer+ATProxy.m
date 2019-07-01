//
//  UIPanGestureRecognizer+ATProxy.m
//  ATProxy
//
//  Created by YLCHUN on 2018/8/5.
//  Copyright © 2018年 ylchun. All rights reserved.
//

#import "UIPanGestureRecognizer+ATProxy.h"
#import "ATPercentDrivenInteractiveTransition.h"
#import <objc/runtime.h>

@implementation UIPanGestureRecognizer (ATProxy)

- (void)setInteractiveDirection:(ATGestureDirection)direction transitional:(void(^)(void))transitional {
    if (!transitional) return;
    ATPercentDrivenInteractiveTransition *interaction = [[ATPercentDrivenInteractiveTransition alloc] initWithGestureRecognizer:self direction:atDirection(direction) interactive:transitional];
    [self setInteraction:interaction];
}

- (void)setInteraction:(ATPercentDrivenInteractiveTransition *) interaction {
    static char * nameKey = "interaction";
    objc_setAssociatedObject(self, &nameKey, interaction, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static ATInteractiveDirection atDirection(ATGestureDirection direction) {
    switch (direction) {
        case ATGestureDirectionUp:
            return ATInteractiveDirectionUp;
        case ATGestureDirectionDown:
            return ATInteractiveDirectionDown;
        case ATGestureDirectionLeft:
            return ATInteractiveDirectionLeft;
        case ATGestureDirectionRight:
            return ATInteractiveDirectionRight;
    }
}

@end

