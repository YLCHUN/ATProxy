//
//  _UIViewControllerTransition.h
//  ATProxy
//
//  Created by YLCHUN on 2018/7/14.
//  Copyright © 2018年 ylchun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface _UIViewControllerTransition : NSProxy
+ (void)setupTransition:(id <UIViewControllerAnimatedTransitioning> __nullable)transition delegate:(id __nullable)delegate reset:(void(^__nonnull)(id __nullable delegate))reset;
@end
