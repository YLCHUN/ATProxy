//
//  FirViewController.m
//  Transition
//
//  Created by YLCHUN on 2018/7/14.
//  Copyright © 2018年 ylchun. All rights reserved.
//

#import "FirViewController.h"
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
#import "CheckerboardTransition.h"
#import "RadiationTransition.h"
#import "RRTransition.h"
#import "PageTransition.h"
#import "BrokenTransition.h"

@interface FirViewController ()

@end

@implementation FirViewController
{
    EventHandler *_eventHandler;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = [UIScreen mainScreen].bounds;
    _eventHandler = [self eventHandler];
    UIPanGestureRecognizer *pgr = [[UIPanGestureRecognizer alloc] init];
    [self.view addGestureRecognizer:pgr];
    __weak typeof(self) wself = self;
    [pgr setInteractiveDirection:ATGestureDirectionLeft transitional:^{
        [wself push:nil];
        //不支持交互动画
        //CheckerboardTransition
        //RRTransition
        //ViewTransition
    }];
}

- (IBAction)push:(UIButton *)sender {
    static int i = 0;
    NSArray *events = _eventHandler.events;
    NSString *event = events[i];
    [_eventHandler callEvent:event arg:nil];
    i = (i+1) % events.count;
    NSLog(@"t: %@", event);
}


- (EventHandler *)eventHandler {
    EventHandler *handler = [EventHandler new];
    SecViewController *vc = [SecViewController new];
    [handler setEvent:@"BrokenTransition" handle:^(id arg) {
        id<UIViewControllerAnimatedTransitioning> t = [BrokenTransition new];
        [self show:vc transitional:t];
    }];
    [handler setEvent:@"CheckerboardTransition" handle:^(id arg) {
        id<UIViewControllerAnimatedTransitioning> t = [[CheckerboardTransition alloc] initWithTransitionType:TransitionOperationPush];
        [self show:vc transitional:t];
    }];
    [handler setEvent:@"RRTransition" handle:^(id arg) {
        id<UIViewControllerAnimatedTransitioning> t = [[RRTransition alloc] initWithTransitionType:TransitionOperationPush];
        [self show:vc transitional:t];
    }];
    [handler setEvent:@"RadiationTransition" handle:^(id arg) {
        id<UIViewControllerAnimatedTransitioning> t = [[RadiationTransition alloc] initWithTransitionType:TransitionOperationPush direction:RadiationDirectionHorizontal];
        [self show:vc transitional:t];
    }];
    [handler setEvent:@"BusDoorTransition" handle:^(id arg) {
        id<UIViewControllerAnimatedTransitioning> t = [[BusDoorTransition alloc] initWithTransitionType:TransitionOperationPush];
        [self show:vc transitional:t];
    }];
    [handler setEvent:@"OvalMaskTransition" handle:^(id arg) {
        id<UIViewControllerAnimatedTransitioning> t = [[OvalMaskTransition alloc] initWithTransitionType:TransitionOperationPush anchor:self.view.center];
        [self show:vc transitional:t];
    }];
    [handler setEvent:@"PageCoverTransition" handle:^(id arg) {
        id<UIViewControllerAnimatedTransitioning> t = [[PageCoverTransition alloc] initWithTransitionType:TransitionOperationPush];
        [self show:vc transitional:t];
    }];
    [handler setEvent:@"PageTransition" handle:^(id arg) {
        id<UIViewControllerAnimatedTransitioning> t = [[PageTransition alloc] initWithTransitionType:TransitionOperationPush];
        [self show:vc transitional:t];
    }];
    [handler setEvent:@"RotateTransition" handle:^(id arg) {
        id<UIViewControllerAnimatedTransitioning> t = [[RotateTransition alloc] initWithTransitionType:TransitionOperationPush];
        [self show:vc transitional:t];
    }];
    [handler setEvent:@"StackTransition" handle:^(id arg) {
        id<UIViewControllerAnimatedTransitioning> t = [[StackTransition alloc] initWithTransitionType:TransitionOperationPush];
        [self show:vc transitional:t];
    }];
    [handler setEvent:@"ViewTransition" handle:^(id arg) {
        ViewTransition *t = [[ViewTransition alloc] initWithTransitionType:TransitionOperationPush];
        t.from = [self.view viewWithTag:100];
        t.to = [vc.view viewWithTag:100];
        [self show:vc transitional:t];
    }];
    return handler;
}

- (void)show:(UIViewController *)vc transitional:(id<UIViewControllerAnimatedTransitioning>) t {
//    [self presentViewController:vc transitional:t completion:nil];
    atp_original(^{
        [self.navigationController pushViewController:vc transitional:t];
    });
}
- (void)setTransitioningDelegate:(id<UIViewControllerTransitioningDelegate>)transitioningDelegate {
    [super setTransitioningDelegate:transitioningDelegate];
}
@end




