//
//  YHQBaseViewController.h
//  Yihaoqianbao
//
//  Created by Money on 16/3/15.
//  Copyright © 2016年 Money. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "QNBaseViewController.h"

#import "IQKeyboardManager.h"
#import "UIScrollView+EmptyDataSet.h"



@interface YHQBaseViewController : QNBaseViewController<DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>


/**
 *  数据请求交互提示方法
 *
 *  @param view 添加到父视图中的父view
 */
- (void)showRequestActivityProgressToView:(UIView *)view;
//
///**
// *  隐藏数据请求交互提示
// */
//- (void)hiddenRequestActivityProgressView;


/**
 *  隐藏数据请求交互提示
 */
- (void)hiddenRequestActivityProgressViewWithView:(UIView *)view;




/**
 *  数据请求出错时提示用户方法
 *
 *  @param view      添加到父视图中的父view
 *  @param errorStr  错误信息
 *  @param animation 是否动画显示
 */
- (void)showRequestFailureErrorToView:(UIView *)view errorString:(NSString *)errorStr animation:(BOOL)animation;

/**
 *  数据请求没有数据时提示用户方法
 *
 *  @param view      添加到父视图中的父view
 *  @param tipString 提示信息
 */
- (void)showRequestSuccessNoDataToView:(UIView *)view tipInfoString:(NSString *)tipString;

/**
 *  隐藏提示没有数据的提示方法
 */
- (void)hiddenNoDataTipInfoView;

/**
 *  显示提示用户信息的方法
 *
 *  @param view      添加到父视图中的父view
 *  @param errorStr  提示信息
 *  @param animation 是否动画显示
 */
- (void)showTipInfoToView:(UIView *)view tipInfoString:(NSString *)tipInfoString animation:(BOOL)animation;


/**
 显示提示用户信息的方法---请不要使用

 @param view             添加到父视图中的父view
 @param tipInfoString    提示信息
 @param animation        是否动画显示
 @param offsetY          y方向偏移量
 */
- (void)showTipInfoToView:(UIView *)view tipInfoString:(NSString *)tipInfoString animation:(BOOL)animation withOffsetY:(CGFloat)offsetY;


/////用来检测交易是否登录的bool值:YES-已登录, NO-未登录------废弃
//@property (nonatomic, assign) BOOL m_TradeHaveLogin;



////用来检测iBEST是否已经登录
@property (nonatomic, assign) BOOL m_iBESTHaveLogin;






@end
