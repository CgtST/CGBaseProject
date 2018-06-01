//
//  UIViewController+BackItemHandler.h
//  Yihaoqianbao
//
//  Created by CPZX010 on 16/8/1.
//  Copyright © 2016年 Money. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BackItemHandlerDelegate <NSObject>
@optional
- (BOOL)navigationShouldPopViewController;

@end

@interface UIViewController (BackItemHandler) <BackItemHandlerDelegate>

@end
