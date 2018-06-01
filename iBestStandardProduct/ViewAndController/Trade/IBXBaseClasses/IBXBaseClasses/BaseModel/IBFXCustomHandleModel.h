//
//  IBFXCustomHandleModel.h
//  iBestProduct
//  外汇或者贵金属相关的通用发送请求处理模型
//  Created by xboker on 2018/1/5.
//  Copyright © 2018年 iBest. All rights reserved.
//

//此类禁止创建!!!!!--直接用   ibFXHandler()



#import "IBBaseHttpClient.h"


typedef void(^openAccountSubscribeB) (NSDictionary *subscribeDic);
typedef void(^openAccountSubscribeB2) (NSDictionary *subscribeDic2);




@interface IBFXCustomHandleModel : IBBaseHttpClient

///外汇版本交易首页当前的index
//@property (nonatomic, assign)  NSInteger    m_TradeHomeIndex;


//获取系统配置信息 pm 的json文件 moduleName :mfinace ; key:sliver_gold_cfg;
-(void)ibFXGetSysCfgWithView:(UIView *)view;
/*
///外汇socket重连后 检测是否需要重新登录
- (void)ibFXCheckAccountNeedLoginWithView:(UIView *)view withController:(UIViewController *)controller withBlock:(void(^)(BOOL need))block;

///贵金属socket重连后 检测是否需要重新登录
- (void)ibPMCheckAccountNeedLoginWithView:(UIView *)view withController:(UIViewController *)controller withBlock:(void(^)(BOOL need))block;


///外汇订阅
- (void)fx_SubscribeActionWithView:(UIView *)view;
///贵金属订阅
- (void)pm_SubscribeActionWithView:(UIView *)view;

///订阅所有
- (void)fx_pm_SubscribeAllWithView:(UIView *)view;

///外汇/贵金属开户时需要的订阅
- (void)openAccountSubscribeWithView:(UIView *)view;





 //开仓, 改仓, 订单->持仓时, 调用接口重新获取所有的仓位
 //0: 外汇,   1: 贵金属
 //
- (void)getAllCangWeiWithType:(NSInteger)type;




//外汇/贵金属显示出来安全须知弹窗, 点击确认下次是否继续显示
//param type 1:MF 2:PM  3:MF_DEMO  4:PM_DEMO
//
- (void)getNotShowSafeInstructionsAgainWithType:(NSInteger)type withView:(UIView *)view;


///外汇/贵金属开户时传递给H5时分两次--第一次
@property (nonatomic, copy) openAccountSubscribeB   subscribeB;
- (void)getOpenAccountSubscribeWithB:(openAccountSubscribeB)subscribeB;

///外汇/贵金属开户时传递给H5时分两次--第二次
@property (nonatomic, copy) openAccountSubscribeB2   subscribeB2;
- (void)getOpenAccountSubscribeWithB2:(openAccountSubscribeB2)subscribeB2;

*/








@end
