//
//  IBGlobalMethod.m
//  QNApp
//
//  Created by zscftwo on 2017/2/15.
//  Copyright © 2017年 BaiCai. All rights reserved.
//

#import "IBGlobalMethod.h"

#import "IBStock.h"
#import "IBOptionalStock.h"
#import "NSPathEx.h"
#import "IBAccount.h"
#import "IBUserData.h"


@implementation IBGlobalMethod


//从交易登录里判断是哪里的areaType
+(IBAreaType)areaTypeFromeTradeAreaNum:(NSString *)areaNum
{
    IBAreaType areaType = IBAreaTypeLand;
    if ([areaNum isEqualToString:@"86"]) {
       areaType = IBAreaTypeLand;
    }else if([areaNum isEqualToString:@"852"])
    {
       areaType = IBAreaTypeHK;
    }
    else if([areaNum isEqualToString:@"853"])
    {
       areaType = IBAreaTypeMacao;
    }
    return areaType;
}



//给手机号加星号加密
+(NSString*)changeTelephone:(NSString*)teleStr
{
    if([teleStr length]== 0)
        return nil ;
    
    NSString *string=[teleStr stringByReplacingOccurrencesOfString:[teleStr substringWithRange:NSMakeRange(3,4)]withString:@"****"];
    
    return string;
    
}

//根据手机号前缀，判断手机所属地
+ (int32_t)getAreaTypeFromPrefix:(nonnull NSString *)prefix
{
    if ([prefix isEqualToString:@"+86"])
    {
        return 1;
    }
    else if ([prefix isEqualToString:@"+852"])
    {
        return 2;
    }
    else if([prefix isEqualToString:@"+853"])
    {
        return 3;
    }
    return 0;
}

//判断是否全为数字
+(BOOL)deptNumInputShouldNumber:(nonnull NSString *)str
{
    NSString *regex = @"[0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:str]) {
        return YES;
    }
    return NO;
}

//判断密码是否是 6~8位字母 + 数字
+(BOOL)judgePasswordVilade:(NSString *)string
{
    NSError *matchError = nil;
    NSRegularExpression *regexExpression = [NSRegularExpression regularExpressionWithPattern:@"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,8}$"
                                                                                     options:0
                                                                                       error:&matchError];
    const NSUInteger matchCount = [regexExpression numberOfMatchesInString:string
                                                                   options:0
                                                                     range:NSMakeRange(0, [string length])];
    return 0 != matchCount;

}


//判断账号是否是 5~20位的字母 + 数字
+(BOOL)judgeTradeAccountVilade:(NSString *)string{
    NSError *matchError = nil;
    NSRegularExpression *regexExpression = [NSRegularExpression regularExpressionWithPattern:@"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{5,20}$"
                                                                                     options:0
                                                                                       error:&matchError];
    const NSUInteger matchCount = [regexExpression numberOfMatchesInString:string
                                                                   options:0
                                                                     range:NSMakeRange(0, [string length])];
    return 0 != matchCount;
}



///判断是否是纯数字
+ (BOOL)judgePureNumVilade:(NSString *)string{
    if (string == nil) {
        return NO;
    }
    if (string.length == 0) {
        return NO;
    }
    NSError *matchError = nil;
    NSRegularExpression *regexExpression = [NSRegularExpression regularExpressionWithPattern:@"^[0-9]*$"
                                                                                     options:0
                                                                                       error:&matchError];
    const NSUInteger matchCount = [regexExpression numberOfMatchesInString:string
                                                                   options:0
                                                                     range:NSMakeRange(0, [string length])];
    return 0 != matchCount;



}


// UIColor转#ffffff格式的字符串
+ (NSString *)hexStringFromColor:(UIColor *)color {
    const CGFloat *components = CGColorGetComponents(color.CGColor);

    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];

    return [NSString stringWithFormat:@"0xff%02lX%02lX%02lX",
            lroundf(r * 255),
            lroundf(g * 255),
            lroundf(b * 255)];
}


#pragma mark - 验证

+ (BOOL)regexMatch:(nonnull NSString *)sourceText withRegex:(nonnull NSString *)regexPattern
{
    NSError *matchError = nil;
    NSRegularExpression *regexExpression = [NSRegularExpression regularExpressionWithPattern:regexPattern
                                                                                     options:0
                                                                                       error:&matchError];
    const NSUInteger matchCount = [regexExpression numberOfMatchesInString:sourceText
                                                                   options:0
                                                                     range:NSMakeRange(0, [sourceText length])];
    return 0 != matchCount;
}



+(UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return img;
}

#pragma mark -得到高度
+(CGSize)getSizeOfString:(NSString *)string width:(CGFloat )width  font:(UIFont *)font
{
    // 设置文字属性 要和label的一致
    NSDictionary *attrs = @{NSFontAttributeName : font};
    CGSize maxSize = CGSizeMake(width, MAXFLOAT);
    
    // 计算文字占据的高度
    CGSize size = [string boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    
    return size;
}


#pragma - mark - json 与字符串的转换
//dictionary  json 转字符串
+ (nonnull NSString*)convertToJSONData:(nonnull NSDictionary *)infoDict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:infoDict
                                                       options:0 // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];

    NSString *jsonString = @"";

    if (! jsonData)
    {
        NSLog(@"Got an error: %@", error);
    }else
    {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }

    jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
//
//    [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];

    return jsonString;
}


//数组转 json字符串
+(nonnull NSString *)convertToJSONDataFromeArray:(NSArray *)infoArray
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:infoArray
                                                       options:0 // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];

    NSString *jsonString = @"";
    if (! jsonData)
    {
        NSLog(@"Got an error: %@", error);
    }else
    {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }

    jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    //
    //    [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return jsonString;
}



//JSON字符串转化为字典
+ (nonnull NSDictionary *)dictionaryWithJsonString:(nonnull NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }

    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}


//JSON字符串转化为数组
+ (nonnull NSArray  *)arrayWithJsonString:(nonnull NSString *)jsonString
{
    if (jsonString == nil) {
        return  [NSArray array];
    }

    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSArray * arr = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return  [NSArray array];
    }
    return arr;
}



#pragma mark - 字符串相关
//去掉浮点数后面多余的0
+(NSString*)removeFloatAllZero:(NSString*)string
{
    NSString * testNumber = string;
    NSString * outNumber = [NSString stringWithFormat:@"%@",@(testNumber.floatValue)];
    return outNumber;
}



+(NSString *)changeStringWithId:(id)value
{
    NSString * temp = @"";
    if ([value isKindOfClass:[NSString class]]) {
        if ([(NSString *)value length]>0) {
            temp = value;
        }
    }
    else if([value isKindOfClass:[NSNull class]]  ) {
        return @"";
    }else  {
       temp = [value stringValue];
    }
    
    if (temp.length == 0) {
        temp = @"--";
    }
    return temp;
}

//拿请求新股的account
+(NSString *)getNewStockReqAccount
{
    NSString * temp = [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultTradeAccount"];
    
    return  temp.length>0?temp:@"";
}

//数字上用逗号隔开
+ (nonnull NSString *)addSeparatorForPriceString:(nonnull NSString *)pricestr
{
    NSMutableString * tempstr = pricestr.mutableCopy;
    NSRange range = [tempstr rangeOfString:@"."];
    NSInteger index = 0;
    if (range.length>0) {
        index = range.location;
    }else{
        index = pricestr.length;
    }
    
    while ((index-3)>0) {
        index -= 3;
        [tempstr insertString:@"," atIndex:index];
    }
    
    tempstr = [tempstr stringByReplacingOccurrencesOfString:@"." withString:@","].mutableCopy;
    return tempstr;
}

#pragma mark - 业务逻辑相关

+(NSString *)getTradeAccountId {
//    return [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultTradeAccount"];
    
    
//#if IS_665_TEST_ENVIRONMENT == 0
    return [[NSUserDefaults standardUserDefaults] objectForKey:TradeLoginAccount];
//#else 
//    return @"测试环境";
//#endif
}

+(NSString *)getTradeAccountInput {
    return  [[NSUserDefaults standardUserDefaults] objectForKey:TradeLoginAccount];
}


+(BOOL)isAStockWithAssetId:(NSString *)assetId {
    if ([IBGlobalMethod isHKStockWithAssetid:assetId] == NO) {
        return YES;
    }
    return NO ;
}




//是否是游客身份
+(BOOL)isGestType
{
    return  User().userType == IBUserTypeGuest?YES:NO;
}


//是否是港股
+(BOOL)isHKStockWithAssetid:(NSString *)assetid
{
    if ([assetid rangeOfString:@".HK"].location != NSNotFound)
    {
        return YES;
    }
    else
    {
        return NO;
    }
  
}
//是否是沪股
+(BOOL)isSHStockWithAssetId:(NSString *) assetid
{
    if ([assetid rangeOfString:@".SH"].location != NSNotFound) {
        return YES;
    }else{
        return NO;
    }
}
//是否是深股
+(BOOL)isSZStockWithAssetId:(NSString *) assetid
{
    if ([assetid rangeOfString:@".SZ"].location != NSNotFound) {
        return YES;
    }else{
        return NO;
    }
}

//是否是level2行情
+(BOOL)isLevelTwoQuote
{
    NSString * temp = User().isLevelTwo;
    if ([temp floatValue]>0) {
        return YES;
    }else{
        return NO;
    }
}

//是否显示十档  
+(BOOL)isShowTenDang
{

    if([IBGlobalMethod isLevelTwoQuote] == YES && [IBGlobalMethod isGestType] == NO )
    {
        return YES;
    }else
    {
        return NO;
    }
}

//登录
+(BOOL)isLogin
{
    return  User().bLogin;
}


/////交易是否登录
//+(BOOL)isTradeLogined {
//
//    id data = [iBestCache() getTradeLoginDic];
//    if ([data isKindOfClass:[NSDictionary class]]) {
//        data = (NSDictionary *)data;
//        if ([data allKeys].count) {
//            return YES;
//        }else {
//            return NO;
//        }
//    }else {
//        return NO;
//    }
//}
//
/////是否外汇交易登录
//+ (BOOL)isFXTradeLogined {
//    if (fxAccount().sessionID) {
//        if (fxAccount().sessionID.length > 5) {
//            return YES;
//        }else {
//            return NO;
//        }
//    }else {
//        return NO;
//    }
//}

//股票交易是否绑定
+(BOOL)isTradeBinded
{
    if(User().tradeAccount.length>2)
    {
        return YES;
    }
    return NO;
}

///外汇是否已经绑定账号
+ (BOOL)isFXTradeBinded {
//#if ENVIRONMENT  == 3
//    return YES;
//#else
    if(User().mfTradeAccount.length>2)
    {
        return YES;
    }
    return NO;
//#endif
}

/////是否贵金属交易登录
//+ (BOOL)isPMTradeLogined {
//
//    if (pmAccount().sessionID) {
//        if (pmAccount().sessionID.length > 5) {
//            return YES;
//        }else {
//            return NO;
//        }
//    }else {
//        return NO;
//    }
//}

///贵金属是否已经绑定账号
+ (BOOL)isPMTradeBinded {

#if OPEN_BLIND_ENVIRONMENT  == 1
    return YES;
#else
    if( User().pmTradeAccount.length>2)
    {
        return YES;
    }
    return NO;
#endif

}




//拿App登录的Session
+(NSString *)getAppLoginSession
{
    IBAccount *account = [IBAccount currentAccount];
    NSString * session = account.session;
    
   return  session.length>0?session:@"";
}

//拿到行情密码
+(NSString *)quotepassword
{
    return User().quotePassword;
}
//拿到行情手机号
+(NSString *)quotePhoneNum
{
    return User().phoneNumber;
}

#pragma mark - QQ 微信登录 消息中的唯一标识
//+(NSString *)thirdLoginId
//{
//    NSString * temp = @"";
//    if([IBOptionPlistSingleton shareIntance].thirdLoginOpenId.length>0)
//    {
//        temp = [IBOptionPlistSingleton shareIntance].thirdLoginOpenId;
//    }
//    return temp;
//}

#pragma mark - button 带图片
+(NSAttributedString *)updateAttributedTitle:(NSString *)title sortImage:(UIImage *)image
{
    UIColor *attributesColor = [UIColor clearColor];
    if ([self.dk_manager.themeVersion isEqualToString:@"NORMAL"]) {
        attributesColor  = [UIColor colorWithHexString:@"#666666"];
    }
    else if([self.dk_manager.themeVersion isEqualToString:@"NIGHT"])
    {
        attributesColor =  [UIColor colorWithHexString:@"#999999"];
    }

    
    NSDictionary *attributes =@{
                                NSFontAttributeName: [UIFont systemFontOfSize:14.f],
                                NSForegroundColorAttributeName: attributesColor,
                                };
    NSMutableAttributedString * attributedTitle = [[NSMutableAttributedString alloc] initWithString:title attributes:attributes];
    UIImage * imageResult = [CDTImageTools modifyImageSize:CGSizeMake(14, 14) OfImage:image];
    if (imageResult) {
        NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
        attachment.image =imageResult;
        attachment.bounds = CGRectMake(0, - 3, attachment.image.size.width, attachment.image.size.height);
        NSAttributedString *sortImageAttributedString = [NSAttributedString attributedStringWithAttachment:attachment];
        [attributedTitle appendAttributedString:sortImageAttributedString];
    }
    
    return attributedTitle;
}

#pragma mark - Status 电池栏相关
+(void)blackStatus
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

//白色的
+(void)whitleStatus
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}



#pragma mark - 10档相关
+(NSString *)buyField
{
    //买价1~10  买量1~10  买排队数 1~10
    return   @"26|27|28|29|30|50|51|52|53|54|31|32|33|34|35|55|56|57|58|59|73|74|75|76|77|78|79|80|81|82";
}

+(NSString *)sellField
{
     //卖价1~10  卖量1~10  卖排队数 1~10
    return   @"20|19|18|17|16|64|63|62|61|60|25|24|23|22|21|55|56|57|58|59|83|84|85|86|87|88|89|90|91|92";
    
}

//判断code 为0 非0
+(NSNumber *) getCode:(id)resp
{
    NSNumber *code = @(ErrorCodeEmptyResponseCode);
    //有key且key不为null时才赋值给code,否则返回ErrorCodeClientNetworkError
    if (resp[@"code"] && ![resp[@"code"] isEqual:[NSNull null]]) {
        code = resp[@"code"];
    }
    return code;
}

#pragma mark - 退出要清除的内容

//清除交易账号
+(void)clearTradeLoginAccount
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:TradeLoginAccount];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}


//清除登录状态
+(void)clearIbestLogin
{
    User().bLogin  = NO;
    IBAccount * accout = [IBAccount currentAccount];
    [accout saveUserData:User()];
}


#pragma mark - 红涨绿跌 控制

//
//  NO   红涨绿跌
// Yes  绿涨红跌
//
+(BOOL)isGreenUpRedDown
{
    return  [[NSUserDefaults standardUserDefaults] boolForKey:kNotifyRedIncreaseChange];
}


+(UIColor *)upColor
{
    UIColor * color = [UIColor clearColor];
    color =  [IBGlobalMethod isGreenUpRedDown ]? [IBSkinColor getBackgroundColor:IBBgColorTypeGreenDown]:[IBSkinColor getBackgroundColor:IBBgColorTypeRedUp];
    return color;
}



+(UIColor *)downColor
{
    UIColor * color = [UIColor clearColor];
    color = [IBGlobalMethod isGreenUpRedDown]? [IBSkinColor getBackgroundColor:IBBgColorTypeRedUp]:[IBSkinColor getBackgroundColor:IBBgColorTypeGreenDown];
    return color;
}

+(UIColor *)noChangeColor
{
    UIColor * color = [UIColor clearColor];
     color = [IBSkinColor getBackgroundColor:IBBgColorTypeNoChange];
    return color;
}


+(UIColor *)changeColorWithValue:(NSString *)string
{
    UIColor * color = [UIColor clearColor];
    NSString * tempStr = string;
    if ([tempStr floatValue]>0) {
        color =  [IBGlobalMethod upColor];
    }else if([tempStr floatValue]<0){
        color = [IBGlobalMethod downColor];
    }else{
        color = [IBGlobalMethod noChangeColor];
    }
    
    return color;
}

+(UIColor *)colorForValue:(CGFloat)value
{
    UIColor *color = [UIColor clearColor];
    if (value > 0.00001f)	{
        color = [IBGlobalMethod upColor];
    }
    else if(value < -0.00001f && value > -999999999.f)	{
        color = [IBGlobalMethod downColor];
    }
    else	{
        color = [IBGlobalMethod noChangeColor];
    }
    return color;
}




//返回主题颜色的color
+(UIColor *)getIBthemeColorWithNormal:(NSString *)normalColor  night:(NSString *)nightColor
{
    UIColor * tempcolor = [UIColor clearColor];
    if ([self.dk_manager.themeVersion isEqualToString:@"NORMAL"]) {
        tempcolor = [UIColor colorWithHexString:normalColor];
    }else{
        tempcolor = [UIColor colorWithHexString:nightColor ];
    }
    
    return tempcolor;
}




//
 //string 相比较 proclose 得出的 红色或绿色

 //@param string
 //@param proclose 相对的string
 //@return <#return value description#>
//
+(UIColor *)colorWithString:(NSString *)string CompareString:(NSString *)proclose
{
    UIColor * color = [UIColor clearColor];
    if([string doubleValue]>[proclose doubleValue])
    {
        color = [IBGlobalMethod upColor];
    }else if([string doubleValue]<[proclose doubleValue])
    {
        color = [IBGlobalMethod downColor];
    }else{
        color = [IBGlobalMethod noChangeColor];
    }
    
    return color;
}

#pragma mark -  第三方登录相关

//是否是第三方登录
+(BOOL)isThirdLogin
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"isThardLoginType"];
}

+(void)clearThirdLoginStatus
{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isThardLoginType"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma  mark - 时间戳 转化为xx:xx 时分
+(NSString *)changeHourMinWithTimestamp:(NSString *)timestamp
{
    NSString *time = timestamp;
    NSTimeInterval interval = [time longLongValue]/1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *datestring = [dateFormatter stringFromDate:date];

    return datestring;
}


#pragma mark - 判断是否是字典

+(BOOL)judgeDictionaryWithId:(id) object
{
    if ([object isKindOfClass:[NSDictionary class]]) {
        return YES;
    }else{
        return NO;
    }
    
}

//存储数据
+(NSString *)ibDataSavePath
{
    NSString *savePath = [[NSPathEx docPath] stringByAppendingPathComponent:@"ibSaveData"];

    return savePath;
}

//是否显示全盘口
+(NSString *)quotePankouShowAllPath
{
  
    NSString *savePath = [[NSPathEx docPath] stringByAppendingPathComponent:Quote_PankouShow];
    
    return savePath;
}





#pragma mark - 区号+手机号相关

//
// Description

 //@param areaPhoneNum 带区号的手机号 如：+861234567890
 //@return +86
//
+(IBAreaType)getAreaTypeFromAreaPhoneNumer:(NSString *)areaPhoneNum
{
    IBAreaType areatype = IBAreaTypeLand;
    if ([areaPhoneNum hasPrefix:@"+86"] || [areaPhoneNum hasPrefix:@"86"]) {
        areatype = IBAreaTypeLand;
    }else if([areaPhoneNum hasPrefix:@"+852"] ||  [areaPhoneNum hasPrefix:@"852"]){
        areatype = IBAreaTypeHK;
    }else if([areaPhoneNum hasPrefix:@"+853"] ||  [areaPhoneNum hasPrefix:@"853"])
    {
        areatype = IBAreaTypeMacao;
    }
    return areatype;
}

//
//Description
 //@param areaPhoneNum 带区号的手机号 如：+861234567890
// @return 1234567890
//
+(NSString *)getPhoneMubFromAreaPhoneNumer:(NSString *)areaPhoneNum
{
    
    NSCharacterSet *set = [NSCharacterSet whitespaceCharacterSet];
    areaPhoneNum = [areaPhoneNum stringByTrimmingCharactersInSet:set];
    NSString * temp = @"";
    if ([areaPhoneNum hasPrefix:@"+86"]||[areaPhoneNum hasPrefix:@"86"]) {
        temp = [areaPhoneNum substringWithRange:NSMakeRange(areaPhoneNum.length-11, 11)];
    }else if([areaPhoneNum hasPrefix:@"+852"]||[areaPhoneNum hasPrefix:@"852"]){
        temp = [areaPhoneNum substringWithRange:NSMakeRange(areaPhoneNum.length-8, 8)];
    }else if([areaPhoneNum hasPrefix:@"+853"]||[areaPhoneNum hasPrefix:@"853"])
    {
        temp = [areaPhoneNum substringWithRange:NSMakeRange(areaPhoneNum.length-8, 8)];
    }
    return temp;
}


+(NSString *)areaStringFromAreaType:(IBAreaType)areaType
{
    NSString * temp = @"+86";
    if(areaType == IBAreaTypeLand)
    {
        temp = @"+86";
    }else if(areaType == IBAreaTypeHK){
        temp = @"+852";
    }else if(areaType == IBAreaTypeMacao)
    {
        temp = @"+853";
    }
    return temp;
}

+(NSString *)areaNameFromAreaType:(IBAreaType)areaType
{
    NSString * temp = CustomLocalizedString(@"CHINAMAINLAND", nil);
    if(areaType == IBAreaTypeLand)
    {
        temp = CustomLocalizedString(@"CHINAMAINLAND", nil);
    }else if(areaType == IBAreaTypeHK){
        temp = CustomLocalizedString(@"HONGKONG", nil);
    }else if(areaType == IBAreaTypeMacao)
    {
        temp = CustomLocalizedString(@"ZHONGGUOAOMEN", nil);
    }
    return temp;
}

#pragma mark - 新股申购专用
//一定是交易登录后使用
/*+(NSString *)getCorrectTRAC
{
    NSString * temp = @"";
    IBTradeLoginModle * tradeLoginModel = [[IBTradeLoginModle alloc] init];
    if (tradeLoginModel.IS_SBUAccount) {
        temp = tradeLoginModel.SBUTRAC;
    }else {
        temp = tradeLoginModel.TRAC;

    }
    return temp;
}


#pragma mark - 判断是否是贵金属
+(BOOL)isPMProduct:(NSString *)symbol
{
    BOOL temp = NO;
    if ([FXQuoteManager().pmCodes containsObject:symbol]) {
        temp = YES;
    }
    return temp;
}
*/
//ibest 账号绑定过其他交易账号（如外汇，黄金）
+(BOOL)isBindOtherAccount
{
   if( User().tradeAccount.length>0 || User().pmTradeAccount.length>0 ||User().mfTradeAccount.length>0)
   {
       return YES;
   }else{
       return NO;
   }
}


#pragma mark- 是否是黑色主题

+(BOOL)isDarkTheme
{
    if ([[DKNightVersionManager sharedManager].themeVersion isEqualToString:@"NORMAL"])
    {
        return NO;
    }else{
        return YES;
    }
}


//1: 见证人 0:开户
+(BOOL)faceToFaceOpen
{
    NSString * flag = User().userFlag;
    if([flag intValue ] == 1)
    {
        return YES;
    }else{
        return NO;
    }
}


//清掉存在交易相关的 userDefaults 数据
+(void)clearTradeUserDefaults
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:TradeLoginAccount];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:TradeClientID];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"defaultTradeAccount"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"stockjobberType"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}



#pragma mark - 获取项目名称及版本号
+(NSString *)getProjectName
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    return [infoDictionary objectForKey:@"CFBundleDisplayName"];
}

+(NSString *)getProjectVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    return [infoDictionary objectForKey:@"CFBundleShortVersionString"];
}


@end
