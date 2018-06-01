//
//  QNLoginParm.h
//  QNApp
//  登录时冯装的参数modle
//  Created by tj on 11/11/15.
//  Copyright © 2015 Bacai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IBLoginParm : NSObject

/**
 *  凭证类型
 */
@property (nonatomic, assign) IBCertType certType;

/**
 *  certType为手机时，certCode为手机号.
 *  certType为微信登录时，certCode为微信openID
 */
@property (nonatomic, strong) NSString *certCode;

/**
 *  密码(certType为手机时，传入密码，其他不传)
 */
@property (nonatomic, strong) NSString *pwd;

/**
 *  微信登录时传入微信accessToken
 */
@property (nonatomic, strong) NSString *token;


@property (nonatomic,strong) NSString *appID;

@property (nonatomic,strong) NSString * tradeAccount;  //交易账号

//三方登录时增加的属性
@property (nonatomic,strong) NSString *strAvatar;//头像
@property (nonatomic,strong) NSString *nickName;//昵称

@property(nonatomic) IBAreaType areaType ;  //国家地区  1 中国内地，2香港


@property(nonatomic) BOOL  hasCheckNewDevice;   //验证新设备

- (instancetype)initWithCertType:(IBCertType)certType
                        certCode:(NSString *)certCode
                        password:(NSString *)password
                           token:(NSString *)token
                           appID:(NSString *)appID
                        areaType:(IBAreaType) areaType
               hasCheckNewDevice:(BOOL)hasCheckNewDevice
                    tradeAccount:(NSString *)tradeAccount ;




@end
