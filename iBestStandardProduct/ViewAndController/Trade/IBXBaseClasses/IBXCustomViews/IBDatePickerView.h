//
//  IBDatePickerView.h
//  iBestProduct
//  一个选择日期的view
//  Created by xboker on 2017/6/30.
//  Copyright © 2017年 iBest. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CallBackDateBlock)(NSString *getDateStr, NSDate *getDate);

///查询类相关, 历史成交一年规则: 今天2017/6/30->可选范围 2016/6/30--2017/6/29; 其他的历史, 可查询今天
typedef NS_ENUM(NSInteger, IBChooseDateType) {
    ///可以随意滚动的类型-基准当前时间为[NSDate date]
    IBChooseDateTypeAllDate = 0,
    ////历史成交-基准时间为系统时间
    IBChooseDateTypeDealRecord,
    ///资金流水-基准时间为系统时间
    IBChooseDateTypeMoneyAccessRecord,
    ///股票转仓记录-基准时间未系统时间
    IBChooseDateTypeStockTransferRecord,
    ///激活交易账户时选择出生日期
    IBChooseDateTypeTradeActiveChooseBirthday,
    ///股票存入时选择日期
    IBChooseDateTypeStockTransferIn,
    ///股票转出时选择日期
    IBChooseDateTypeStockTransferOut,
    ///找回交易账户选择日期
    IBChooseDateTypeTradeForgetAccount,
    ///外汇平仓历史
    IBChooseDateTypeFX_PingCang_History,
    ///外汇委托历史
    IBChooseDateTypeFX_WeiTuo_History,
};


@interface IBDatePickerView : UIView



/**
 显示选择日期的View
 
 @param type 显示, 以及可选日期的类型
 @param callBack 选择到的日期字符串以及日期
 @param nowDate  时间采用系统时间, 如果获取不到系统时间,采用[NSDate date]
 */
+ (void)showDatePickerViewWithType:(IBChooseDateType)type withCallBack:(CallBackDateBlock)callBack WithNowDate:(NSDate *)nowDate;


/**
 隐藏选择日期View
 */
+ (void)hideDatePickView;


@end
