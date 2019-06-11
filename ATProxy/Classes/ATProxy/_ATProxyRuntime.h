//
//  _ATProxyRuntime.h
//  ATProxy
//
//  Created by YLCHUN on 2019/6/11.
//

#import <Foundation/Foundation.h>

void atp_swizzleInstanceMethod(Class class, SEL originalSelector, SEL swizzledSelector);
