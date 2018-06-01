//
//  QNLaunchingViewController.h
//  QNApp
//
//  Created by manny on 14-11-14.
//  Copyright (c) 2014年 Bacai. All rights reserved.
//

#import "IBBaseViewController.h"

typedef NS_ENUM(NSUInteger,IBFuncType) {
    IBFuncTypeRegistNow,  //马上注册
    IBFuncTypeJustLook //看一看
};

@class IBLaunchingVCViewModel;

@interface IBLaunchingViewController : IBBaseViewController

@end
