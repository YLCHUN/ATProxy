//
//  SecViewController.m
//  Transition
//
//  Created by YLCHUN on 2018/7/14.
//  Copyright © 2018年 ylchun. All rights reserved.
//

#import "SecViewController.h"
#import <ATProxy/ATProxy.h>
#import "EventHandler.h"
#import "OvalMaskTransition.h"
#import "PageCoverTransition.h"
#import "StackTransition.h"
#import "BusDoorTransition.h"
#import "RotateTransition.h"
#import "DefaultTransition.h"
#import "ViewTransition.h"
#import "RadiationTransition.h"
#import "RRTransition.h"
#import "PageTransition.h"
#import "BrokenTransition.h"
#import "CheckerboardTransition.h"

@interface SecViewController ()
{
    EventHandler *_eventHandler;
}
@end

@implementation SecViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = [UIScreen mainScreen].bounds;
    _eventHandler = [self eventHandler];
    UIPanGestureRecognizer *pgr = [[UIPanGestureRecognizer alloc] init];
    [self.view addGestureRecognizer:pgr];
    __weak typeof(self) wself = self;
    [pgr setInteractiveDirection:ATGestureRecognizerDirectionRight transitional:^{
        [wself pop:nil];
        //不支持交互动画
        //CheckerboardTransition
        //RRTransition
        //ViewTransition
    }];
}

- (IBAction)pop:(UIButton *)sender {
    static int i = 0;
    NSArray *events = _eventHandler.events;
    NSString *event = events[events.count - i - 1];
    [_eventHandler callEvent:event arg:nil];
    i = (i+1) % events.count;
    NSLog(@"t: %@", event);
}

- (EventHandler *)eventHandler {
    EventHandler *handler = [EventHandler new];
    [handler setEvent:@"BrokenTransition" handle:^(id arg) {
        id<UIViewControllerAnimatedTransitioning> t = [BrokenTransition new];
        [self hideWithTransitional:t];
    }];
    [handler setEvent:@"CheckerboardTransition" handle:^(id arg) {
        id<UIViewControllerAnimatedTransitioning> t = [[CheckerboardTransition alloc] initWithTransitionType:TransitionOperationPop];
        [self hideWithTransitional:t];
    }];
    [handler setEvent:@"RRTransition" handle:^(id arg) {
        id<UIViewControllerAnimatedTransitioning> t = [[RRTransition alloc] initWithTransitionType:TransitionOperationPop];
        [self hideWithTransitional:t];
    }];
    [handler setEvent:@"RadiationTransition" handle:^(id arg) {
        id<UIViewControllerAnimatedTransitioning> t = [[RadiationTransition alloc] initWithTransitionType:TransitionOperationPop direction:RadiationDirectionVertical];
        [self hideWithTransitional:t];
    }];
    [handler setEvent:@"BusDoorTransition" handle:^(id arg) {
        id<UIViewControllerAnimatedTransitioning> t = [[BusDoorTransition alloc] initWithTransitionType:TransitionOperationPop];
        [self hideWithTransitional:t];
    }];
    [handler setEvent:@"OvalMaskTransition" handle:^(id arg) {
        id<UIViewControllerAnimatedTransitioning> t = [[OvalMaskTransition alloc] initWithTransitionType:TransitionOperationPop anchor:self.view.center];
        [self hideWithTransitional:t];
    }];
    [handler setEvent:@"PageCoverTransition" handle:^(id arg) {
        id<UIViewControllerAnimatedTransitioning> t = [[PageCoverTransition alloc] initWithTransitionType:TransitionOperationPop];
        [self hideWithTransitional:t];
    }];
    [handler setEvent:@"PageTransition" handle:^(id arg) {
        id<UIViewControllerAnimatedTransitioning> t = [[PageTransition alloc] initWithTransitionType:TransitionOperationPop];
        [self hideWithTransitional:t];
    }];
    [handler setEvent:@"RotateTransition" handle:^(id arg) {
        id<UIViewControllerAnimatedTransitioning> t = [[RotateTransition alloc] initWithTransitionType:TransitionOperationPop];
        [self hideWithTransitional:t];
    }];
    [handler setEvent:@"StackTransition" handle:^(id arg) {
        id<UIViewControllerAnimatedTransitioning> t = [[StackTransition alloc] initWithTransitionType:TransitionOperationPop];
        [self hideWithTransitional:t];
    }];
    [handler setEvent:@"ViewTransition" handle:^(id arg) {
        ViewTransition *t = [[ViewTransition alloc] initWithTransitionType:TransitionOperationPop];
        t.from = [self.view viewWithTag:100];
        UIViewController *vc = self.presentingViewController;
        if (!vc && self.navigationController.viewControllers.count > 1) {
            vc = self.navigationController.viewControllers[self.navigationController.viewControllers.count-2];
        }
        t.to = [vc.view viewWithTag:100];
        [self hideWithTransitional:t];
    }];
    return handler;
}

- (void)hideWithTransitional:(id<UIViewControllerAnimatedTransitioning>) t {
//    [self dismissViewControllerTtransitional:t completion:nil];
    [self.navigationController popViewControllerTransitional:t];
}

- (void)dealloc {
    NSLog(@"____ %s", __func__);
}

@end
