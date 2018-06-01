//
//  AppDelegate.m
//  iBestStandard
//
//  Created by xboker on 2018/4/28.
//  Copyright © 2018年 xboker. All rights reserved.
//

#import "AppDelegate.h"
#import "IBSecurityManager.h"
#import "IBRootTabBarViewController.h"
#import "IBViewControllerHelper.h"



AppDelegate   *App() {
    return ((AppDelegate *)[UIApplication sharedApplication].delegate);
}
UIWindow        *KeyWindow() {
    return [UIApplication sharedApplication].keyWindow;
}
UIViewController *MainController() {
    return App().window.rootViewController;
}
UIView          *MainView() {
    return MainController().view;
}


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    

    //当前主题颜色文件
    [DKColorTable sharedColorTable].file = @"iBestColorTable.txt";
    self.dk_manager.changeStatusBar = NO;
    
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.dk_backgroundColorPicker = DKColorPickerWithKey(QContentColor);
//    IBRootTabBarViewController * controller = [[IBRootTabBarViewController alloc] init];
//    self.window.rootViewController = controller;
//    [App().window setRootViewController: controller];
    [self.window makeKeyWindow];
    
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    [IBViewControllerHelper showLauchingController];
    
//    [ibFXHandler()  ibFXGetSysCfgWithView:nil];

    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - Getter
- (DKNightVersionManager *)dk_manager {
    return [DKNightVersionManager sharedManager];
}

-(IBRootTabBarViewController *)rootTabbarVC
{
    if (_rootTabbarVC == nil) {
        _rootTabbarVC = [[IBRootTabBarViewController alloc] init];
    }
    return _rootTabbarVC;
}

@end
