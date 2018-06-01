//
//  IBSecurityManager.mm
//  IBSecurity
//
//  Created by tj on 5/5/15.
//  Copyright (c) 2015 BaCai. All rights reserved.
//

#import "IBSecurityManager.h"
#import "CTDeviceInfo.h"


@implementation IBSecurityManager
@synthesize key = _key;

/*
 * 单例
 */
IBSecurityManager* sharedIBSecurityManager()
{
    static dispatch_once_t onceToken;
    static IBSecurityManager *s_manager = nil;
    //使用device id初始化
    dispatch_once(&onceToken, ^{
        NSString * str = [CTDeviceInfo deviceIdentifier];
        s_manager = [[IBSecurityManager alloc] initWithString:
                    str];
      
    });
    return s_manager;
}

- (id)init
{
    self = [super init];
    //device id用于生成本地数据库密钥，国信没有数据库加密初始化时可以不用传递device id.
    sec = new QNSecurity();
    NSString *key = [self generateKey];
    //对key做URL Encode然后进行存储
    _key = [self urlEncode:key];
    return self;
}

- (id)initWithString:(NSString *)devId
{
    self = [super init];
    sec = new QNSecurity([devId UTF8String]);

    sec->setDebugMode(true);

    //对key做URL Encode然后进行存储
    NSString *key = [self generateKey];
    _key = [self urlEncode:key];
    return self;
}

- (void) dealloc {
    
    if (sec != NULL) {
        delete sec;
        sec = NULL;
    }
}

- (NSString *)getSQLCipherKey
{
    return [NSString stringWithUTF8String:sec->getLocDbKey()];
}

- (NSString *)generateKey
{
    char *key = sec->generateKey();
    //出错直接返回，不需要delete
    if ((strcmp(key,"") == 0) || key == NULL) {
        return @"";
    }
    NSString *result = [NSString stringWithUTF8String:key];
    delete key;
    key = NULL;
    return result;
}

- (NSString *)encryptLocalData:(NSString *)data userId:(NSString *)uid
{
    char *eData = sec->encryptLocData([data UTF8String],[uid UTF8String]);
    //出错直接返回，不需要delete
    if ((strcmp(eData,"") == 0) || eData == NULL) {
        return @"";
    }
    NSString * result = [NSString stringWithUTF8String:eData];
    delete eData;
    eData = NULL;
    return result;
}

- (NSString *)decryptLocData:(NSString *)data userId:(NSString *)uid
{
    char *dData = sec->decryptLocData([data UTF8String],[uid UTF8String]);
    //出错直接返回，不需要delete
    if ((strcmp(dData,"") || dData == NULL) == 0) {
        return @"";
    }
    
    NSString * result = [NSString stringWithUTF8String:dData];
    delete dData;
    dData = NULL;
    return result;
}

- (NSString *)encryptNetData:(NSString *)data isPassword:(bool)isPw
{
    //加密数据后做一次URL Encode用于传输
    char *eData = sec->encryptNetData([data UTF8String],isPw);
    //出错直接返回，不需要delete
    if ((strcmp(eData,"") == 0) || (eData == NULL))  {
        return @"";
    }
    NSString *encData = [NSString stringWithUTF8String:eData];
    delete eData;
    eData = NULL;
    return [self urlEncode:encData];
}

/**
 * 在网络请求参数里加入签名,根据最终的网络请求字典加入签名后返回字典.
 * 仅适合用于和点证科技服务器之前的约定签名.
 *
 * @param 网络请求参数集
 * @return 带签名的网络请求参数
 */

- (NSDictionary *)signWithParamsForIB:(NSDictionary *)params
{
    //获取签名 key
    NSString *signKey;
    if (![params objectForKey:@"params"]) {
        return params;
    }
    NSMutableDictionary *orgParams = [params objectForKey:@"params"];
    
    //有sessionid使用sessionid
    //无session情况下有，注册使用手机号,登录使用certcode,忘记密码使用phoneNum
    if ([orgParams objectForKey:@"sessionId"]) {
        signKey = [orgParams objectForKey:@"sessionId"];
    } else if ([orgParams objectForKey:@"cert"]) {
        //当有cert时为注册接口,取certType是手机的certCode
        //目前注册必须要填写手机。下面的方法没考虑到注册仅传微信的情况。此种情况下不会进行签名.
        NSMutableArray *cert = [orgParams objectForKey:@"cert"];
        for (NSDictionary * dic in cert) {
            IBCertType type = (IBCertType)[[dic[@"certType"] stringValue] integerValue];
            if (type == IBCertTypePhone)
            {
                if ([dic objectForKey:@"certCode"]) {
                    signKey = [dic objectForKey:@"certCode"];
                }
            }
        }
    } else if ([orgParams objectForKey:@"certCode"]) {
        //登录接口直接取certCode
        signKey = [orgParams objectForKey:@"certCode"];
    } else if ([orgParams objectForKey:@"phoneNum"]) {
        //其他接口直接取phoneNum字段做为key
        signKey = [orgParams objectForKey:@"phoneNum"];
    } else if([orgParams objectForKey:@"key"]){
        signKey = [orgParams objectForKey:@"key"];
    }else{
        //不符合以上条件的不做签名
        return params;
    }
    //根据最终生成的字典进行签名
    NSError *error;
    NSString *signStr = [self signByUseData:[NSJSONSerialization dataWithJSONObject:orgParams
                                        options:(NSJSONWritingOptions)0 error:&error] key:signKey];
    
    NSMutableDictionary *result = [params mutableCopy];
    result[@"sign"] = signStr;
    
    return result;
}

/**
 * 外汇行情 签名
 * @return 带签名的网络请求参数
 */
///临时改成这样, 有问题再改
- (NSDictionary *)signFXWithParamsForIB:(NSDictionary *)params {
    //获取签名 key
    NSString *signKey;
    NSMutableDictionary *result = [params mutableCopy];
    if ([[params allKeys] containsObject:@"params"])  {
        //有sessionid使用sessionid
        if ([params objectForKey:@"sessionId"]) {
            signKey = [params objectForKey:@"sessionId"];
        }else {
            //用随机数
            int ranNum = arc4random()%5000+1000;
            signKey = [NSString stringWithFormat:@"%d",ranNum];
        }
    }else{
        result = [params mutableCopy];
        int ranNum = arc4random()%5000+1000;
        signKey = [NSString stringWithFormat:@"%d",ranNum];
        [result setValue:@{} forKey:@"params"];
    }
    //根据最终生成的字典进行签名
    NSError *error;
    NSString *signStr = [self signByUseData:[NSJSONSerialization dataWithJSONObject:result[@"params"]
                                                                            options:(NSJSONWritingOptions)0 error:&error] key:signKey];
    [result setValue:signStr forKey:@"sign"];
    return result;
}


/**
 * 在交易请求网络请求参数里加入签名,根据最终的网络请求字典加入签名后返回字典.
 * 仅适合用于和点证科技服务器之前的约定签名.
 *
 * @param 网络请求参数集
 * @return 带签名的网络请求参数
 */

- (NSDictionary *)signTradeWithParamsForIB:(NSDictionary *)params
{
    NSInteger radom = 999999;
    NSString *radomStr = [NSString stringWithFormat:@"%ld", (long)radom];

    
    //获取签名 key
    NSString *signKey;
    NSMutableDictionary *result;
    
    
    if ([[params allKeys] containsObject:@"params"]) {
        result = [params mutableCopy];
        NSMutableDictionary *orgParams = [params objectForKey:@"params"] ;
        //有sessionid使用sessionid 没有session使用loginID
        if ([[orgParams objectForKey:@"jsessionid"] length]>0) {
            signKey = [orgParams objectForKey:@"jsessionid"];
        }else if ([orgParams objectForKey:@"loginID"]) {
            signKey = [orgParams objectForKey:@"loginID"];
        } else{
            //不符合以上条件的随机数签名
            signKey = radomStr;
            NSMutableDictionary *paramsSSSS = [result[@"params"] mutableCopy];
            [paramsSSSS setObject:radomStr forKey:@"ranNum"];
            
            [result setObject:paramsSSSS forKey:@"params"];
        }
    }else {
        result = [params mutableCopy];
        [result setValue:@{@"ranNum" : radomStr} forKey:@"params"];
    }
    
    //根据最终生成的字典进行签名
    NSError *error;
    
    NSString *signStr = [self signByUseData:[NSJSONSerialization dataWithJSONObject:result[@"params"]
                                                                            options:(NSJSONWritingOptions)0 error:&error] key:signKey];

//    result[@"sign"] = signStr;
    [result setValue:signStr forKey:@"sign"];
    return result;
}





/**
 * user 取值
 * 1)优先使用sessionid
 * 2)certCode手机号和微信号同时存在使用手机号
 * 3)修改密码使用手机号
 */

- (NSString *)signByUseData:(NSData *)data key:(NSString *)signKey
{
    //去除转译字符
    NSString *str =  [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSString *redata2 = [self replaceStr:@"[^0-9a-zA-Z\u4e00-\u9fa5]+" withReplacedStr:str withPlaceStr:@""];
    char *sign = sec->qnSign([redata2 UTF8String],[signKey UTF8String]);
    //出错直接返回，不需要delete
    if ((strcmp(sign,"") == 0) || (sign == NULL)){
        return @"";
    }
    NSString *result = [NSString stringWithUTF8String:sign];
    //手动释放new过的内存
    delete sign;
    sign = NULL;
    return result;
}

- (NSString *)urlEncode:(NSString *)data
{
    std::string encode = sec->urlEncode([data UTF8String]);
    return [NSString stringWithUTF8String:encode.c_str()];
}

/*
 * 使用正则表达式替换
 */
- (NSString*)replaceStr:(NSString*)regexPattern withReplacedStr:(NSString*)str withPlaceStr:(NSString*)pstr {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexPattern options:NSRegularExpressionCaseInsensitive error:nil];
    return [regex stringByReplacingMatchesInString:str options:0 range:NSMakeRange(0, [str length]) withTemplate:pstr];
}

@end
