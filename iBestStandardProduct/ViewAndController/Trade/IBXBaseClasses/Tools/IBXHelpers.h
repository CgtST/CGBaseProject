//
//  IBXHelpers.h
//  QNApp
//  Helpers
//  Created by xboker on 2017/3/22.
//  Copyright © 2017年 BaiCai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IBFXDealModel.h"


typedef NS_ENUM(NSInteger, NetWorkStatus) {
    NetWorkStatusNO = 0,    ///当前无网络
    NetWorkStatusWiFi,      ///当前网络WiFi
    NetWorkStatus4G,        ///当前网络4G
    NetWorkStatus3G,        ///当前网络3G
    NetWorkStatus2G,        ///当前网络2G
};


typedef NS_ENUM(NSInteger, LanguageType) {
    LanguageType_SimpleChinese = 0,
    LanguageType_TraditionChinese,
    LanguageType_English,
    ///预留
    LanguageType_Other,
};


@interface IBXHelpers : NSObject


/**
 *  传入时间字符串计算返回相应时间戳--不是8时区
 *
 *  @param dataString 传入的时间字符串
 *
 *  @return 返回的时间戳
 */
+ (NSTimeInterval)getTheNSTimeIntervalWithDateString:(NSString *)dateString;

/**
 *  传入时间字符串计算返回相应时间戳---8时区
 *
 *  @param dataString 传入的时间字符串
 *
 *  @return 返回的时间戳
 */
+ (NSTimeInterval)getTheNSTimeIntervalIS8WithDateString:(NSString *)dateString;






/**
 创建一个变大的scale动画

 @return 返回这个动画
 */
+ (CAKeyframeAnimation *)getBigKeyScaleAnimation;




/**
 获取一个旋转的动画----逆时针

 @return 返回这个动画
 */
+ (CABasicAnimation *)getRotateAnimation;



/**
 获取一个旋转的动画----逆时针

 @param time 动画时间
 @return 返回这个动画
 */
+ (CABasicAnimation *)getRotateAnimationWithTime:(double)time;



/**
 创建一个变小的scale动画
 
 @return 返回这个动画
 */
+ (CAKeyframeAnimation *)getSmallKeyScaleAnimation;







/**
 传入一个时间, 根据这时间获取前后推移多长的事件
 @param date 传入的时间
 @return 返回时间字符串集合
 */
+ (NSDictionary *)getIntervalWeekDayWithDate:(NSDate *)date;




/**
 传入字符串,计算后返回它大概会占取的高度

 @param str 传入的字符串
 @return 返回高度<字符串为空,默认返回55>
 */
+ (CGFloat )getTheAboutHeightWithString:(NSString *)str;



/**
 传入系统消息字符串,计算后返回它大概会占取的高度
 
 @param str 传入的字符串
 @return 返回高度<字符串为空,默认返回55>
 */
+ (CGFloat )getAboutMessageHeightWithString:(NSString *)str;



/**
 资讯, 新闻, 自选股新闻详情界面的标题动态计算高度然后返回

 @param title 传入的标题
 @return 返回相应的高度
 */
+ (CGFloat )getNewsDetailTitleHeightWithTtile:(NSString *)title;



/**
 传入一个数字字符串,转换返回分割后的数字, 没有小数位
 
 @param num 传入的数字字符串
 @return 123456789-->123,456,789
 */
+(NSString *)getNumberFormatWithNum:(NSString *)num;


/**
 传入一个数字字符串,转换返回分割后的数字, 一位小数
 
 @param num 传入的数字字符串
 @return 123456789-->123,456,789.0
 */
+(NSString *)getNumberFormatPointWithNum:(NSString *)num;




/**
 传入一个字符串, 转换后返回分割后的资金专用的二位小数数字

 @param num 传入的数字字符串

 @return 123456789-->123,456,789.00
 */
+(NSString *)getNumberFormaPropertytWithNum:(NSString *)num;


/**
 传入一个字符串, 转换后返回分割后的股价专用三位小数数字

 @param num 数字
 @return 123456789-->123,456,789.000
 */
+(NSString *)getNumberFormaStockPricetWithNum:(NSString *)num;




/**
 传入一个字符串, 转换后返回分割带四位小数的数字

 @param num 传入数字
 @return 返回格式后的数据
 */
+ (NSString *)getNumberFormatFourPointWithNum:(NSString *)num;




///**
// 传入一个字符串, 整数位分割
// 
// @param num 传入数字
// @return 123456789.01-->123,456,789.01
// */
//+ (NSString *)getNumberCustomFormatPointWithNum:(NSString *)num;




/**
 传入一个字符串, 转换后返回分割后的数字, 与上面的去别就是, 不限制小数的位数


 @param num  数字
 @return 123.456789-->123.456,789
 */
+ (NSString *)getNumCustomWithNum:(NSString *)num;







/**
 *  传入字符串后,以及相应参数颜色,字体大小,两个转换范围,进而返回一个转变后的富文本NSMutableAttributedString
 *
 *  @param str      需要转换的字符串
 *  @param color    转换后的颜色
 *  @param fontSize 转换后的字体大小
 *  @param range1   转换范围1
 *  @param range2   转换范围2
 *
 *  @return 返回的NSMutableAttributedString
 */
+ (NSMutableAttributedString *)getNSMutableAttributedStringWithString:(NSString *)str theColor:(UIColor *)color  theFontSize:(CGFloat)fontSize theRange1:(NSRange )range1 theRange2:(NSRange)range2;





/**
 交易获取请求时返回相应code的提示语

 @param code 传入的code
 @return 返回的提示语
 */
+ (NSString *)getTradeRequestInforWithCode:(NSString *)code;


/**
 *  传入一个字典和一个key，取key对应的字符串形value，有就返回，没有就返回@""
 *
 *  @param dict  字典
 *  @param key   key
 *  @return      value
 */
+ (NSString *)getStringWithDictionary:(NSDictionary *)dict andForKey:(NSString *)key;



/**
 获取联交所的订单状态

 @param str 传入字符串
 @param direction  买卖方向
 @return 转换成状态
 */
+ (NSString *)getMORSStatusWithString:(NSString *)str withOrderDirection:(NSString *)direction;


/**
 获取联交所订单类型

 @param str  传入字符串
 @return 返回相应状态
 */
+ (NSString *)getORTPStatusWithString:(NSString *)str;





/**
 返回交易登录时返回的语句, 成功或者失败

 @param str 返回的code
 @return 返回提示语
 */
+ (NSString *)getTradeLoginStatusWithString:(NSString *)str;




/**
 为通用的iBest请求加上签名

 @return 返回一个签名后的dic, 然后把自己的参数set进去就可
 */
+ (NSMutableDictionary *)getSignIBestRequestWithSession;



/**
 *  传入相应的时间戳,返回对应的时间字符串
 *
 *  @param timeIntervalString 传入的时间戳字符串
 *
 *  @return 返回的日期-z只有日期
 */
+ (NSString *)getTheNSDateStringWithTheTimeNSTimeIntervalString:(NSString *)timeIntervalString;




    
/*
**
*  传入相应的时间戳,返回对应的时间
*
*  @param timeIntervalString 传入的时间戳字符串
*
*  @return 返回的日期 如HH:mm:ss
*/
+ (NSString *)getOtherTheTimeStringWithTheTimeNSTimeIntervalString:(NSString *)timeIntervalString;





/**
 *  传入相应的时间戳,返回对应的时间
 *
 *  @param timeIntervalString 传入的时间戳字符串
 *
 *  @return 返回的日期 如xxxx/xx/xx
 */
+ (NSString *)getOtherTheNSDateStringWithTheTimeNSTimeIntervalString:(NSString *)timeIntervalString;


/**
 *  传入相应的时间戳,返回对应的时间
 *
 *  @param timeIntervalString 传入的时间戳字符串
 *
 *  @return 返回的日期 如xx:xx xx:xx
 */
+ (NSString *)getTheNSDateTimeStringWithTheTimeNSTimeIntervalString:(NSString *)timeIntervalString;

/**
 *  传入相应的时间戳,返回对应的时间-只有日期+时间
 *
 *  @param timeIntervalString 传入的时间戳字符串
 *
 *  @return 返回的日期--只有日期+时间
 */
+ (NSString *)getDateStringWithString:(NSString *)timeInterval;

/**
 *  传入相应的时间戳,返回对应的时间-只有日期+时间
 *
 *  @param timeInterval 传入的时间戳字符串
 *
 *  @return 返回的日期--只有年份
 */
+ (NSString *)getYearStringWithString:(NSString *)timeInterval;//add by ccy 170802

/**
 *  传入相应的时间戳,返回对应的时间
 *
 *  @param timeIntervalString 传入的时间戳字符串
 *
 *  @return 返回的 xx月xx日
 */
+ (NSString *)getTheMDDateStringWithTheTimeNSTimeIntervalString:(NSString *)timeIntervalString;

/**
 获取错误码对应的提示信息

 @param infor 错误码
 @return 对应的提示信息
 */
+ (NSString *)getErrorInforWithString:(NSString *)infor;




/**
 获取全球唯一标志符

 @return 返回这个标识符
 */
+ (NSString *)getOnlyGUID;




///通过系统字体版本判断CLV字段是传 ST25为繁体,SG25为简体,SE25为英语
+(NSString *_Nullable)simplifiedOrTraditionalBySystem;





/**
 获取当前的网络状态

 @return 返回当前的网络状态
 */
+ (NetWorkStatus)getNetWorkStatus;


/**
 当网络不可用时----检测网络, 然后跳转到检测网络界面
 */
+ (void)checkTheNetWorkStatus;
    



/**
  根据传入的时间戳显示新闻的发布时间, 例如:刚刚, 今天, 几月几号

 @param timeInterval 时间戳字符串
 @return 返回封装时间
 */
+ (nullable NSString *)getNewsDateWithInterval:(nullable NSString *)timeInterval;



/**
 数据转化为JSON

 @param data 传入的数据
 @return 返回JSON字符串
 */
+ (nullable NSString *)getJSONWithData:(nullable id)data;






/**
  校验输入密码是否合乎规则:6-8位的数字密码混合

 @param psw 输入的密码
 @return YES:合乎标准, NO:不合乎标准
 */
+ ( BOOL)getTradePSWIsQualifiedWithPSW:(nullable NSString *)psw;





/**
 根据自定义协议解析出来一个字典

 @param urlString 传入的URL
 @return 返回的字典
 */
+ (NSDictionary *)getAnalysisDicWithUrl:(NSString *)urlString;





/**
 更具代码获取相应的市场

 @param code 代码
 @return 返回的市场
 */
+ (NSString *)getMarketWithCode:(NSString *)code;





/**
 通过字符串匹配交易渠道

 @param code 代码
 @return 返回渠道
 */
+ (NSString *)getDealMediumWithCode:(NSString *)code;



/**
 *  传入字典和对应的key取出数值后,精度调整后返回字符串,防止进度丢失
 *
 *  @param dictionary 传入的字典
 *  @param key        字典中的key
 *
 *  @return 返回字符串
 */
+ (NSString *_Nullable)getNumFromDictionaryValueWithDictionary:(NSDictionary *_Nullable)dictionary key:(NSString *_Nullable)key;



/**
 判断两个小数是否能被整除

 @param num1 第一个数
 @param num2 第二个书
 @return 返回是否能被整除的结果
 */
+ (BOOL)getDivisibleWithFirstNum:(double )num1 withSecondNum:(double)num2;




/**
 *  字典 转换JSON 方法
 *
 *  @param object 字典
 *
 *  @return 返回JSON字符串
 */
+ (NSString *)getDataToJSONString:(id)object;




/**

 压缩图片, wifi情况下压缩为500k, 非wifi情况下压缩到200k, 小于200k不压缩

 @param image 将要压缩的image
 @return 压缩后返回的NSData
 */ 
+ (NSData *_Nullable)getZipImage:(UIImage *_Nullable)image;




/**
 根据颜色值渲染成图片
 
 @param color 传入的颜色值
 @return 渲染成的图片
 */
+ (UIImage * _Nonnull )getImageWithColor:(UIColor *_Nonnull)color;





/**
 将转码后的HTML5字符串通过固定格式替换

 @param htmlStr 待处理的字符串
 @return 处理后的字符串
 */
+ (NSString *_Nullable)getDecodeHtmlString:(NSString *_Nullable)htmlStr;



/**
 设置状态栏的背影色
 
 @param color 颜色
 */
+(void)setStatusBarBackgroundColor:(UIColor *)color;



/**
 json字符串转换为字典

 @param jsonStr 字符串
 @return 返回结果
 */
+ (NSMutableDictionary *)getDicFormJsonStr:(NSString *)jsonStr;




/**
 默认是除了证券已经登录的其他情况;
 
 @param controller 跳转源头
 @param success 登录成功
 */
+ (void)getStockJudgeJumpActionWithController:(UIViewController *)controller withLoginSuccess:(void(^)(BOOL success))successBL;




/**
 默认是除了外汇已经登录的其他情况;
 
 @param controller 跳转源头
 @param success 登录成功
 */
+ (void)getFXJudgeJumpActionWithController:(UIViewController *)controller withLoginSuccess:(void(^)(BOOL success))success;



/**
 默认是除了贵金属已经登录的其他情况;
 
 @param controller 跳转源头
 @param success 登录成功
 */
+ (void)getPMJudgeJumpActionWithController:(UIViewController *)controller withLoginSuccess:(void(^)(BOOL success))success;



/**
 外汇或者贵金属, 跳转到修改密码界面

 @param controller 当前controller
 @param type 0: 外汇, 1: 贵金属
 */
+ (void)getJumpToChangePSWWithController:(UIViewController *)controller withType:(NSInteger)type;




/**
 外汇/贵金属绑定成功后跳转的界面

 @param controller 动力源controller
 @param type 0:外汇, 1:贵金属
 */
+ (void)getFX_PMBindSuccessWithController:(UIViewController *)controller withType:(NSInteger)type;





/**
 外汇/贵金属的 校验价格
 
 @param callBack 提示信息回调
 @param dealModel 入参
 @param type 0: 外汇, 1:贵金属
 @return 是否符合校验
 */
+ (BOOL)getJudge_Price_WithCallBack:(void(^)(NSString *infor, NSString *judgePrice, NSString *judgePricePlus))callBack withDealModel:(IBFXDealModel *)dealModel wityType:(NSInteger)type;



/**
 外汇/贵金属的 止盈价校验
 
 @param callBack 提示信息回调
 @param dealModel 入参
 @param type 0: 外汇, 1:贵金属
 @return 是否符合校验
 */
+ (BOOL)getJudge_StopProfit_WithCallBack:(void(^)(NSString *infor, NSString *judgeZhiYing, NSString *judgeZhiYingPlus))callBack withDealModel:(IBFXDealModel *)dealModel wityType:(NSInteger)type;




/**
 外汇/贵金属的 止损价校验
 
 @param callBack 提示信息回调
 @param dealModel 入参
 @param type 0: 外汇, 1:贵金属
 @return 是否符合校验
 */
+ (BOOL)getJudge_StopLoss_WithCallBack:(void(^)(NSString *infor, NSString *judgeZhiSun, NSString *judgeZhiSunPlus))callBack withDealModel:(IBFXDealModel *)dealModel wityType:(NSInteger)type;









/**
 弹出扫描二维码的面

 @param callBack 回到扫到结果
 @param controller 动力源
 @param type 0:present出来(controller不能为空, 为空默认push),1: push出来
 */
+ (void)getSweepQRCodeWithCallBack:(void(^)(NSString *infor))callBack withController:(UIViewController *)controller withType:(NSInteger )type;





/**
 点击获取相机权限, 如果可以获取到权限则在block中回调

 @param callBack 回调
 */
+ (void)getCameraLimitWithCallBack:(void(^_Nullable)(void))callBack;


/**
 点击获取相册权限, 如果可以获取到权限则在block中回调
 
 @param callBack 回调
 */
+ (void)getAlbumLimitWithCallBack:(void(^_Nullable)(void))callBack;



/**
 外汇/贵金属  根据传入的小数位数, 返回相应的占位文字

 @param decimalCount 小数位数
 @return 返回占位文字
 */
+ (NSString *_Nullable)getPlaceholderWithDecimalCount:(NSInteger)decimalCount;







/**
 贵金属.外汇 下改撤  为价格相关校验添加边框
 
 @param color 颜色
 @param lable 添加对象
 */
+ (void)getAddBorderWithColor:(UIColor *)color withLable:(UILabel *)lable;





/**
为一个View添加虚线边框

@param view 要添加的view
@param color 颜色
*/
+ (void)getAddBorderToLayer:(UIView *)view withColor:(UIColor *)color;







/**
 获取当前手机设置的语言信息

 @return 返回语言信息
 */
+ (LanguageType)getLanguageType;




/**
 获取证券http请求时入参语言类型

 @return 类型
 */
+ (NSString *)getStockLanguageType;




@end
