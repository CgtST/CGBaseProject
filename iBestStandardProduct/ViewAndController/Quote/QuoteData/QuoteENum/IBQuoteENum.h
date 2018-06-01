//
//  IBQuoteENum.h
//  iBestStandard
//
//  Created by bingo on 2018/5/15.
//  Copyright © 2018年 xboker. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  股票状态
 */
typedef NS_ENUM(int8_t, IBStockTradeStatus){

    IBStockTradeStatusUnknow    = -1, //未知状态
    IBStockTradeStatusNormal    = 0, //正常
    IBStockTradeStatusLimitUp   = 1,  //涨停
    IBStockTradeStatusLimitDown = 2, //跌停
    IBStockTradeStatusSuspend   = 3, // 停牌
    IBStockTradeStatusDelisted  = 4, //退市
    IBStockTradeStatusIPO       = 5  // 未上市
};


/** 股票类型 **/
typedef NS_ENUM(NSInteger, IBStockType){
    IBStockTypeNone,
    IBStockTypeBond,    //债券
    IBStockTypeBwrt,    //一揽子权证
    IBStockTypeEqty,    //正股1
    IBStockTypeTrust,   //信托
    IBStockTypeWarrant, //窝轮
    IBStockTypeIndex,   //指数 比如 800000.HK 恒生指数
    IBStockTypePlate,   //板块
};

/** 市场状态 **/
typedef NS_ENUM(int8_t, IBQuoteMarketStatus) {
    IBQuoteMarketStatusUnknow = -1,
    IBQuoteMarketStatusHolidayOff = 0,
    IBQuoteMarketStatusBeforeOpen = 1,
    IBQuoteMarketStatusOpen,
    IBQuoteMarketStatusNoonRest,
    IBQuoteMarketStatusClose
};

/** 股票市场类型 **/
typedef NS_ENUM (NSInteger, IBStockMarketType){
    IBStockMarketTypeNone,
    IBStockMarketTypeHongKong,
    IBStockMarketTypeUnitedStates,
    IBStockMarketTypeChina,
    IBStockMarketTypeChinaSH,
    IBStockMarketTypeChinaSZ
};


/** 股票上市类型 **/
typedef NS_ENUM(int8_t, IBStockListingStatus) {
    IBStockListingStatusUnListing = 0,
    IBStockListingStatusListed = 1,
    IBStockListingStatusDelisted = 2
};



