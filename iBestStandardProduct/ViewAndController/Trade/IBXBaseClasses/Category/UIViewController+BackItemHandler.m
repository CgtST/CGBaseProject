//
//  UIViewController+BackItemHandler.m
//  Yihaoqianbao
//
//  Created by CPZX010 on 16/8/1.
//  Copyright © 2016年 Money. All rights reserved.
//

#import "UIViewController+BackItemHandler.h"


@implementation UIViewController (BackItemHandler)

@end


@implementation UINavigationController (ShouldPopView)

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    
    if([self.viewControllers count] < [navigationBar.items count]) {
        return YES;
    }
    BOOL shouldPop = YES;
    UIViewController* controller = [self topViewController];
    if([controller respondsToSelector:@selector(navigationShouldPopViewController)]) {
        shouldPop = [controller navigationShouldPopViewController];
    }
    if(shouldPop) {
        __weak UINavigationController *weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf popViewControllerAnimated:YES];
        });
    } else {
        for(UIView *subview in [navigationBar subviews]) {
            if(0. < subview.alpha && subview.alpha < 1.) {
                [UIView animateWithDuration:.25 animations:^{
                    subview.alpha = 1.;
                }];
            }
        }
    }
    return NO;
}

@end


