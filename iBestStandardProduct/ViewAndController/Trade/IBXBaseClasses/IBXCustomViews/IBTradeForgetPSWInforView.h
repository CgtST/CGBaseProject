//
//  IBTradeForgetPSWInforView.h
//  iBestProduct
//  激活账户时, 弹窗提示账户激活的view  ----可以拨打电话
//  Created by xboker on 2017/8/30.
//  Copyright © 2017年 iBest. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, InforViewType) {
    ///提示账户激活, 验证交易账号状态为ISSUE
    InforViewTypeActiveInfor_ISSUE,
    ///提示账户激活, 验证交易账号状态为SUSPENDED
    InforViewTypeActiveInfor_SUSPENDED,
    ///重要提示, 提示入股选错则会激活码失效
    InforViewTypeImportantInfor,
    ///点击进入忘记密码界面时提示不能进入界面
    InforViewTypeCanNotInForgetPSWView,
    ///点击进入忘记账户界面时提示不能进入界面
    InforViewTypeCanNotInForgetAccountView,
    ///交易登录验证码连续验证错误6次后账号被锁提示
    InforViewTypeTLVerifyCodeExcessSixTimesAccountLocked,
    ///外汇绑定交易账号 没有手机号提示
    InforViewType_FX_Bind_HaveNoPhone_Infor,
    ///贵金属忘记密码提示框
    InforViewType_PM_ForgetPSW_Infor,
    ///外汇忘记密码提示框
    InforViewType_FX_ForgetPSW_Infor,
    
    //贵金属，外汇绑定手机号码不一致时提示
    InforViewType_FX_PM_Binding_Infor,
    ///当SUSPEND账户不属于某个分组时是不能重设密码的
    InforViewType_SUSPENDED_CAN_NOT_FINDBACK,
    
};


typedef void(^DiaNum)(NSString *num);
typedef void(^ActiveAccount)(void);

@interface IBTradeForgetPSWInforView : UIView


/**
 账户激活, 密码找回时的一种弹窗

 @param DiaNum 点击拨打电话号码的回调
 @param activeAccount 点击"确定"的回调
 @param type 弹出框的类型
 @param inforDic 传入展示信息内容
 */
+ (void)showViewWithDial:(DiaNum)diaNum withConfirm:(ActiveAccount)activeAccount withType:(InforViewType)type withInfor:(NSDictionary *)inforDic;
+ (void)hideView;



@end
