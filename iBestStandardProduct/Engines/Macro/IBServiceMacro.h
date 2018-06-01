//
//  IBServiceMacro.h
//  iBestStandard
//
//  Created by bingo on 2018/5/15.
//  Copyright © 2018年 xboker. All rights reserved.
//

/*
 功能： 设备相关的宏
 */


#import <Foundation/Foundation.h>


#pragma mark - 系统相关
#define IS_BELOW_IOS_7_0  ([[[UIDevice currentDevice] systemVersion] floatValue] < 7)



#pragma mark - 手机尺寸
#define g_viewHeightAtNavBar 44   //navBarButtom

#define ScreenWidth  ([UIScreen mainScreen].bounds.size.width)
#define ScreenHeight ([UIScreen mainScreen].bounds.size.height)

#define SCREEN_HEIGHT   ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_WIDTH    ([[UIScreen mainScreen] bounds].size.width)

#define IS_IPHONE_4_OR_LESS       (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5               (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6               (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P              (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)


#define IS_IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
#define IS_IPHONE (!IS_IPAD)


#pragma mark - 适配iphoneX 的宏

///320宽度:4; 4S; 5; 5S; SE
#define IS_320_WIDTH     [[UIScreen mainScreen]bounds].size.width == 320
///375宽度:6; 6S; 7;
#define IS_375_WIDTH     [[UIScreen mainScreen]bounds].size.width == 375
///414宽度:6PLUS; 7PLUS
#define IS_414_WIDTH     [[UIScreen mainScreen]bounds].size.width == 414

#define  IS_iPhoneX (ScreenWidth == 375.f && ScreenHeight == 812.f ? YES : NO)

#define StatusBarHeight    (IS_iPhoneX ? 44.f : 20.f)
#define NavBarHeight       (IS_iPhoneX ? 88.f : 64.f)
#define BottomSafeHeight    (IS_iPhoneX?34:0)
#define NavBarAndBottomHeight       (IS_iPhoneX ? 122.f : 64.f)
