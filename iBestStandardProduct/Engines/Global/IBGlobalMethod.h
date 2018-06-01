//
//  IBGlobalMethod.h
//  QNApp
//
//  Created by zscftwo on 2017/2/15.
//  Copyright © 2017年 BaiCai. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IBStock;
@class IBOptionalStock;

@interface IBGlobalMethod : NSObject



#pragma mark - 香港号码判断

//是否为香港手机号码  6或9开头的8位数字 现在只判断8个数字
//+ (BOOL)isHKMobilePhoneNum:(nonnull NSString*)phoneNum;   //
//从交易登录里判断是哪里的areaType
+(IBAreaType)areaTypeFromeTradeAreaNum:(NSString *)areaNum;

//根据手机号前缀，判断手机所属地
+ (int32_t)getAreaTypeFromPrefix:(nonnull NSString *)prefix;

//判断是否全为数字
+(BOOL)deptNumInputShouldNumber:(nonnull NSString *)str;


+(UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;


+(nonnull NSString*)changeTelephone:(nonnull NSString*)teleStr;

#pragma - mark - json 与字符串的转换

#pragma mark -得到高度
+(CGSize)getSizeOfString:(NSString *)string width:(CGFloat )width  font:(UIFont *)font;

//json 转字符串
+ (nonnull NSString*)convertToJSONData:(nonnull NSDictionary *)infoDict;
//数组转 json字符串
+(nonnull NSString *)convertToJSONDataFromeArray:(nonnull NSArray *)infoArray;

//JSON字符串转化为字典
+ (nonnull NSDictionary *)dictionaryWithJsonString:(nonnull NSString *)jsonString;
//JSON字符串转化为数组
+ (nonnull NSArray  *)arrayWithJsonString:(nonnull NSString *)jsonString;

#pragma mark - 字符串相关
//任何类型的转为字符串
+(nonnull NSString *)changeStringWithId:(nonnull id)value;

//数字上用逗号隔开
+ (nonnull NSString *)addSeparatorForPriceString:(nonnull NSString *)pricestr;

//正则表达式判断
+ (BOOL)regexMatch:(nonnull NSString *)sourceText withRegex:(nonnull NSString *)regexPattern;
#pragma mark - Status 电池栏相关
//黑色的
+(void)blackStatus;
//白色的
+(void)whitleStatus;

#pragma mark - 业务逻辑相关
//是否是沪股
+(BOOL)isSHStockWithAssetId:(NSString *) assetid;
//是否是深股
+(BOOL)isSZStockWithAssetId:(NSString *) assetid;
//是否是港股
+(BOOL)isHKStockWithAssetid:(NSString *)assetid;
//拿请求新股的account
+(NSString *)getNewStockReqAccount;

+(nonnull NSString *)getTradeAccountInput;

//不是港股的
+(BOOL)isAStockWithAssetId:(NSString *)assetId;

//是否是游客身份-->NO:正式用户登录
+(BOOL)isGestType;


//是否显示十档
+(BOOL)isShowTenDang;

//是否是level2行情
+(BOOL)isLevelTwoQuote;
//登录
+(BOOL)isLogin;

///交易是否登录
+(BOOL)isTradeLogined;
///有没有绑定交易登录名准则!!!!legth>2, iBEST退出, session超时, 被顶替掉都要清除
+(nonnull NSString *)getTradeAccountId;


//股票交易是否绑定
+(BOOL)isTradeBinded;
///是否外汇交易登录
+ (BOOL)isFXTradeLogined;
///外汇是否已经绑定账号
+ (BOOL)isFXTradeBinded;

///是否贵金属交易登录
+ (BOOL)isPMTradeLogined;
///贵金属是否已经绑定账号
+ (BOOL)isPMTradeBinded;



//拿App登录的Session
+(nonnull NSString *)getAppLoginSession;

//判断密码是否是 6~8位字母 + 数字
+(BOOL)judgePasswordVilade:(NSString *)string;

//判断账号是否是 5~20位的字母 + 数字
+(BOOL)judgeTradeAccountVilade:(NSString *)string;


///判断是否是纯数字
+ (BOOL)judgePureNumVilade:(NSString *)string;


//拿到行情密码
+(nonnull NSString *)quotepassword;
//拿到行情手机号
+( NSString *_Nullable)quotePhoneNum;

#pragma mark - button 带图片
+(nonnull NSAttributedString *)updateAttributedTitle:(nonnull NSString *)title sortImage:(nonnull UIImage *)image;




#pragma mark - 10档相关
+(nonnull NSString *)buyField;
+(nonnull NSString *)sellField;
//判断code 为0 非0
+(NSNumber *) getCode:(id)resp;


//清除交易账号
+(void)clearTradeLoginAccount;
//清除登录状态
+(void)clearIbestLogin;


#pragma mark - 红涨绿跌

// yes 红涨绿跌
// NO  绿涨红跌

+(BOOL)isGreenUpRedDown;

//涨的颜色
+(nonnull UIColor *)upColor;

//跌的颜色
+(nonnull UIColor *)downColor;

//不变的颜色
+(UIColor *)noChangeColor;

// 相应的 红色或绿色
// @param string 数字字符串形式
//
+(nonnull UIColor *)changeColorWithValue:(nonnull NSString *)string;

+(nonnull UIColor *)changeColorWithValue:(NSString *)string;

+(nonnull UIColor *)colorForValue:(CGFloat )value;
//去掉浮点数后面多余的0
+(NSString*)removeFloatAllZero:(NSString*)string;

 //string 相比较 proclose 得出的 红色或绿色
 //@param proclose 相对的string
+(nonnull UIColor *)colorWithString:(NSString *)string CompareString:(  NSString *)proclose;

//返回主题颜色的color
+(UIColor *)getIBthemeColorWithNormal:(NSString *)normalColor  night:(NSString *)nightColor;

#pragma mark - 存储数据
//存储数据
+(NSString *)ibDataSavePath;

#pragma mark -  第三方登录相关


//是否是第三方登录
+(BOOL)isThirdLogin;
//清标志
+(void)clearThirdLoginStatus;


#pragma  mark - 时间戳 转化为xx:xx 时分
+(NSString *)changeHourMinWithTimestamp:(NSString *)timestamp;


+(BOOL)judgeDictionaryWithId:(id) object;

//是否显示全盘口
+(NSString *)quotePankouShowAllPath;




#pragma mark - QQ 微信登录 消息中的唯一标识
+(NSString *)thirdLoginId;

// UIColor转#ffffff格式的字符串
+ (NSString *)hexStringFromColor:(UIColor *)color;

#pragma mark - 新股申购专用
//一定是交易登录后使用
+(NSString *)getCorrectTRAC;

#pragma mark - 区号+手机号相关
+(IBAreaType)getAreaTypeFromAreaPhoneNumer:(NSString *)areaPhoneNum;

+(NSString *)getPhoneMubFromAreaPhoneNumer:(NSString *)areaPhoneNum;
+(NSString *)areaStringFromAreaType:(IBAreaType)areaType;

+(NSString *)areaNameFromAreaType:(IBAreaType)areaType;

#pragma mark - 判断是否是贵金属
+(BOOL)isPMProduct:(NSString *)symbol;


//ibest 账号绑定过其他交易账号（如外汇，黄金）
+(BOOL)isBindOtherAccount;

#pragma mark- 是否是黑色主题

+(BOOL)isDarkTheme;

#pragma mark - 见证人开户
//1: 见证人 0:开户
+(BOOL)faceToFaceOpen;


//清掉存在交易相关的 userDefaults 数据
+(void)clearTradeUserDefaults;


#pragma mark - 获取项目名称及版本号
+(NSString *)getProjectName;
+(NSString *)getProjectVersion;


@end
