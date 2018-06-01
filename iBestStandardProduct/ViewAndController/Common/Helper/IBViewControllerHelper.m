//
//  IBViewControllerHelper.m
//  iBestStandard
//
//  Created by bingo on 2018/5/15.
//  Copyright © 2018年 iBest. All rights reserved.


#import "IBViewControllerHelper.h"
#import "IBLaunchingViewController.h"



@implementation IBViewControllerHelper



+ (void)showLauchingController
{
    if (![MainController() isKindOfClass: [IBLaunchingViewController class]])
    {
        IBLaunchingViewController *controller = [[IBLaunchingViewController alloc] initWithNibName: @"IBLaunchingViewController" bundle: nil];
        
        IBBaseNavController * launchNav = [[IBBaseNavController alloc] initWithRootViewController:controller];
        [App().window setRootViewController: launchNav];
        [[UIApplication sharedApplication] setStatusBarHidden: NO];
    }
}


@end
