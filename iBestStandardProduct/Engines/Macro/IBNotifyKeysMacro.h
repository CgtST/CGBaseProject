//
//  IBNotifyKeysMacro.h
//  iBestStandard
//
//  Created by bingo on 2018/5/15.
//  Copyright © 2018年 xboker. All rights reserved.
//


/*
    添加 通知类key 
 */


#import <Foundation/Foundation.h>




#define VERIFYCODEVALIDITY    60 //短信验证码的倒计时时间
#define kNotifyRedIncreaseChange   @"kNotifyRedIncreaseChange"
#define Quote_PankouShow   @"quote_pankou_show"
#define G_GestPlistName  @"guestPlist"







#pragma mark    本地化存储准则
///iBEST登录后返回的CLientID在Mine界面显示用
static NSString *const TradeClientID                                              = @"TradeClientID";

/// 登录成功后将登录的交易账号本地化---另外:iBEST登录后返回此字段的值作为有没有绑定交易账号的准则
static NSString *const TradeLoginAccount                                          =  @"tradeAccount";

///存在归档中的一个标志符, 如果能用它取到交易用户的信息,则认为已经登录--登录的信息包
static NSString *const TradeLogin                                                 = @"TradeInforDic__TradeInforDic";

///交易的子账号
static NSString *const TradeSonAccounts                                           = @"TradeSonAccounts";

///存入一个标志, 确认下次交易登录是否弹窗显示提示语
static NSString *const  TradeLoginInforFlag                                       = @"TradeLoginInforFlag";






#pragma mark    本地化存储准则

#define PM_Config_Plist  @"iBPMConfigPlist.json"


#pragma mark    第一次安装app操作指引专用key值
///首页操作指引所用标志1
static NSString *const OperationGuide_Home1                                         = @"OperationGuide_Home1";
///首页操作指引所用标志2
static NSString *const OperationGuide_Home2                                         = @"OperationGuide_Home2";
////自选股首页操作指引所用标志
static NSString *const OperationGuide_SelfChooseStock                               = @"OperationGuide_SelfChooseStock";
///行情-港股-点击查看更多板块操作指引
static NSString *const OperationGuide_Quote_HK_LookMorePlate                        = @"OperationGuide_Quote_HK_LookMorePlate";
///行情个股详情-竖屏时K线操作指引
static NSString *const OPerationGuide_Quote_K_ShuPing                               = @"OPerationGuide_Quote_K_ShuPing";
///行情个股详情-横屏时K线操作指引
static NSString *const OPerationGuide_Quote_K_HengPing                              = @"OPerationGuide_Quote_K_HengPing";
#pragma mark    第一次安装app操作指引专用key值




#pragma mark    StoryBoard专用key值
///忘记交易密码
static NSString *const  Storyboard_ForgetPSW                                        = @"ForgetPSW";
///交易相关
static NSString *const  Storyboard_TradeDeal                                        = @"TradeDeal";
///交易首页以及交易密码相关
static NSString *const  Storyboard_TradeMain                                        = @"TradeMain";
///一些通用界面所在位置
static NSString *const  Storyboard_Custom                                           = @"Custom";
///个人中心用的storyboard
static NSString *const  Storyboard_PersonalCenter                                   = @"PersonalCenter";
///忘记交易账户的storyboard
static NSString *const  Storyboard_TradeForgetAccount                               = @"ForgetAccount";
///交易(包含外汇)首页的storyBoard
static NSString *const  Storyboard_FX_TradeHome                                     = @"TradeHome";
///外汇交易下改撤单相关的storyBoard
static NSString *const  Storyboard_FX_TradeDeal                                     = @"FXDealAbout";
///外汇通用storyBoard
static NSString *const Storyboard_FX_Custom                                         = @"FXCustom";
///外汇交易改单, 撤单相关的storyBoard
static NSString *const Storyboard_FX_Modify                                         = @"FXDealModify";
///外汇交易绑定相关
static NSString *const Storyboard_FX_Bind                                           = @"FXBindAbout";
///外汇, 贵金属修改密码
static NSString *const Storyboard_FX_Change_PSW                                     = @"FXChangePSW";
///外汇/ 贵金属开户
static NSString *const Storyboard_FX_Open_Account                                   = @"FXPMOpenAccount";




#pragma mark    StoryBoard专用key值





///通用全局static字符串

///证券交易首页刷新数据
static NSString *TradeHomeReloadData                                                 = @"TradeHomeReloadData";

////刷新tableView或者collectionView
static NSString *const ReloadDataAction                                             = @"ReloadDataAction";
///股票转仓--描述/券商
//static NSString *const TradeStockTransferStockDes                                 = @"TradeStockTransferStockDes";
///股票转仓--所有添加股票-描述/券商--股票转入
static NSString *const TradeBusinessTransferStockAction_In                            = @"TradeBusinessTransferStockAction_In";
///股票转仓--所有添加股票-描述/券商--股票转出
static NSString *const TradeBusinessTransferStockAction_Out                           = @"TradeBusinessTransferStockAction_Out";





///交易登录成功--登录成功后续操作
static NSString *const TradeLoginSuccess                                          = @"TradeLoginSuccess";
///交易成功--有海通logo的登录界面, 用在交易首页传统登录时
static NSString *const TradeLoginCustomSuccess                                    = @"TradeLoginCustomSuccess";

///交易退出登录成功
static NSString *const TradeLoginOutSuccess                                       = @"TradeLoginOutSuccess";




///交易登录已经过期,发消息通知
static NSString *const TradeLoginHaveTimeOut                                      = @"TradeLoginHaveTimeOut";
///交易登录超时后弹出登录取消登录
static NSString *const TradeLoginCancled                                          = @"TradeLoginCancled";

/////基类里面交易登录超时时取消登录
//static NSString *const TradeBaseLoginCancled                                      = @"TradeBaseLoginCancled";





////当持仓列表获取成功后,将(未实现浮盈  当日总浮盈)发送给首页展示
static NSString *const TradeChiCangGetSuccess                                     = @"TradeChiCangGetSuccess";

///买卖界面每当参数有变化时更新参数集合
static NSString *const TradeDealParaChange                                        = @"TradeDealParaChange";

///改单界面, 股票价格有变动
static NSString *const  TradeModifyOrderPriceChange                               = @"TradeModifyOrderPriceChange";
///改单界面, 股票的数量有变动
static NSString *const  TradeModifyOrderCountChange                               = @"TradeModifyOrderCountChange";




///请求中error中信息包的取提示信息key值
static NSString *const  REQUEST_ERROR_INFOR_KEY                                    = @"com.yiqiniu.kHttpResponseMessage";

///如果是点击远程推送消息启动APP时发送通知, 将推送消息发送
static NSString *const  RemotePushLaunchAPP                                         = @"RemotePushLaunchAPP";

///如果有推送消息过来后, 立即更新首页以及个人中心的小红点
static NSString *const  RemoteMessageComing                                         = @"RemoteMessageComing";

///首页点击...跳转到资讯->市场动态
static NSString *const  HomeJumpToMarketInfor                                       = @"HomeJumpToMarketInfor";


///每次点击tab切换到交易首页时刷新持仓和资产数据
static NSString *const TouchTabSwitchToTradeHome                                    = @"TouchTabSwitchToTradeHome";



#pragma mark    下单界面专用通知
///下单界面专用
//订单价格更改
static NSString *const  TradeOrderPriceChange                                       = @"TradeOrderPriceChange";
///数量更改时更新订单价格UI
static NSString *const  TradeCountChange                                            = @"TradeCountPriceChange";
///价格更改时更新订单UI
static NSString *const  TradePriceChange                                            = @"TradePriceChange";
///实时推送回来的市场的行情
static NSString *const  TradeStockMarketInfor                                       = @"TradeStockMarketInfor";
///键盘应该弹出了
static NSString *const  TradeKeyBoardShouldAppear                                   = @"TradeKeyBoardShouldAppear";
///获取购买力成功
static NSString *const  TradeBuyPowerGetSuccess                                     = @"TradeBuyPowerGetSuccess";


#pragma mark    撤改单界面推送
///撤改单界面中, 推送行情
static NSString *const   TradeChangeResignOrder                                     = @"TradeResignChangeOrder";


///修改自选股时发送通知
static NSString *const   OptionalStockChanged                                       = @"OptionalStockChanged";



#pragma mark    外汇相关界面key值
///外汇第一次登录后将仓位信息推送回来, 本地处理添加完后,需要将界面刷新下
static NSString *const   FX_Home_Position_Handle_Over                                     = @"FX_Home_Position_Handle_Over";
///外汇第一次登录后将委托仓位信息推送回来, 本地处理添加完后,需要将界面刷新下
static NSString *const   FX_Home_Order_Infor_Handle_Over                                  = @"FX_Home_Order_Infor_Handle_Over";

///每次行情的价格更新后发通知 进行刷新---预废弃
static NSString *const   FX_Quote_PriceAbout_Changed                                      = @"FX_Quote_PriceAbout_Changed";
///外汇下单界面判断能否点击下单按钮
static NSString *const   FX_Deal_JudgeWhetherCanDeal                                       = @"FX_Deal_JudgeWhetherCanDeal";
///外汇下单后, TCP推送结果来到---预废弃
static NSString *const  FX_Deal_Order_TCP_DataPush                                        = @"FX_Deal_Order_TCP_DataPush";
///外汇改单/改仓界面任何参数进行修改
static NSString *const  FX_Modify_Parameters_Change                                       = @"FX_Modify_Parameters_Change";
///外汇获取到平仓历史
static NSString *const  FX_Handle_PingCang_History_Over                                   = @"FX_Handle_PingCang_History_Over";
///外汇获取到委托历史
static NSString *const  FX_Handle_WeiTuo_History_Over                                     = @"FX_Handle_WeiTuo_History_Over";
///外汇绑定好外汇账号后发送通知, 重新布局
static NSString *const  FX_Bind_Account_Success                                           = @"FX_Bind_Account_Success";
///点击外汇行情某处后跳转到外汇交易首页
static NSString *const  FX_Jump_To_Trade_Home                                             = @"FX_Jump_To_Trade_Home";
///FX/PM的32频道推送通知用户重新登录相关账号
static NSString *const  FX_PM_Infor_ReLogin                                               = @"FX_PM_Infor_ReLogin";




///贵金属获取到平仓历史
static NSString *const  PM_Handle_PingCang_History_Over                                   = @"PM_Handle_PingCang_History_Over";
///贵金属获取到委托历史
static NSString *const  PM_Handle_WeiTuo_History_Over                                     = @"PM_Handle_WeiTuo_History_Over";
///贵金属第一次登录后将委托仓位信息推送回来, 本地处理添加完后,需要将界面刷新下(以及32频11推送需要重新登录时仍然采用此广播)
static NSString *const  PM_Home_Order_Infor_Handle_Over                                  = @"PM_Home_Order_Infor_Handle_Over";
///贵金属第一次登录后将仓位信息推送回来, 本地处理添加完后,需要将界面刷新下
static NSString *const   PM_Home_Position_Handle_Over                                     = @"PM_Home_Position_Handle_Over";
///贵金属绑定好外汇账号后发送通知, 重新布局
static NSString *const   PM_Bind_Account_Success                                           = @"PM_Bind_Account_Success";
///贵金属每次行情的价格更新后发通知 进行刷新--预废弃
static NSString *const   PM_Quote_PriceAbout_Changed                                      = @"PM_Quote_PriceAbout_Changed";
////外汇首页刷新(例如:切换仓位总结状态完成了, 刷新下)
static NSString *const   FX_ReloadTheTableView                                           = @"FX_ReloadTheTableView";
////贵金属首页刷新(例如:切换仓位总结状态完成了, 刷新下)
static NSString *const   PM_ReloadTheTableView                                           = @"PM_ReloadTheTableView";

///外汇账户信息更新, 通道推送过来账户信息,处理完后发送通知
static NSString *const   FX_AccountInforReload                                          = @"FX_AccountInforReload";
///贵金属账户信息更新,  通道推送过来账户信息,处理完后发送通知
static NSString *const   PM_AccountInforReload                                          = @"PM_AccountInforReload";



///外汇退出登录
static NSString *const   FX_LoginOut                                                       = @"FX_LoginOut";
///贵金属退出登录
static NSString *const   PM_LoginOut                                                       = @"PM_LoginOut";





///外汇登录http请求超时后刷新相关页面




//----------通过股票模型封装的字典key值
///股票代码
static NSString *const  STOCKID_STOCKID                                              = @"STOCKIDSTOCKID";
//.股票代码+HK.eg
static NSString *const  STOCKIDPLUS_STOCKIDPLUS                                      = @"STOCKIDPLUSSTOCKIDPLUS";
///股票数量
static NSString *const  STOCKCOUNT_STOCKCOUNT                                        = @"SOTCKCOUNTSOTCKCOUNT";
///股票名称
static NSString *const  STOCKNAME_STOCKNAME                                          = @"STOCKNAMESTOCKNAME";
///股票的类型
static NSString *const  STOCKTYPE_STOCKTYPE                                          = @"STOCKTYPESTOCKTYPE";



#pragma mark    专用的缓存key区
///首页的缓存key
///首页的轮播图数据缓存
static NSString *const  CacheHomeTurnImage                                           = @"CacheHomeTurnImage";
///首页的市场动态的缓存
static NSString *const  CacheHomeShiChangDongTai                                     = @"CacheHomeShiChangDongTai";
///首页的财富资讯缓存
static NSString *const  CacheHomeCaiFuZiXun                                          = @"CacheHomeCaiFuZiXun";
///首页的热门咨询缓存
static NSString *const  CacheHomeReMenChanPin                                        = @"CacheHomeReMenChanPin";
///首页的自选股缓存
static NSString *const  CacheSelfChooseStock                                         = @"CacheSelfChooseStock";
///首页的股票评级
static NSString *const  CacheStockLevelRate                                          = @"CacheStockLevelRate";

static NSString *const kHttpResponseCode       = @"kHttpResponseCode";
static NSString *const kHttpResponseMessage    = @"kHttpResponseMessage";
static NSString *const kHttpResponseResult     = @"kHttpResponseResult";
static NSString *const kQNCommonErrorFromServerNotify                       = @"kIBCommonErrorFromServerNotify";

///读取过的新闻ID缓存起来, 展示的时候其背景变为灰色
static NSString *const  CacheReadedNews                                              = @"CacheReadedNews";

#pragma mark - 登录成功，失败通知

#define  kIBNotify_Login_Success        @"IB_Notify_Login_Success"
#define  kIBNotify_Logout_Success       @"IB_Notify_Logout_Success"
