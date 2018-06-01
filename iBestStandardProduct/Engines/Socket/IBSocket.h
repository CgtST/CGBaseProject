//
//  QNSocketSingleton.h
//  QNEngine
//
//  Created by weiheng on 15/7/28.
//  Copyright (c) 2015年 Bacai. All rights reserved.
//

#import <Foundation/Foundation.h>

//功能号
#define Function_Heartbeat                    0  //心跳
#define Function_Login                        1  //登录
#define Function_Real_time_Quotes             2  //实时行情
#define Function_Five_Leve_Sale               3  //买卖五档
#define Function_Time_Share                   4  //分时
#define Function_Share_Transaction_Details    5  //个股成交明细
#define Function_Index_Real_time_Quotes       6  //指数实时行情
#define Function_Funds_Real_time_Quotes       7  //基金实时行情
#define Function_Clear_Data                   8  //清盘
#define Function_Optional_Stock               10 //自选股
#define Function_Concept                      11 //概念推送
#define Function_Industry                     12 //行业推送
#define Function_Hot_Stock                    13 //热门个股推送
#define Function_Tape                         14 //首页大盘指数
#define Function_Market_Index                 15 //市场首页合并推送
#define Function_Optional_Portfolio           16 //自选股组合推送

//GZ Add
#define Function_Market_HKStocksPrice               17  //HKStocks
#define Function_Market_HKStocksBroker              18  //HKStocks

#define Function_Per_Deal     21  //逐笔成交（港股）
#define Function_Per_Deal_SH  22  //逐笔成交（SH）
#define Function_Per_Deal_SZ  23  //逐笔成交（SZ）
#define Function_Foreign_Exchange  24 //外汇行情



/*
 外汇的      账号信息更新
 action=15 (推送AccountInfo)
*/
#define Function_FX_Account_Infor           25


/*
 外汇的      账号设置更新推送频道名
 action=16 (推送AccountSetting:action=16)
 */
#define Function_FX_Account_Setting         26


/*
 外汇的      订单变动推送频道名_委托单
 action=20 (推送所有下单)
 */
#define Function_FX_DingDan_BianDong        27
/*
 外汇的      仓位变动推送频道名
 action=21 (推送所有仓位)
 */
#define Function_FX_CangWei_BianDong        28
/*
 外汇的      平仓推送频道名
 action=53 (推送所有平仓历史)
 */
#define Function_FX_Ping_Cang               29
/*
 外汇的      下单、改单历史记录的推送频道名
 action=51 (推送所有下单、改单历史)
 */
#define Function_FX_Order_Modify_History    30
/*
 外汇的      撤单历史记录的推送频道名
 action=52 (推送所有撤单历史)
 */
#define Function_FX_Resign_Order_History    31

/*
 外汇的      Action更新通知
 action=11 (通知APP登出)
 action=23 (订单变为开仓)
 action=24 (订单变为开仓(详细信息）)
 action=31 (推送下单)
 action=32 (改单)
 action=33 (撤单)
 action=41 (开仓)
 action=42 (改仓)
 action=43 (全平仓)
 action=44 (指定平仓)
 */
#define Function_FX_Action_GengXin          32

/*
 外汇的      Toast更新通知
action=61 (推送报错)
 */
#define Function_FX_Toast_GengXin           33

/*
 推送所有的开仓历史
action=54 (推送所有的开仓历史)
 */
#define Function_FX_All_KaiCangLiShi        34





/**
 外汇/贵金属开户时需要订阅一个频道,将推送回来的数据传递给H5--35通道
 */
#define Function_FX_PMOpenAccountGetData_35             35


/**
 外汇/贵金属开户时需要订阅一个频道,将推送回来的数据传递给H5--38通道
 */
#define Function_FX_PMOpenAccountGetData_38             38


#define kSocket_Reconnect   @"Socket_Reconnect"
#define kReal_Time_Quotes   @"Real_Time_Quotes"
#define kFive_Leve_Sale     @"Five_Leve_Sale"
#define kTime_Share         @"Time_Share"
#define kQuotes_Clear_Data  @"Quotes_Clear_Data"
#define kFunds_Real_time_Quotes @"Funds_Real_time_Quotes"
#define kIndex_Real_time_Quotes @"Index_Real_time_Quotes"
#define kOptional_Stock_Real_Time_Quotes @"Optional_Stock_Real_Time_Quotes"
#define kConcept_Real_Time_Quotes @"Concept_Real_Time_Quotes"
#define kIndustry_Real_Time_Quotes @"Industry_Real_Time_Quotes"
#define kHot_Stock_Real_Time_Quotes @"Hot_Stock_Real_Time_Quotes"
#define kTape_Real_Time_Quotes @"Tape_Real_Time_Quotes"
#define kMarket_Index_Quotes @"Market_Index_Quotes"
#define kOptional_Portfolio @"Optional_Portfolio"
#define KMarket_HKStocksPrice     @"Market_HKStocksPrice"
#define KMarket_HKStocksBroker    @"Market_HKStocksBroker"
#define KMarket_Per_Deal   @"KMarket_Per_Deal"   //逐笔成交
#define KMarket_Per_Deal_SH  @"KMarket_Per_Deal_SH"
#define KMarket_Per_Deal_SZ  @"KMarket_Per_Deal_SZ"
#define KFunction_Foreign_Exchange  @"KFunction_Foreign_Exchange"



@interface IBSocket : NSObject

@property (nonatomic, copy) NSString *channelId;

@property (nonatomic,assign) BOOL needReconnect;

-(void)socketConnectHost;// socket连接
-(void)longConnectToSocket;
-(void)cutOffSocket;// 断开socket连接
- (BOOL)isConnected;

@end
