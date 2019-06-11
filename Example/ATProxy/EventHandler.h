//
//  EventHandler.h
//  Transition
//
//  Created by YLCHUN on 2019/3/25.
//  Copyright © 2019 ylchun. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^EventHandlerCallback)(id arg);
NS_ASSUME_NONNULL_BEGIN

@interface EventHandler : NSObject
- (void)setEvent:(NSString *)event handle:(EventHandlerCallback)handle;
- (void)callEvent:(NSString *)event arg:(__nullable id)arg;
- (NSArray<NSString *> * _Nullable)events;
- (void)clean;
@end

NS_ASSUME_NONNULL_END
