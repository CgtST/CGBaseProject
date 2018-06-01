//
//  UIViewController+CustomSetting.m
//  QNApp
//
//  Created by xboker on 2017/5/6.
//  Copyright © 2017年 BaiCai. All rights reserved.
//

#import "UIViewController+CustomSetting.h"
#import <objc/runtime.h>


@implementation UIViewController (CustomSetting)



+ (void)load {
    Method viewWillAppear = class_getClassMethod([self class], @selector(viewWillAppear:));
    Method myViewWillAppear = class_getInstanceMethod([self class], @selector(myViewWillAppear:));
    method_exchangeImplementations(viewWillAppear, myViewWillAppear);
}

- (void)myViewWillAppear:(BOOL)animated {
    [self myViewWillAppear:animated];
    if (self.navigationController.navigationBar.hidden == NO) {
        [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHexString:@"#2E2E2E"]];
    }
    
}



@end
