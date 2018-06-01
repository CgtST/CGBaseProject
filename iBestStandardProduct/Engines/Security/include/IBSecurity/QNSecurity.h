/***

Copyright 2015 tongjun@bacai.com

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

*/


#pragma once

#include "cryptopp_rsa.h"
#include "cryptopp_aes.h"
#include "cryptopp_sign.h"
#include "cryptopp_sha1.h"
#include "cryptopp_base16.h"
#include "cryptopp_base64.h"

using namespace org::bsmith::encoding;
using namespace org::bsmith::crypto;


/*
 *
 *一点证科技APP加密类，可用于网络传输数据加密，签名，生成密钥以及本地数据的加解密
 */
class QNSecurity {
    public: QNSecurity();//国信加密初始化调用此方法
    //点证科技加密初始化
    public: QNSecurity(const char *deviceId);
    public: ~QNSecurity();

/**
 * 本地数据加密，用于客户端的敏感数据本地加密存储
 * @param data 待加密数据
 * @return 返回加密后的数据
 */

public: char *encryptLocData(const char *data,const char *uid);
/**
 * 本地数据解密，用于解密客户端本地存储的敏感数据
 * @param data 待加密数据
 * @return 返回解密后的数据
 */

public: char *decryptLocData(const char *data,const char *uid);

/**
 * SHA1签名
 * @param data 待加密数据
 * @return 返回签名后的Hash值
 */
public:char *sign(const char *data,const char *user);

    
public:char *qnSign(const char *data,const char *user);
/**
 *
 * 生成一个密钥，用于登录注册时候上传给服务器或者通知服务器更新密钥
 *
 * @return 返回加密后的密钥
 */
public: char *generateKey();
/**
 * 加密其他敏感数据用于网络传输
 *
 * @param data 待加密数据
 * @param isPw 是否为密码
 *
 * @return 返回加密后的数据
 */
public: char *encryptNetData(const char *data,bool isPw);

/**
 * 获取SQLCipher数据库的密钥
 *
 * @return SQLCipher数据库密钥(16位)
 */
public: char *getLocDbKey();

/**
 * URLEncode编码
 *  需要URLEncode编码的入参
 *
 *  返回URLEncode编码后的字串
 */
public: std::string urlEncode(const std::string& str);

/**
 * 设置调试模式,使用测试服务器的key和签名方法
 */
public: void setDebugMode(bool mode);
    
/**
 * 加密密钥
 *
 * @param key 要加密的key
 *
 * @return 返回加密后的密钥
 */
private: char *encryptKey(const char *key);
/**
 * base64 编码
 *
 * @param indata 要加编码的数据
 * @param len 编码数据长度
 *
 * @return 返回编码后的数据
 */
private: char *base64Encode(const char *indata,int len);
/**
 * 本地数据加密的初始化动作
 * 注意本地敏感数据加解密和uid有关系，客户端需要保证加密和解密传入的是相同的uid
 * 如果uid有变化本地需要清除所有缓存，包括敏感数据
 *
 * @param uid 用户ID
 *
 * @return 返回SQLCipher本地数据库的密码
 */
    
private: void initSecurityForLoc(const char *uid);
/**
 * AES加解密类,用于加解密本地数据
 */
private: AES locAes;
/**
 * AES加解密类,用于加解密网络数据
 */
private: AES netAes;
/**
 * 网络数据加密密钥
 */
private: byte netAesKey[16];
/**
 * 网络数据加密IV
 */
private: byte netAesiv[16];
/**
 * 本地SQLCipher数据库密码
 */
private: char locDbKey[17];
private: std::string userId;
private: std::string rsaNFactor;
private: std::string rsaEFactor;
private: bool generateNetKey;
private: bool debugMode;

};


