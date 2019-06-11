//
//  UIPanGestureRecognizer+ATProxy.m
//  ATProxy
//
//  Created by YLCHUN on 2018/8/5.
//  Copyright © 2018年 ylchun. All rights reserved.
//

#import "UIPanGestureRecognizer+ATProxy.h"
#import "_UIInteractiveTransition.h"
#import <objc/runtime.h>

@implementation UIPanGestureRecognizer (ATProxy)

- (void)setInteractiveDirection:(ATGestureRecognizerDirection)direction transitional:(void(^)(void))transitional {
    if (!transitional) return;
    _UIInteractiveTransition *interaction = [[_UIInteractiveTransition alloc] initWithGestureRecognizer:self direction:atDirection(direction) interactive:transitional];
    [self setInteraction:interaction];
}

- (void)setInteraction:(_UIInteractiveTransition *) interaction {
    static char * nameKey = "interaction";
    objc_setAssociatedObject(self, &nameKey, interaction, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static ATInteractiveDirection atDirection(ATGestureRecognizerDirection direction) {
    switch (direction) {
        case ATGestureRecognizerDirectionUp:
            return ATInteractiveDirectionUp;
        case ATGestureRecognizerDirectionDown:
            return ATInteractiveDirectionDown;
        case ATGestureRecognizerDirectionLeft:
            return ATInteractiveDirectionLeft;
        case ATGestureRecognizerDirectionRight:
            return ATInteractiveDirectionRight;
    }
}

@end

