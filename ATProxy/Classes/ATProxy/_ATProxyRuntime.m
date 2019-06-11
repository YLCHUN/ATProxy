//
//  _ATProxyRuntime.m
//  ATProxy
//
//  Created by YLCHUN on 2019/6/11.
//  Copyright © 2019年 ylchun. All rights reserved.
//

#import "_ATProxyRuntime.h"
#import <objc/runtime.h>

void atp_setter(Class superClass, SEL sel, id self, id obj) {
    if (!superClass) superClass = [self class];
    Method method = class_getInstanceMethod(superClass, sel);
    if (method == NULL) return;
    void(*setterImp)(id, SEL, id) = (void(*)(id, SEL, id))method_getImplementation(method);
    if (setterImp == NULL) return;
    setterImp(self, sel, obj);
}
