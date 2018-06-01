//
//  IBSecurityManager.h
//  aes-rsa-cpp
//
//  Created by tj on 5/5/15.
//  Copyright (c) 2015 wupei. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "QNSecurity.h"

//c++加密类
class QNSecurity;

/*
 *
 *一点证科技APP加密类，可用于网络传输数据加密，签名，生成密钥以及本地数据的加解密
 */
@interface  IBSecurityManager: NSObject {
@private
    QNSecurity *sec;
}
/**
 * 初始化
 * @param devId 设备唯一ID,客户端需要保证此设备ID的唯一性以及
 *              保证数据库或者本地数据没有被清除的情况下设备ID
 *              不能发生变化,否则会造成解不开数据返回空字串.
 *              国信没有数据库加密初始化时可以不用传递device id.
 *
 * @return
 */
- (id)initWithString:(NSString *)devId;
/**
 * 获取SQLCipher数据库的密码
 *
 * @return SQLCipher数据库的密码
 */
- (NSString *)getSQLCipherKey;
/**
 *
 * 生成一个密钥，用于登录注册时候上传给服务器或者通知服务器更新密钥
 * 注意：先生成密钥后方可使用encryptNetData进行加密。
 *
 * @return 返回加密后的密钥
 */
- (NSString *)generateKey;
/**
 * 本地数据加密，用于客户端的敏感数据本地加密存储
 * @param data 待加密数据
 * @param uid 用户user ID
 * @return 返回加密后的数据
 */

- (NSString *)encryptLocalData:(NSString *)data userId:(NSString *)uid;
/**
 * 本地数据解密，用于解密客户端本地存储的敏感数据
 * @param data 待加密数据
 * @param uid 用户user ID
 * @return 返回解密后的数据
 */

- (NSString *)decryptLocData:(NSString *)data userId:(NSString *)uid;
/**
 * 加密其他敏感数据用于网络传输
 *
 * @param data 待加密数据
 * @param isPw 是否为密码
 *
 * @return 返回加密后的数据
 */
- (NSString *)encryptNetData:(NSString *)data isPassword:(bool)isPw;
/**
 * 网络请求的请求接口签名.签名举例,假设有网络接口请求参数如下：
 * {"params":{"pwd":"+Akp8T4hQoVNuzXnkZGjIw==","channel":"anzhi","certCode":"11111111111"},
 * "version":"1.0"}
 *
 * 需要签名的数据是:{"pwd":"+Akp8T4hQoVNuzXnkZGjIw==","channel":"anzhi","certCode":"11111111111"}
 * 签名后传递的请求参数是:
 * {"sign":"Ti7g+qXzkdn8g1fRbc00pVt3d2g=",
 *  "params":{"pwd":"+Akp8T4hQoVNuzXnkZGjIw==","channel":"anzhi","certCode":"11111111111"},
 *  "version":"1.0"}
 *
 * @param data 待签名数据
 * @param user 点证科技注册登录传递certcode(有手机号传递手机号，无手机号传递微信token),
 *             其他接口传递sessionid.国信登录传递资金账号,其他接口传递认证码(authid).
 *
 * @return 返回签名后的值
 */
- (NSString *)sign:(NSString *)data key:(NSString *)signKey;

/**
 * 在网络请求参数里加入签名,根据最终的网络请求字典加入签名后返回字典.
 * 仅适合用于和点证科技服务器之前的约定签名.
 *
 * @param 网络请求参数集
 * @return 带签名的网络请求参数
 */
- (NSDictionary *)signWithParamsForIB:(NSDictionary *)params;


/**
 外汇行情签名方法

 @param params <#params description#>
 @return <#return value description#>
 */
- (NSDictionary *)signFXWithParamsForIB:(NSDictionary *)params;

/**
 * 在交易请求网络请求参数里加入签名,根据最终的网络请求字典加入签名后返回字典.
 * 仅适合用于和点证科技服务器之前的约定签名.
 *
 * @param 网络请求参数集
 * @return 带签名的网络请求参数
 */

- (NSDictionary *)signTradeWithParamsForIB:(NSDictionary *)params;

/**
 * urlEncode编码
 *
 * @param 待编码数据
 * @return URL Encode 编码后的数据
 */
- (NSString *)urlEncode:(NSString *)data;

@property (nonatomic, strong, readonly) NSString *key;


__BEGIN_DECLS
IBSecurityManager* sharedIBSecurityManager();
__END_DECLS

@end
