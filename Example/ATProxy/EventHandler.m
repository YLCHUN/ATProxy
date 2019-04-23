//
//  EventHandler.m
//  Transition
//
//  Created by YLCHUN on 2019/3/25.
//  Copyright © 2019 ylchun. All rights reserved.
//

#import "EventHandler.h"

@implementation EventHandler
{
    NSMutableDictionary<NSString *, EventHandlerCallback> *_dict;
}

-(instancetype)init {
    self = [super init];
    if (self) {
        _dict = [NSMutableDictionary dictionary];
    }
    return self;
}

-(void)setEvent:(NSString *)event handle:(EventHandlerCallback)handle {
    _dict[event] = handle;
}

-(void)callEvent:(NSString *)event arg:(id)arg {
    EventHandlerCallback handle = _dict[event];
    !handle?:handle(arg);
}

-(NSArray<NSString *> *)events {
    return [_dict allKeys];
}

-(void)clean {
    [_dict removeAllObjects];
}

@end
