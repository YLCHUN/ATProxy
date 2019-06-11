//
//  UIPanGestureRecognizer+ATProxy.h
//  ATProxy
//
//  Created by YLCHUN on 2018/8/5.
//  Copyright © 2018年 ylchun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ATGestureRecognizerDirectionUp,
    ATGestureRecognizerDirectionDown,
    ATGestureRecognizerDirectionLeft,
    ATGestureRecognizerDirectionRight,
} ATGestureRecognizerDirection;

@interface UIPanGestureRecognizer (ATProxy)
-(void)setInteractiveDirection:(ATGestureRecognizerDirection)direction transitional:(void(^__nonnull)(void))transitional;
@end
