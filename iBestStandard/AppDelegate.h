//
//  AppDelegate.h
//  iBestStandard
//
//  Created by xboker on 2018/4/28.
//  Copyright © 2018年 xboker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IBRootTabBarViewController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,strong) IBRootTabBarViewController * rootTabbarVC;

@end


__BEGIN_DECLS

/**
 *  获取QNAppDelegate单例
 *
 *  @return QNAppDelegate
 */
AppDelegate   *App(void);


/**
 *  获取当前app的key window
 *
 *  @return UIWindow
 */
UIWindow        *KeyWindow(void);

/**
 *  获取AppDelegate Window的root view controller
 *
 *  @return UIViewController
 */
UIViewController  *MainController(void);


/**
 *  获取当前AppDelegate Window的root view controller 的view
 *
 *  @return UIView
 */
UIView          *MainView(void);


__END_DECLS



