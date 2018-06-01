//
//  UIViewController+IBXNavigationExtension.m
//  AnimationEffect
//
//  Created by xboker on 2017/5/6.
//  Copyright © 2017年 谢昆鹏. All rights reserved.
//

#import "UIViewController+IBXNavigationExtension.h"
#import <objc/runtime.h>


@implementation UIViewController (IBXNavigationExtension)

- (BOOL)xFullScreenPopEnable {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setXFullScreenPopEnable:(BOOL)xFullScreenPopEnable {
    objc_setAssociatedObject(self, @selector(xFullScreenPopEnable), @(xFullScreenPopEnable), OBJC_ASSOCIATION_RETAIN);
}


- (QNBaseNavController *)xNavigationcontroller {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setXNavigationcontroller:(QNBaseNavController *)xNavigationcontroller {
    objc_setAssociatedObject(self, @selector(xNavigationcontroller), xNavigationcontroller, OBJC_ASSOCIATION_ASSIGN);
}


@end
