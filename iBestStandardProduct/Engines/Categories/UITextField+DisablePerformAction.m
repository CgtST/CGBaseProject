//
//  UITextField+DisablePerformAction.m
//  QNApp
//
//  Created by QNRZMac on 15/11/4.
//  Copyright © 2015年 Bacai. All rights reserved.
//

#import "UITextField+DisablePerformAction.h"
#import <objc/runtime.h>

@implementation UITextField(DisablePerformAction)

@dynamic disablePerformAction;

static char disablePerformActionKey;

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (self.disablePerformAction) {
        return NO;
    }else {
        return [super canPerformAction:action withSender:sender];
    }
}

- (void)setDisablePerformAction:(BOOL)disablePerformAction {
    objc_setAssociatedObject(self, &disablePerformActionKey, @(disablePerformAction), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)disablePerformAction {
    NSNumber * number = objc_getAssociatedObject(self, &disablePerformActionKey);
    return number.boolValue;
}

@end
