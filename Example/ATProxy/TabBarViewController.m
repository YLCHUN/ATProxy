//
//  TabBarViewController.m
//  Transition
//
//  Created by YLCHUN on 2018/7/14.
//  Copyright © 2018年 ylchun. All rights reserved.
//

#import "TabBarViewController.h"
#import <ATProxy/ATProxy.h>
#import "OvalMaskTransition.h"
#import "FirViewController.h"
#import "NavigationController.h"

@interface TabBarViewController ()<UITabBarControllerDelegate>
@property (nonatomic, strong) UITabBar *customTabBar;
@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NavigationController *vc0 = [[NavigationController alloc] initWithRootViewController:[FirViewController new]];
    vc0.navigationBar.hidden = YES;
    vc0.tabBarItem.title = @"vc0";
    UIViewController *vc1 = [UIViewController new];
    vc1.view.backgroundColor = [UIColor redColor];
    vc1.tabBarItem.title = @"vc1";
    self.viewControllers = @[vc0, vc1];
    
    [self setupCustomTabBar];
}

- (UITabBar *)customTabBar {
    if (!_customTabBar) {
        _customTabBar = [[UITabBar alloc] initWithFrame:self.tabBar.frame];
        _customTabBar.delegate = self;
        self.tabBar.hidden = YES;
        [self.view addSubview:_customTabBar];
        _customTabBar.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |  UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    }
    return _customTabBar;
}

- (void)setupCustomTabBar {
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < self.viewControllers.count; i++) {
        UIViewController *vc = self.viewControllers[i];
        UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:vc.tabBarItem.title image:vc.tabBarItem.image tag:i];
        [arr addObject:item];
    }
    self.customTabBar.items = arr;
    [self.customTabBar setSelectedItem:arr[0]];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    TransitionOperation op;
    if (item.tag == 0) {
        op = TransitionOperationPop;
    }else {
        op = TransitionOperationPush;
    }
    OvalMaskTransition *transition = [[OvalMaskTransition alloc]initWithTransitionType:op anchor:self.view.center];
    [self setSelectedIndex:item.tag transitional:transition];
}

@end
