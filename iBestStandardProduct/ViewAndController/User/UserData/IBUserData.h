//
//  IBUserData.h
//  iBestStandard
//
//  Created by bingo on 2018/5/16.
//  Copyright © 2018年 iBest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IBUserData : NSObject

/* 用户的唯一索引 */
//userId
@property (nonatomic, assign) int64_t ID;
@property (nonatomic) IBUserType userType;


@property (nonatomic)IBLoginThirdType ibThirdType;

@property (nonatomic,strong) NSString * userFlag; //1: 见证人 0:开户
@property (nonatomic,strong) NSString *  mfTradeAccount;  //外汇账号
@property (nonatomic,strong) NSString *  pmTradeAccount;  //贵金属账号
@property (nonatomic,strong) NSString *  tradeAccount; //股票交易账号
@property (nonatomic, strong) NSString *phoneNumber;//手机


@property (nonatomic) long contryCode;//1:大陆 2:香港 3：澳门
@property (nonatomic,copy)NSString * isLevelTwo;  //是否是level 2行情  0 NO,1 yes
@property (nonatomic,copy)NSString * inviteCode;  //邀请码
@property (nonatomic) BOOL bLogin;  //0 代表已登录  1 未登录

@property (nonatomic) BOOL isThirdPartLogin; //是否是第三方登录
@property (nonatomic,copy) NSString * quotePassword; //行情登录密码


@property (nonatomic, strong) NSString *imId;        /**< 环信用户名 */
@property (nonatomic, strong) NSString *imPassword;    /**< 环信密码(当前用户才有) */

@property (nonatomic, strong) NSString *adviserName;           /**< 认证名称 */



@property (nonatomic, strong) NSString *userDocPath;  //归档的路径



@property (nonatomic, strong, readonly) NSString *genderString; //返回 男女



- (void)decodeUserDataWithWebDic:(NSDictionary *)dic;



@end
