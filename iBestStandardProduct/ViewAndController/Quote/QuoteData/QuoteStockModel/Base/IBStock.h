//
//  IBStock.h
//  iBestStandard
//
//  Created by bingo on 2018/5/15.
//  Copyright © 2018年 iBest. All rights reserved.
//

#import "IBBaseStock.h"

@interface IBStock : IBBaseStock


///数据请求时作为股票ID的参数后面不带HK例如:00665.HK  -> 00665
@property (nonatomic, strong) NSString *STOCKID;
///marketCode对比下面的 MicCode
///XHKG: 港股  XSSC：沪股通   XSEC：深股通--属于哪个股票以这个为准则
@property (nonatomic, strong) NSString *MarketCode;


///XHKG: 港股  XSSC：沪股通   XSEC：深股通--属于哪个股票以这个为准则
@property (nonatomic, strong) NSString *MicCode;
///每手数
@property (nonatomic,strong) NSString * uintStockNum;




@property(nonatomic,assign) uint8_t marketID;
@property(nonatomic,assign)uint8_t ah; /*AH 为2的股票后缀一定为SH,为3的后缀一定为SZ
                                        1和4的股票后缀为HK
                                        2-沪股通 表示上海的股票，可以在港交所买卖
                                        3-深股通 表示深圳的股票，可以在港交所买卖
                                        1-港股通(沪) 表示香港的股票，可以在上海交易所买卖
                                        4--港股通（深）表示香港的股票，可以在深圳交易所买卖
                                        pub.db新增字段- AH -- AH: 标示沪港股通，深港股通  1-港股通(沪)   2-沪股通 3-深股通，4-港股通（深）*/

@property(nonatomic,assign) int64_t listingTime;   // 上市日期，0表示没有确切上市日，一些指数或者板块常常是0
@property(nonatomic,strong) NSString *code;
@property(nonatomic,strong) NSString *enName;
@property(nonatomic,strong) NSString *cnName;
@property(nonatomic,strong) NSString *hkName;
@property(nonatomic,assign) uint32_t unit;
@property(nonatomic,strong) NSString *keywords;


@property(nonatomic,assign) float lastClosePrice;
@property(nonatomic,copy) NSString* price;
@property(nonatomic,assign) float change;
@property(nonatomic,assign) float percent;

@property(nonatomic,copy)   NSString *hldPrc; //成本
@property(nonatomic,assign) double hldYld; //个股涨跌幅(盈亏比例)

@property(nonatomic,strong,readonly) NSString *symbol;

#pragma mark - QUOTE INFO
/* 市盈率  */
@property(nonatomic,assign) double peRatio;
/* 市净率  */
@property(nonatomic,assign) double pbRatio;
/* 相关度  */
@property(nonatomic,assign) int8_t corrValue;
@property(nonatomic,assign,readonly) int8_t corr;
/* 市值    */
@property(nonatomic,assign) double mktValue;
/* 流通市值 */
@property(nonatomic,assign) double fMktValue;
/* 每股收益 */
@property(nonatomic,assign) double eps;
/* 净资产   */
@property(nonatomic,assign) double pes;
/* 交易状态 */
@property(nonatomic,assign) IBStockTradeStatus status;
@property(nonatomic,strong,readonly) NSString *statusDesc;
@property(nonatomic,strong) NSString *simpleStatusDesc;
#pragma mark - Option
/* 财报时间 */
@property(nonatomic,strong) NSString *reportTime;
/* 简介    */
@property(nonatomic,strong) NSString *profile;
/* 相关概念 */
@property(nonatomic,strong) NSString *relatedConcept;
/*资产的类型*/
@property(nonatomic,copy)   NSString *type;

///股票类型----为4的时候是指数(不能交易)
@property (nonatomic, copy) NSString *stype;       //股票类型
/*是否已添加进自选*/
@property(nonatomic,assign) BOOL added;
/*是否添加进搜索历史*/
@property(nonatomic,assign) BOOL history;

#pragma mark -
@property(nonatomic,assign) IBStockListingStatus listingStatus;
@property(nonatomic,assign) BOOL isTradable;
@property(nonatomic,assign) BOOL suspended;
@property(nonatomic,assign) BOOL delisted;
@property(nonatomic,assign,readonly) BOOL enableJoinPortfolio;


/* use to update DB */
@property(nonatomic,assign) BOOL shouldDelete;

@property (nonatomic,strong) NSString *volume;


- (void)decodeWebDic:(NSDictionary *)dic;
- (void)decodeStockListDic:(NSDictionary *)dic;


@end
