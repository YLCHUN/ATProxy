//
//  _UIInteractiveTransition.m
//  ATProxy
//
//  Created by YLCHUN on 2018/8/5.
//  Copyright © 2018年 ylchun. All rights reserved.
//

#import "_UIInteractiveTransition.h"

@implementation _UIInteractiveTransition
{
    void(^_interactive)(void);
    ATInteractiveDirection _direction;
    bool _interacting;
}

static _UIInteractiveTransition *_current;
+(instancetype)takeAwayCurrent {
    id current = _current;
    _current = nil;
    return current;
}

-(instancetype)initWithGestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer direction:(ATInteractiveDirection)direction interactive:(void(^)(void))interactive {
    if (self = [super init]) {
        _interactive = interactive;
        _direction = direction;
        _interacting = false;
        [gestureRecognizer addTarget:self action:@selector(handle:)];
        if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
            [self handle:gestureRecognizer];
        }
    }
    return self;
}

- (void)handle:(UIPanGestureRecognizer *)gestureRecognizer {
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStatePossible:
            break;
        case UIGestureRecognizerStateBegan:
            if (![self isDirectionDrag:gestureRecognizer distance:0]) return;
            _interacting = true;
            [self startInteracting];
            break;
        case UIGestureRecognizerStateChanged:
            if (!_interacting) return;
            [self updateInteractiveTransition:[self pgrPercent:gestureRecognizer]];
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
            if (!_interacting) return;
            _interacting = false;
            if ([self isDirectionDrag:gestureRecognizer distance:300] || self.percentComplete >= 0.5) {
                [self finishInteractiveTransition];
            }else {
                [self cancelInteractiveTransition];
            }
            break;
        case UIGestureRecognizerStateFailed:
            _interacting = false;
            [self cancelInteractiveTransition];
            break;
    }
}

-(double)pgrPercent:(UIPanGestureRecognizer *)gestureRecognizer  {
    UIWindow *window = gestureRecognizer.view.window;
    CGPoint translation = [gestureRecognizer translationInView:window];
    CGSize size = window.bounds.size;
    switch (_direction) {
        case ATInteractiveDirectionUp:
            return -translation.y / size.height;
        case ATInteractiveDirectionDown:
            return translation.y / size.height;
        case ATInteractiveDirectionLeft:
            return -translation.x / size.width;
        case ATInteractiveDirectionRight:
            return translation.x / size.width;
    }
}

-(bool)isDirectionDrag:(UIPanGestureRecognizer *)gestureRecognizer distance:(NSUInteger)distance {
    UIWindow *window = gestureRecognizer.view.window;
    CGPoint velocity = [gestureRecognizer velocityInView:window];
    switch (_direction) {
        case ATInteractiveDirectionUp:
            return velocity.y < -(NSInteger)distance;
        case ATInteractiveDirectionDown:
            return velocity.y > distance;
        case ATInteractiveDirectionLeft:
            return velocity.x < -(NSInteger)distance;
        case ATInteractiveDirectionRight:
            return velocity.x > distance;
    }
}

-(void)startInteracting {
    _current = self;
    !_interactive?:_interactive();
    _current = nil;
}

@end
