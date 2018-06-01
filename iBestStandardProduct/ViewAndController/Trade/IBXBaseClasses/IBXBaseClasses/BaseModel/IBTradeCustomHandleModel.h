//
//  IBTradeCustomHandleModel.h
//  iBestProduct
//  交易相关的通用发送请求处理模型
//  Created by xboker on 2017/11/8.
//  Copyright © 2017年 iBest. All rights reserved.
//


//此类禁止创建!!!!!--直接用   ibTradeHandler()



#import "QNBaseHttpClient.h"

@interface IBTradeCustomHandleModel : QNBaseHttpClient
///YES:可以进入忘记交易密码界面, 默认为NO, 发请求过程中也为NO;
@property (nonatomic, assign) BOOL canGoToForgetPswView;


/**
 获取是否可以进入忘记交易密码界面开关
 
 @param view 展示信息的view
 @param callBack 请求结束回调
 */
- (void)getForgetPSWViewStatusActionWithView:(UIView *)view withCallBack:(void(^)(void))callBack;


///YES:可以进入忘记交易账号界面, 默认为NO, 发请求过程中也为NO;
@property (nonatomic, assign) BOOL canGoToForgetAccountView;

/**
 获取是否可以进入忘记交易账号界面开关
 
 @param view 展示信息的view
 @param callBack 请求结束回调
 */
- (void)getForgetAccountViewStatusActionWithView:(UIView *)view withCallBack:(void(^)(void))callBack;






/**
 校验输入的交易密码
 
 @param psw 需要校验的交易密码
 @param success 校验成功
 @param failed 校验失败
 @param view 提示信息view
 */
- (void)verifyTradePasswordWithPsw:(NSString *)psw withSuccess:(void(^)(void))success withFailed:(void(^)(NSString *infor))failed withView:(UIView *)view;




/**
 交易登录后点击保存密码后的回调
 @param view 显示信息view
 @param keepResult 保存结果回调
 */
- (void)tradeLoginKeepPSWWithView:(UIView *)view withResult:(void(^)(BOOL keepSuccess, NSString *infor))keepResult;










@end

