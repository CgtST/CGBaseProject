//
//  IBUrl.h
//  iBestStandard
//
//  Created by bingo on 2018/5/15.
//  Copyright © 2018年 xboker. All rights reserved.
//


/***************** READ ME **********************
 * @brief   url 地址类
 *
 ***********************************************/


#import <Foundation/Foundation.h>


#define WIDGET_GROUP_ID  @"group.com.iBest.stockAppAS"
///当前APP版本, 业务办理界面区分版本用;    禁止修改!
#define NOW_APP_VERSION             1
///H5的测试环境;     禁止修改!
#define IS_H5_TEST_ENVIRONMENT      0
///是否是665的测试环境1:是665的测试环境; 0:正常流程的
#define IS_665_TEST_ENVIRONMENT     0


#pragma mark           ==================分割线===============
/*
 ENVIRONMENT                      1:生产环境
 2:开发环境
 3:测试环境
 */




#define       ENVIRONMENT         3







///上线环境设置
#if ENVIRONMENT  == 1
//交易登录是否关闭账号切换 测试：YES  生产：NO
#define  IBTRADELOGINENABLEFLAG NO
//环信相关生产
#define HXKF_APP_KEY            @"1154170721178511#kefuchannelapp28253"
#define HXKF_TENANTID           @"YXA6TlZgQG4dEeejcO_oG8ZVXQ"
#define HXKF_CLIENT_SECRET      @"YXA6cPKvJlVcKSthcr0Mi_SWgOCXkgQ"
#define HXKF_IM_SERVER_NUM      @"kefuchannelimid_156437"
#define HXKF_GROUP              @"1154170721178511"
#define HXKF_APP_NAME           @"kefuchannelapp28253"
//APP设置
#define IB_BASE_DOMAIN          @"a.ibestfinance.com"
#define IB_IP_ADDRESS           @"a.ibestfinance.com"
#define IB_SOCKET_HOST          @"a.ibestfinance.com"
#define IB_FX_ADDRESS           @"a.ibestfinance.com"
//#define IB_FX_ADDRESS           @"120.77.127.104"

#define IB_SOCKET_PORT          9002
#define IB_BASE_URL             @"https://" IB_BASE_DOMAIN
#define IB_SSL_BASE_URL         @"https://" IB_BASE_DOMAIN
#define IB_FX_ADDRESS_BASE_URL  @"https://" IB_FX_ADDRESS
#define HTTP_PROTOCOL_VERSION   [IBGlobalMethod getProjectVersion]
//打开外汇，贵金属正常绑定逻辑 0 是打开；1是绕行
#define OPEN_BLIND_ENVIRONMENT      0
///证券交易本地计时
#define k_StockTimeCount             [IBTheme() getLockScreenTime]


///开发环境设置
#elif ENVIRONMENT  == 2
//交易登录是否关闭账号切换 测试：YES  生产：NO
#define  IBTRADELOGINENABLEFLAG YES
////环信相关测试
#define HXKF_APP_KEY            @"1122170524115993#kefuchannelapp41688"
#define HXKF_TENANTID           @"41688"
#define HXKF_CLIENT_SECRET      @"YXA6_vVGgBbBLTpV1NfWySwMjZER-lg"
#define HXKF_IM_SERVER_NUM      @"kefuchannelimid_875585"
#define HXKF_GROUP              @"1122170524115993"
#define HXKF_APP_NAME           @"kefuchannelapp41688"
//APP设置
#define IB_BASE_DOMAIN          @"120.77.127.104"
#define IB_IP_ADDRESS           @"120.77.127.104"
#define IB_SOCKET_HOST          @"120.77.127.104"
#define IB_FX_ADDRESS           @"39.108.11.106"
//#define IB_FX_ADDRESS           @"120.77.127.104"


#define IB_SOCKET_PORT          9002
#define IB_BASE_URL             @"http://" IB_BASE_DOMAIN
#define IB_SSL_BASE_URL         @"http://" IB_BASE_DOMAIN
#define IB_FX_ADDRESS_BASE_URL  @"http://" IB_FX_ADDRESS

#define HTTP_PROTOCOL_VERSION   [IBGlobalMethod getProjectVersion]
//打开外汇，贵金属正常绑定逻辑  0 是打开；1是绕行
#define OPEN_BLIND_ENVIRONMENT      0
///证券交易本地计时
#define k_StockTimeCount             [IBTheme() getLockScreenTime]


///测试环境设置
#elif ENVIRONMENT  == 3
//交易登录是否关闭账号切换 测试：YES  生产：NO
#define  IBTRADELOGINENABLEFLAG YES
////环信相关测试
#define HXKF_APP_KEY            @"1122170524115993#kefuchannelapp41688"
#define HXKF_TENANTID           @"41688"
#define HXKF_CLIENT_SECRET      @"YXA6_vVGgBbBLTpV1NfWySwMjZER-lg"
#define HXKF_IM_SERVER_NUM      @"kefuchannelimid_875585"
#define HXKF_GROUP              @"1122170524115993"
#define HXKF_APP_NAME           @"kefuchannelapp41688"
//APP设置
#define IB_BASE_DOMAIN          @"39.108.11.106"
#define IB_IP_ADDRESS           @"39.108.11.106"
#define IB_SOCKET_HOST          @"120.77.127.104"
//#define IB_SOCKET_HOST          @"10.200.6.5"  //红歌主机 test
#define IB_FX_ADDRESS           @"39.108.11.106"

#define IB_SOCKET_PORT          9002
#define IB_BASE_URL             @"http://" IB_BASE_DOMAIN
#define IB_SSL_BASE_URL         @"http://" IB_BASE_DOMAIN
#define IB_FX_ADDRESS_BASE_URL  @"http://" IB_FX_ADDRESS

#define HTTP_PROTOCOL_VERSION   [IBGlobalMethod getProjectVersion]

//打开外汇，贵金属正常绑定逻辑  0 是打开；1是绕行
#define OPEN_BLIND_ENVIRONMENT      0
///证券交易本地计时
#define k_StockTimeCount             [IBTheme() getLockScreenTime]
//#define k_StockTimeCount            20


///待定
#else
//交易登录是否关闭账号切换 测试：YES  生产：NO
#define  IBTRADELOGINENABLEFLAG YES
////环信相关测试
#define HXKF_APP_KEY            @"1122170524115993#kefuchannelapp41688"
#define HXKF_TENANTID           @"41688"
#define HXKF_CLIENT_SECRET      @"YXA6_vVGgBbBLTpV1NfWySwMjZER-lg"
#define HXKF_IM_SERVER_NUM      @"kefuchannelimid_875585"
#define HXKF_GROUP              @"1122170524115993"
#define HXKF_APP_NAME           @"kefuchannelapp41688"
//APP设置
#define IB_BASE_DOMAIN          @"120.77.127.104"
#define IB_IP_ADDRESS           @"120.77.127.104"
#define IB_SOCKET_HOST          @"120.77.127.104"
#define IB_FX_ADDRESS           @"39.108.11.106"
//#define IB_FX_ADDRESS           @"120.77.127.104"

#define IB_SOCKET_PORT          9002
#define IB_BASE_URL             @"http://" IB_BASE_DOMAIN
#define IB_SSL_BASE_URL         @"http://" IB_BASE_DOMAIN
#define IB_FX_ADDRESS_BASE_URL  @"http://" IB_FX_ADDRESS

#define HTTP_PROTOCOL_VERSION    [IBGlobalMethod getProjectVersion]
//打开外汇，贵金属正常绑定逻辑  0 是打开；1是绕行
#define OPEN_BLIND_ENVIRONMENT      1

#endif



#pragma mark           ==================分割线===============

////外汇行情
//#define IB_FX_Quote_BASE_URL   [NSURL URLWithString:@"" IB_SSL_BASE_URL@":9013/mfinance_api/"]
//ibest交易url
#define IB_SHARE_TRADE_BASE_URL    [NSURL URLWithString:@"" IB_SSL_BASE_URL@":9008/ibTrade/"]
//立即开户URL
#define IB_GET_TRADE_ACCOUND_URL   [NSURL URLWithString:@"" IB_SSL_BASE_URL@":9009/eform/"]
///外汇根目录接口
#define IB_FINANCIAL_SSL_BASE_URL  [NSURL URLWithString:@"" IB_FX_ADDRESS_BASE_URL@":9013/mfinance_api/"]
///开户时的路径
#define IB_HAVE_OPEN_ACCOUNT_SSL_BASE_URL  [NSURL URLWithString:@"" IB_BASE_URL@":9009/hsOpenAccount/"]


#define IB_SSL_USER_BASE_URL    [NSURL URLWithString:@"" IB_SSL_BASE_URL@":9000/user_api/"]
#define IB_SSL_QUOTE_BASE_URL   [NSURL URLWithString:@"" IB_SSL_BASE_URL@":9001/mktinfo_api/"]
#define IB_SSL_COMMON_BASE_URL  [NSURL URLWithString:@"" IB_SSL_BASE_URL@":9000/common_api/"]



