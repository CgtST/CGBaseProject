//
//  UIViewController+IBXNavigationExtension.h
//  AnimationEffect
//
//  Created by xboker on 2017/5/6.
//  Copyright © 2017年 谢昆鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IBXNavigationViewController.h"
#import "QNBaseNavController.h"


@interface UIViewController (IBXNavigationExtension)

@property (nonatomic, assign) BOOL xFullScreenPopEnable;
@property (nonatomic, weak) QNBaseNavController  *xNavigationcontroller;


@end
