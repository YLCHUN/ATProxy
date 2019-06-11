//
//  _ATProxyRuntime.h
//  ATProxy
//
//  Created by YLCHUN on 2019/6/11.
//  Copyright © 2019年 ylchun. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXTERN void atp_swizzleInstanceMethod(Class cls, SEL originalSelector, SEL swizzledSelector);
