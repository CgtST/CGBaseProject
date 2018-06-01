//
//  IBUtilsMacro.h
//  iBestStandard
//
//  Created by zscftwo on 2018/5/11.
//  Copyright © 2018年 xboker. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 功能：用户定义的全局枚举
 */


#pragma mark - 登录注册相关

/**
 *  登录凭证类型
 */
typedef NS_ENUM(NSUInteger, IBCertType){
    /**
     *  手机(App登录方式)
     */
    IBCertTypePhone = 0,
    /**
     *  邮箱
     */
    IBCertTypeEmail,
    /**
     *  微信(App登录方式)
     */
    IBCertTypeWeixin = 5,
    /**
     *  微博
     */
    IBCertTypeWeibo,
    /**
     *  QQ
     */
    IBCertTypeQQ = 4,
    /**
     *  微信UNIONID
     */
    IBCertTypeWeixinUnion,
    /**
     *  微信公众号ID
     */
    IBCertTypeWeixinOpened,

    //交易号
    IBCertTypeTrade,

    // ibest号
    IBCertTypeIBestId,    //8

    //游客
    IBCertTypeGuest = 9,
};


typedef NS_ENUM(int8_t, IBUserType) {
    IBUserTypeUnKnow, //未知
    IBUserTypeGuest,//游客
    IBUserTypeIBest,//iBest用户
};


//手机号所在区域
typedef NS_ENUM(int32_t, IBAreaType){
    IBAreaTypeLand = 1,   //大陆
    IBAreaTypeHK = 2,      //香港
    IBAreaTypeMacao = 3      //澳门
};

//交易 ，外汇 绑定手机号操作
typedef NS_ENUM(NSUInteger , IBBangType) {
    IBBangTypeTrade,  //交易绑定
    IBBangTypeFX  //外汇绑定
};


//第三方登录
typedef NS_ENUM(NSUInteger,IBLoginThirdType)
{
    IBLoginThirdTypePhone,
    IBLoginThirdTypeWechat,
    IBLoginThirdTypeQQ,
};



typedef NS_ENUM(NSUInteger ,IBThemeType) {
    IBThemeTypeQuote,
    IBThemeTypeTrade
};


/*
 设备类型 0为android
 1为ios
 2为wp
 3为PC
 */
typedef NS_ENUM(int32_t , OsType) {
    OSTypeAndroid = 0,
    OSTypeiOS  = 1,
    OSTypeWp = 2,
    OSTypePc = 3
};

#pragma mark - 行情相关

typedef  NS_ENUM(NSUInteger,IBMoneyInType)
{
    IBMoneyInTypeFX,  //外汇
    IBMoneyInTypePM  //入金
};

typedef NS_ENUM(NSUInteger,IBEIPOType) {
    IBEIPOTypeMoney, //现金申购
    IBEIPOTypeRong, //融资申购
};






#pragma mark - 语言国际化
//语言显示
typedef NS_ENUM(NSInteger, IBLanguageShowType){
    IBLanguageShowTypeSimpleChinese = 0,    //简体中文 zh-Hans
    IBLanguageShowTypeTraditionChinese,     //繁体中文 zh-Hant
    IBLanguageShowTypeEnglish              //英文     en
};


