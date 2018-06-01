//
//  IBXHelpers.m
//  QNApp
//
//  Created by xboker on 2017/3/22.
//  Copyright © 2017年 BaiCai. All rights reserved.
//

#import "IBXHelpers.h"
#import "CDTDataEncryAndDecry.h"
#import "MReachability.h"
#import "IBCheckNetWorkViewController.h"
#import "QNViewUtils.h"
#import "QNAppDelegate.h"
#import "NSDate+Additions.h"
#import "CDTFontTools.h"
#import "IBTradeOpenAccountGuideController.h"
#import "IBFXLoginViewController.h"
#import "IBFXUnbindInforController.h"
#import "IBFXChangePSWViewController.h"
#import "IBFXBindSuccessInforViewController.h"
#import "IBFXQuoteConfigJsonModel.h"
#import "IBTradeLoginViewController.h"
#import "SweepQRCodeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import "IBCustomOrderView.h"


@implementation IBXHelpers


/**
 *  传入时间字符串计算返回相应时间戳--不是8时区
 *
 *  @param dataString 传入的时间字符串
 *
 *  @return 返回的时间戳
 */
+ (NSTimeInterval)getTheNSTimeIntervalWithDateString:(NSString *)dateString {
    if (dateString.length) {
        NSDateFormatter *formatter = ibToolHandler().m_Not8Formatter;
        NSDate *date= [formatter dateFromString:dateString];
        NSTimeInterval dateTimeInterval = [date timeIntervalSince1970];
        return dateTimeInterval;
    }
    return 0;
}

/**
 *  传入时间字符串计算返回相应时间戳---8时区
 *
 *  @param dataString 传入的时间字符串
 *
 *  @return 返回的时间戳
 */
+ (NSTimeInterval)getTheNSTimeIntervalIS8WithDateString:(NSString *)dateString {
    if (dateString.length) {
        NSDateFormatter *formatter = ibToolHandler().m_DateFormatter;
        NSDate *date= [formatter dateFromString:dateString];
        NSTimeInterval dateTimeInterval = [date timeIntervalSince1970];
        return dateTimeInterval;
    }
    return 0;
}


/**
 创建一个变大的scale动画
 
 @return 返回这个动画
 */
+ (CAKeyframeAnimation *)getBigKeyScaleAnimation {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.values = @[@(1), @(1.02), @(1.04), @(1.06), @(1.08)];
    animation.repeatCount = 1;
    animation.duration = 0.2f;
    animation.autoreverses = YES;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    return animation;
}


/**
 创建一个变小的scale动画
 
 @return 返回这个动画
 */
+ (CAKeyframeAnimation *)getSmallKeyScaleAnimation {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.values = @[@(0.98), @(0.96), @(0.94), @(0.92)];
    animation.repeatCount = 1;
    animation.duration = 0.2f;
    animation.autoreverses = YES;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    return animation;
}

/**
 获取一个旋转的动画----逆时针
 
 @return 返回这个动画
 */
+ (CABasicAnimation *)getRotateAnimation {
    CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.toValue = [NSNumber numberWithFloat:0.f];
    rotationAnimation.duration = 0.6;
    rotationAnimation.repeatCount = 1;
    rotationAnimation.fillMode = kCAFillModeForwards;
    rotationAnimation.removedOnCompletion = YES;
    return rotationAnimation;
}



/**
 获取一个旋转的动画----逆时针
 
 @param time 动画时间
 @return 返回这个动画
 */
+ (CABasicAnimation *)getRotateAnimationWithTime:(double)time {
    CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.toValue = [NSNumber numberWithFloat:0.f];
    rotationAnimation.duration = time;
    rotationAnimation.repeatCount = MAXFLOAT;
    rotationAnimation.fillMode = kCAFillModeForwards;
    rotationAnimation.removedOnCompletion = NO;
    return rotationAnimation;
}




/**
 传入一个时间, 根据这时间获取前后推移多长的事件
 @param date 传入的时间
 @return 返回时间字符串集合
 */
+ (NSDictionary *)getIntervalWeekDayWithDate:(NSDate *)date  {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    //    NSDateFormatter *formatter = getDateFormatter();
    
    NSDate *nowDate = date;
    //NSString *nowDateStr = [[formatter stringFromDate:nowDate] substringToIndex:10];
    NSCalendar *calander = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [calander setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    calander.locale = [NSLocale currentLocale];
    
    ///一周前
    NSDateComponents *compent1 = [NSDateComponents new];
    compent1.day = -6;
    NSDate *beforWeekDate = [calander dateByAddingComponents:compent1 toDate:nowDate options:0];
    NSString *beforWeekDateStr = [[formatter stringFromDate:beforWeekDate] substringToIndex:10];
    ///一周后
    NSDateComponents *compent2 = [NSDateComponents new];
    compent2.day = 6;
    NSDate *afterWeekDate = [calander dateByAddingComponents:compent2 toDate:nowDate options:0];
    NSString *afterWeekDateStr = [[formatter stringFromDate:afterWeekDate] substringToIndex:10];
    ///前一天
    NSDateComponents *compent3 = [NSDateComponents new];
    compent3.day = -1;
    NSDate *beforeDayDate = [calander dateByAddingComponents:compent3 toDate:nowDate options:0];
    NSString *beforeDayDateStr = [[formatter stringFromDate:beforeDayDate] substringToIndex:10];
    
    
    
    ///本月的第一天是几号
    NSDateComponents *componentsCurrentDate = [calander components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday|NSCalendarUnitWeekOfMonth fromDate:nowDate];
    NSDateComponents *componentsNewDate = [NSDateComponents new];
    componentsNewDate.year = componentsCurrentDate.year;
    componentsNewDate.month = componentsCurrentDate.month;
    componentsNewDate.weekOfMonth = 1;
    componentsNewDate.day = 1;
    NSDate *firstDateOfMonth =  [calander dateFromComponents:componentsNewDate];
    NSString *firstDateOfMonthStr = [[formatter stringFromDate:firstDateOfMonth] substringToIndex:10];
    
    NSString *readNowDateStr = [[formatter stringFromDate:nowDate] substringToIndex:10];
    
    ///如果当前天是第一天则默认全部显示为第一天
    if ([beforeDayDate compare:firstDateOfMonth] == NSOrderedAscending) {
        return @{@"nowDate" : firstDateOfMonthStr, @"previousDate" : firstDateOfMonthStr, @"afterWeek" : afterWeekDateStr, @"beforeWeek" : beforWeekDateStr, @"readNowDateStr" : readNowDateStr};
    }else {
        return @{@"nowDate" : beforeDayDateStr, @"previousDate" : firstDateOfMonthStr, @"afterWeek" : afterWeekDateStr, @"beforeWeek" : beforWeekDateStr, @"readNowDateStr" : readNowDateStr};
    }
    
}






/**
 传入字符串,计算后返回它大概会占去的高度
 
 @param str 传入的字符串
 @return 返回高度<字符串为空,默认返回55>
 */
+ (CGFloat )getTheAboutHeightWithString:(NSString *)str {
    if (str.length) {
        NSDictionary *attributes = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:16]};
        return [str boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 124, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingUsesDeviceMetrics | NSStringDrawingTruncatesLastVisibleLine   attributes:attributes context:nil].size.height;
    }
    return 55.f;
    
    
}


/**
 传入系统消息字符串,计算后返回它大概会占取的高度
 
 @param str 传入的字符串
 @return 返回高度<字符串为空,默认返回55>
 */
+ (CGFloat )getAboutMessageHeightWithString:(NSString *)str {
    if (str.length) {
        NSDictionary *attributes = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:15]};
        return [str boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingUsesDeviceMetrics | NSStringDrawingTruncatesLastVisibleLine   attributes:attributes context:nil].size.height;
    }else {
        return 20;
    }
}



/**
 资讯, 新闻, 自选股新闻详情界面的标题动态计算高度然后返回
 
 @param title 传入的标题
 @return 返回相应的高度
 */
+ (CGFloat )getNewsDetailTitleHeightWithTtile:(NSString *)title {
    
    if (title.length) {
        NSDictionary *attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:26]};
        CGFloat height = [title boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingUsesDeviceMetrics | NSStringDrawingTruncatesLastVisibleLine   attributes:attributes context:nil].size.height;
        return height;
        
    }
    return 35.f;
}



/**
 传入一个数字字符串,转换返回分割后的数字, 没有小数位
 
 @param num 传入的数字字符串
 @return 123456789-->123,456,789
 */
+(NSString *)getNumberFormatWithNum:(NSString *)num {
    //    if (![IBGlobalMethod judgePureNumVilade:num]) {
    //        return num;
    //    }
    if (num == nil ) {
        return @"--";
    }
    if (![num isKindOfClass:[NSString class]]) {
        num = [NSString stringWithFormat:@"%@", num];
    }
    if ([num containsString:@"不"]) {
        return @"--";
    }
    if ([num isEqualToString:@""]) {
        return @"--";
    }
    if ([num isEqualToString:@"--"]) {
        return @"--";
    }
    if ([num containsString:@","]) {
        return num;
    }
    if ([num doubleValue] == 0) {
        return @"0";
    }
    
    
    
    double a = [num doubleValue];
    NSString *halfStr;
    NSMutableString *newStr = [NSMutableString string];
    if (a > 0) {
        halfStr = [NSString stringWithFormat:@"%.f", a];
    }else {
        halfStr = [[NSString stringWithFormat:@"%.f", a] componentsSeparatedByString:@"-"].lastObject;
    }
    
    
    //NSString *halfStr = [NSString stringWithFormat:@"%.f", a];
    NSString *intStr = [halfStr componentsSeparatedByString:@"."].firstObject;
    //NSString *floatStr = [halfStr componentsSeparatedByString:@"."].lastObject;
    NSMutableString *str = [[NSMutableString alloc] initWithString:intStr];
    // NSMutableString *newStr = [NSMutableString string];
    while (str.length > 3) {
        NSRange range = NSMakeRange(str.length - 3, 3);
        NSString *str1 = [NSString stringWithFormat:@",%@", [str substringWithRange:range]];
        [newStr insertString:str1 atIndex:0];
        [str deleteCharactersInRange:range];
    }
    [newStr insertString:str atIndex:0];
    //     [newStr appendString:[NSString stringWithFormat:@".%@", floatStr]];
    if (a > 0) {
        return newStr;
    }else {
        return [NSString stringWithFormat:@"-%@", newStr];
    }
}

/**
 传入一个数字字符串,转换返回分割后的数字, 一位小数
 
 @param num 传入的数字字符串
 @return 123456789-->123,456,789.0
 */
+(NSString *)getNumberFormatPointWithNum:(NSString *)num {
    if (num == nil ) {
        return @"0.0";
    }
    if (![num isKindOfClass:[NSString class]]) {
        num = [NSString stringWithFormat:@"%@", num];
    }
    if ([num isEqualToString:@""]) {
        return @"0.0";
    }
    if ([num doubleValue] == 0) {
        return @"0.0";
    }
    if ([num isEqualToString:@"--"]) {
        return @"--";
    }
    if ([num containsString:@","]) {
        return num;
    }
    double a = [num doubleValue];
    
    NSString *halfStr;
    NSMutableString *newStr = [NSMutableString string];
    if (a > 0) {
        halfStr = [NSString stringWithFormat:@"%.1f", a];
    }else {
        halfStr = [[NSString stringWithFormat:@"%.1f", a] componentsSeparatedByString:@"-"].lastObject;
    }
    NSString *intStr = [halfStr componentsSeparatedByString:@"."].firstObject;
    NSString *floatStr = [halfStr componentsSeparatedByString:@"."].lastObject;
    NSMutableString *str = [[NSMutableString alloc] initWithString:intStr];
    while (str.length > 3) {
        NSRange range = NSMakeRange(str.length - 3, 3);
        NSString *str1 = [NSString stringWithFormat:@",%@", [str substringWithRange:range]];
        [newStr insertString:str1 atIndex:0];
        [str deleteCharactersInRange:range];
    }
    [newStr insertString:str atIndex:0];
    [newStr appendString:[NSString stringWithFormat:@".%@", floatStr]];
    if (a > 0) {
        return newStr;
    }else {
        return [NSString stringWithFormat:@"-%@", newStr];
    }
}




/**
 传入一个字符串, 转换后返回分割后的资金专用的二位小数数字
 
 @param num 传入的数字字符串
 
 @return 123456789-->123,456,789.00
 */
+(NSString *)getNumberFormaPropertytWithNum:(NSString *)num {
    //    if (![IBGlobalMethod judgePureNumVilade:num]) {
    //        return num;
    //    }
    if (num == nil ) {
        return @"--";
    }
    if (![num isKindOfClass:[NSString class]]) {
        num = [NSString stringWithFormat:@"%@", num];
    }
    if ([num isEqualToString:@""]) {
        return @"--";
    }
    if ([num containsString:@"不"]) {
        return @"--";
    }
    if ([num doubleValue] == 0) {
        return @"0.00";
    }
    
    
    if ([num isEqualToString:@"--"]) {
        return @"--";
    }
    if ([num containsString:@","]) {
        return num;
    }
    double a = [num doubleValue];
    
    NSString *halfStr;
    NSMutableString *newStr = [NSMutableString string];
    if (a > 0) {
        halfStr = [NSString stringWithFormat:@"%.2f", a];
    }else {
        halfStr = [[NSString stringWithFormat:@"%.2f", a] componentsSeparatedByString:@"-"].lastObject;
    }
    
    //NSString *halfStr = [NSString stringWithFormat:@"%.2f", a];
    NSString *intStr = [halfStr componentsSeparatedByString:@"."].firstObject;
    NSString *floatStr = [halfStr componentsSeparatedByString:@"."].lastObject;
    NSMutableString *str = [[NSMutableString alloc] initWithString:intStr];
    // NSMutableString *newStr = [NSMutableString string];
    while (str.length > 3) {
        NSRange range = NSMakeRange(str.length - 3, 3);
        NSString *str1 = [NSString stringWithFormat:@",%@", [str substringWithRange:range]];
        [newStr insertString:str1 atIndex:0];
        [str deleteCharactersInRange:range];
    }
    [newStr insertString:str atIndex:0];
    [newStr appendString:[NSString stringWithFormat:@".%@", floatStr]];
    if (a > 0) {
        return newStr;
    }else {
        return [NSString stringWithFormat:@"-%@", newStr];
    }
}




/**
 传入一个字符串, 转换后返回分割后的股价专用三位小数数字
 
 @param num 数字
 @return 123456789-->123,456,789.000
 */
+(NSString *)getNumberFormaStockPricetWithNum:(NSString *)num {
    //    if (![IBGlobalMethod judgePureNumVilade:num]) {
    //        return num;
    //    }
    
    if (num == nil ) {
        return @"--";
    }
    if (![num isKindOfClass:[NSString class]]) {
        num = [NSString stringWithFormat:@"%@", num];
    }
    if ([num containsString:@"不"]) {
        return @"--";
    }
    if ([num isEqualToString:@""]) {
        return @"--";
    }
    if ([num doubleValue] == 0) {
        return @"0.000";
    }
    
    if ([num isEqualToString:@"--"]) {
        return @"--";
    }
    if ([num containsString:@","]) {
        return num;
    }
    double a = [num doubleValue];
    
    NSString *halfStr;
    NSMutableString *newStr = [NSMutableString string];
    
    if (a > 0) {
        halfStr = [NSString stringWithFormat:@"%.3f", a];
    }else {
        halfStr = [[NSString stringWithFormat:@"%.3f", a] componentsSeparatedByString:@"-"].lastObject;
    }
    NSString *intStr = [halfStr componentsSeparatedByString:@"."].firstObject;
    NSString *floatStr = [halfStr componentsSeparatedByString:@"."].lastObject;
    NSMutableString *str = [[NSMutableString alloc] initWithString:intStr];
    while (str.length > 3) {
        NSRange range = NSMakeRange(str.length - 3, 3);
        NSString *str1 = [NSString stringWithFormat:@",%@", [str substringWithRange:range]];
        [newStr insertString:str1 atIndex:0];
        [str deleteCharactersInRange:range];
    }
    [newStr insertString:str atIndex:0];
    [newStr appendString:[NSString stringWithFormat:@".%@", floatStr]];
    if (a > 0) {
        return newStr;
    }else {
        return [NSString stringWithFormat:@"-%@", newStr];
    }
    
    
}





/**
 传入一个字符串, 转换后返回分割带四位小数的数字
 
 @param num 传入数字
 @return 返回格式后的数据
 */
+ (NSString *)getNumberFormatFourPointWithNum:(NSString *)num {
    //    if (![IBGlobalMethod judgePureNumVilade:num]) {
    //        return num;
    //    }
    if (num == nil ) {
        return @"--";
    }
    if (![num isKindOfClass:[NSString class]]) {
        num = [NSString stringWithFormat:@"%@", num];
    }
    if ([num containsString:@"不"]) {
        return @"--";
    }
    if ([num doubleValue] == 0) {
        return @"0.0000";
    }
    if ([num isEqualToString:@""]) {
        return @"--";
    }
    if ([num isEqualToString:@"--"]) {
        return @"--";
    }
    if ([num containsString:@","]) {
        return num;
    }
    double a = [num doubleValue];
    
    NSString *halfStr;
    NSMutableString *newStr = [NSMutableString string];
    
    if (a > 0) {
        halfStr = [NSString stringWithFormat:@"%.4f", a];
    }else {
        halfStr = [[NSString stringWithFormat:@"%.4f", a] componentsSeparatedByString:@"-"].lastObject;
    }
    
    
    NSString *intStr = [halfStr componentsSeparatedByString:@"."].firstObject;
    NSString *floatStr = [halfStr componentsSeparatedByString:@"."].lastObject;
    NSMutableString *str = [[NSMutableString alloc] initWithString:intStr];
    while (str.length > 3) {
        NSRange range = NSMakeRange(str.length - 3, 3);
        NSString *str1 = [NSString stringWithFormat:@"，%@", [str substringWithRange:range]];
        [newStr insertString:str1 atIndex:0];
        [str deleteCharactersInRange:range];
    }
    [newStr insertString:str atIndex:0];
    
    NSMutableString *muFloatStr = [[NSMutableString alloc] initWithString:floatStr];
    //    [muFloatStr insertString:@"," atIndex:3];
    [newStr appendString:[NSString stringWithFormat:@".%@", muFloatStr]];
    
    
    
    if (a > 0) {
        return newStr;
    }else {
        return [NSString stringWithFormat:@"-%@", newStr];
    }
}






/**
 传入一个字符串, 转换后返回分割后的数字, 与上面的去别就是, 不限制小数的位数
 
 
 @param num  数字
 @return 123.456789-->123.456,789
 */
+ (NSString *)getNumCustomWithNum:(NSString *)num{
    //    if (![IBGlobalMethod judgePureNumVilade:num]) {
    //        return num;
    //    }
    if (num == nil ) {
        return @"--";
    }
    if (![num isKindOfClass:[NSString class]]) {
        num = [NSString stringWithFormat:@"%@", num];
    }
    if ([num containsString:@"不"]) {
        return @"--";
    }
    if ([num isEqualToString:@""]) {
        return @"--";
    }
    if ([num doubleValue] == 0 && num.length) {
        return num;
    }
    if ([num isEqualToString:@"--"]) {
        return @"--";
    }
    if ([num containsString:@","]) {
        return num;
    }
    double a = [num doubleValue];
    
    NSString *halfStr = num;
    NSMutableString *newStr = [NSMutableString string];
    
    NSString *intStr;
    NSString *floatStr;
    BOOL containDot = NO;
    if ([halfStr containsString:@"."]) {
        containDot = YES;
        NSString *halfStr = num;
        intStr = [halfStr componentsSeparatedByString:@"."].firstObject;
        floatStr = [halfStr componentsSeparatedByString:@"."].lastObject;
    }else {
        intStr = num;
        floatStr = @"";
    }
    NSMutableString *str = [[NSMutableString alloc] initWithString:intStr];
    while (str.length > 3) {
        NSRange range = NSMakeRange(str.length - 3, 3);
        NSString *str1 = [NSString stringWithFormat:@",%@", [str substringWithRange:range]];
        [newStr insertString:str1 atIndex:0];
        [str deleteCharactersInRange:range];
    }
    [newStr insertString:str atIndex:0];
    if (containDot) {
        [newStr appendString:[NSString stringWithFormat:@".%@", floatStr]];
    }
    if (a > 0) {
        return newStr;
    }else {
        return [NSString stringWithFormat:@"-%@", newStr];
    }
}








/**
 *  传入字符串后返回一个富文本NSMutableAttributedString
 *
 *  @param str      需要转换的字符串
 *  @param color    转换后的颜色
 *  @param fontSize 转换后的字体大小
 *  @param range1   转换范围1
 *  @param range2   转换范围2
 *
 *  @return 返回的NSMutableAttributedString
 */
+ (NSMutableAttributedString *)getNSMutableAttributedStringWithString:(NSString *)str theColor:(UIColor *)color  theFontSize:(CGFloat)fontSize theRange1:(NSRange )range1 theRange2:(NSRange)range2 {
    if (str.length > 0) {
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:str];
        [string addAttributes:@{NSForegroundColorAttributeName : color, NSFontAttributeName : [UIFont systemFontOfSize:fontSize]} range:range1];
        [string addAttributes:@{NSForegroundColorAttributeName : color, NSFontAttributeName : [UIFont systemFontOfSize:fontSize]} range:range2];
        return string;
    }
    return nil;
}



/**
 交易获取请求时返回相应code的提示语
 
 @param code 传入的code
 @return 返回的提示语
 */
+ (NSString *)getTradeRequestInforWithCode:(NSString *)code {
    switch ([code integerValue]) {
        case 0:
            return @"";
            break;
        case -1:
            return CustomLocalizedString(@"FX_BU_XITONGANSHIWUFATIGONGFUWU", nil);
            break;
        case -2:
            return CustomLocalizedString(@"FX_BU_CHAOSHIQINGCHONGIXNDENGLU", nil);
            break;
        case -3:
            return CustomLocalizedString(@"FX_BU_WUFALIANJIESUOYOUHOUTAIFUWU", nil);
            break;
        case -4:
            return CustomLocalizedString(@"FX_BU_XITONGWUFALIANJIEHOUTAIJIAOYIXITONG", nil);
            break;
        case -5:
            return CustomLocalizedString(@"FX_BU_WUFALIANJIEHOUTAIBAOJIAFUWU", nil);
            break;
        case -6:
            return CustomLocalizedString(@"FX_BU_CHUANRUCANSHUCUOWU", nil);
            break;
        case -7:
            return CustomLocalizedString(@"FX_BU_BAOJIACANSHUCUOWU", nil);
            break;
        case -8:
            return CustomLocalizedString(@"FX_BU_ESCANSHUCUOWU", nil);
            break;
        case -9:
            return CustomLocalizedString(@"FX_BU_WUFALIANJIEDAOHOUTAIESFUWU", nil);
            break;
        case -10:
            return CustomLocalizedString(@"FX_BU_GAIZHANGHAOWUMORENJIAOYIZHANGHAO", nil);
            break;
        case -11:
            return CustomLocalizedString(@"FX_BU_GAIDENGLUZHANGHAOBUYUXUJIAOYI", nil);
            break;
        case -14:
            return CustomLocalizedString(@"FX_BU_JIAOYIQUDAOZANTINGFUWU", nil);
            break;
        case -100:
            return CustomLocalizedString(@"FX_BU_GEXIAZHISHIJINECUOWU", nil);
            break;
        case -101:
            return CustomLocalizedString(@"FX_BU_DIANZIZHUANZHANGZANSHIWEINENGTIGONGFUWU", nil);
            break;
        case -102:
            return CustomLocalizedString(@"FX_BU_SHURUMIMACUOWU", nil);
        default:
            return @"";
            break;
    }
}





/**
 *  传入一个字典和一个key，取key对应的字符串形value，有就返回，没有就返回@""
 *
 *  @param dict  字典
 *  @param key   key
 *  @return      value
 */
+ (NSString *)getStringWithDictionary:(NSDictionary *)dict andForKey:(NSString *)key {
    if (!dict) {
        return @"";
    }
    
    
    if ([dict isKindOfClass:[NSNull class]]) {
        return @"";
    }
    
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return @"";
    }
    
    if ([dict allKeys].count == 0) {
        return @"";
    }
    
    if ([[dict allKeys] containsObject:key]) {
        if (![dict[key] isKindOfClass:[NSNull class]]) {
            return [NSString stringWithFormat:@"%@",dict[key]];
        }else{
            return @"";
        }
    }else{
        return @"";
    }
}


/**
 获取联交所的订单状态
 
 @param str 传入字符串
 @param direction  买卖方向
 @return 转换成状态
 */
+ (NSString *)getMORSStatusWithString:(NSString *)str withOrderDirection:(NSString *)direction {
    NSArray *strArr = @[@"PARTIALLY FILLED", @"TRANSMITTING", @"REJECTED", @"CANCELLED", @"COMPLETELY_FILLED", @"QUEUING", @"RECEIVED", @"PARTIALLY_FILLED_COMPLETED"];
    
    NSString *directionStr ;
    if ([direction isEqualToString:@"B"]) {
        directionStr = CustomLocalizedString(@"FX_BU_MAIRU", nil);
    }
    if ([direction isEqualToString:@"S"]) {
        directionStr = CustomLocalizedString(@"FX_BU_MAICHU", nil);
    }
    
    
    
    
    
    NSArray *statusArr = @[[NSString stringWithFormat:@"%@%@", directionStr,CustomLocalizedString(@"FX_BU_BUCHENG", nil)], [NSString stringWithFormat:@"%@%@", directionStr,CustomLocalizedString(@"TRADE_CHUANSONGZHONG", nil)], [NSString stringWithFormat:@"%@%@", directionStr,CustomLocalizedString(@"TRADE_YIJUJUE", nil)], [NSString stringWithFormat:@"%@%@", directionStr,CustomLocalizedString(@"FX_BU_YIQUXIAO", nil)], [NSString stringWithFormat:@"%@%@", directionStr,CustomLocalizedString(@"TRADE_YIWANCHENG", nil)], [NSString stringWithFormat:@"%@%@", directionStr,CustomLocalizedString(@"TRADE_GUAPANZHONG", nil)], [NSString stringWithFormat:@"%@%@", directionStr,CustomLocalizedString(@"TRADE_YIJIESHOU", nil)],  [NSString stringWithFormat:@"%@%@", directionStr,CustomLocalizedString(@"TRADE_BUCHE", nil)]];
    if ([strArr containsObject:str]) {
        return [statusArr objectAtIndex:[strArr indexOfObject:str]];
    }else {
        return @"";
    }
}





/**
 获取联交所订单类型
 
 @param str  传入字符串
 @return 返回相应状态
 */
+ (NSString *)getORTPStatusWithString:(NSString *)str {
    NSArray *strArr = @[@"AT_AUCTION", @"ENHANCED_LIMIT", @"LIMIT", @"AT_AUCTION_LIMIT", @"SPECIAL_LIMIT", @"CONDITIONAL"];
    NSArray *statusArr = @[CustomLocalizedString(@"FX_BU_A0JIGJIAPAN", nil), CustomLocalizedString(@"FX_BU_ELOZENGQINGXIAJIAPAN", nil), CustomLocalizedString(@"FX_BU_LOXIANJIAPAN", nil), CustomLocalizedString(@"FX_BU_ALOJINGJIAXIANJIAPAN", nil), CustomLocalizedString(@"FX_BU_SLOTEBIEXIANJIAPAN", nil), CustomLocalizedString(@"FX_BU_COTIAOJIANZHISHIPAN", nil)];
    if ([strArr containsObject:str]) {
        return [statusArr objectAtIndex:[strArr indexOfObject:str]];
    }else {
        return @"";
    }
    
}


/**
 返回交易登录时返回的语句, 成功或者失败
 
 @param str 返回的code
 @return 返回提示语
 */
+ (NSString *)getTradeLoginStatusWithString:(NSString *)str {
    NSArray *strArr = @[@"NORMAL",
                        @"CHGPASS",
                        @"GRACELOGIN",
                        @"ISSUED",
                        @"INVIDPASS",
                        @"INVIDLOGID",
                        @"SUSPENDED",
                        @"RETRYCNT",
                        @"GRACECNT",
                        @"CHAADNORMAL",
                        @"CHASUSP",
                        @"LOCKED",
                        @"LOGIDNACT"];
    NSArray *statusArr = @[CustomLocalizedString(@"NORMALTRADELOGINDES", nil),
                           CustomLocalizedString(@"CHGPASSTRADELOGINDES", nil),
                           CustomLocalizedString(@"GRACELOGINTRADELOGINDES", nil),
                           CustomLocalizedString(@"ISSUEDTRADELOGINDES", nil),
                           CustomLocalizedString(@"INVIDPASSTRADELOGINDES", nil),
                           CustomLocalizedString(@"INVIDLOGIDTRADELOGINDES", nil),
                           CustomLocalizedString(@"SUSPENDEDTRADELOGINDES", nil),
                           CustomLocalizedString(@"RETRYCNTTRADELOGINDES", nil),
                           CustomLocalizedString(@"GRACECNTTRADELOGINDES", nil),
                           CustomLocalizedString(@"CHAADNORMALTRADELOGINDES", nil),
                           CustomLocalizedString(@"CHASUSPTRADELOGINDES", nil),
                           CustomLocalizedString(@"LOCKEDTRADELOGINDES", nil),
                           CustomLocalizedString(@"LOGIDNACT_NOT_ACTIVE", nil)];
    if (str.length) {
        if ([strArr containsObject:str]) {
            return [statusArr objectAtIndex:[strArr indexOfObject:str]];
        }else {
            return CustomLocalizedString(@"OTHERTRADELOGINDES", nil);
        }
    }else {
        return CustomLocalizedString(@"OTHERTRADELOGINDES", nil);
    }
    
}



/**
 为通用的iBest请求加上签名
 
 @return 返回一个签名后的dic, 然后把自己的参数set进去就可
 */
+ (NSMutableDictionary *)getSignIBestRequestWithSession {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"sessionId"] = [IBGlobalMethod getAppLoginSession];
    return dic;
    
}


/**
 *  传入相应的时间戳,返回对应的时间
 *
 *  @param timeIntervalString 传入的时间戳字符串
 *
 *  @return 返回的日期
 */
+ (NSString *)getTheNSDateStringWithTheTimeNSTimeIntervalString:(NSString *)timeIntervalString {
    NSString *timeStr;
    if (timeIntervalString.length == 10) {//精确到s
        timeStr = timeIntervalString;
    }else if (timeIntervalString.length == 13) {//精确到ms
        timeStr = [timeIntervalString substringToIndex:10];
    }else {
        timeStr = timeIntervalString;
    }
    NSTimeInterval timeIntervel1 = [timeStr floatValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeIntervel1];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    //    NSDateFormatter *formatter = getDateFormatter();
    NSString *dateStr = [formatter stringFromDate:date];
    if (timeIntervalString.length) {
        return [dateStr substringToIndex:10];
    }else {
        return @"";
    }
}





/**
 *  传入相应的时间戳,返回对应的时间
 *
 *  @param timeIntervalString 传入的时间戳字符串
 *
 *  @return 返回的 xx月xx日
 */
+ (NSString *)getTheMDDateStringWithTheTimeNSTimeIntervalString:(NSString *)timeIntervalString {
    
    NSString *timeStr;
    if (timeIntervalString.length == 10) {//精确到s
        timeStr = timeIntervalString;
    }else if (timeIntervalString.length == 13) {//精确到ms
        timeStr = [timeIntervalString substringToIndex:10];
    }else {
        timeStr = timeIntervalString;
    }
    NSTimeInterval timeIntervel1 = [timeStr floatValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeIntervel1];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM月dd日"];
    NSString *dateStr = [formatter stringFromDate:date];
    if (timeIntervalString.length) {
        return dateStr;
    }else {
        return @"";
    }
}


/**
 *  传入相应的时间戳,返回对应的时间
 *
 *  @param timeIntervalString 传入的时间戳字符串
 *
 *  @return 返回的日期 如xxxx/xx/xx
 */
+ (NSString *)getOtherTheNSDateStringWithTheTimeNSTimeIntervalString:(NSString *)timeIntervalString {
    NSString *timeStr;
    if (timeIntervalString.length == 10) {//精确到s
        timeStr = timeIntervalString;
    }else if (timeIntervalString.length == 13) {//精确到ms
        timeStr = [timeIntervalString substringToIndex:10];
    }else {
        timeStr = timeIntervalString;
    }
    NSTimeInterval timeIntervel1 = [timeStr floatValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeIntervel1];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY/MM/dd HH:mm:ss"];
    NSString *dateStr = [formatter stringFromDate:date];
    if (timeIntervalString.length) {
        return [dateStr substringToIndex:10];
    }else {
        return @"";
    }
}

/**
 *  传入相应的时间戳,返回对应的时间
 *
 *  @param timeIntervalString 传入的时间戳字符串
 *
 *  @return 返回的日期 如HH:mm:ss
 */
+ (NSString *)getOtherTheTimeStringWithTheTimeNSTimeIntervalString:(NSString *)timeIntervalString {
    NSString *timeStr;
    if (timeIntervalString.length == 10) {//精确到s
        timeStr = timeIntervalString;
    }else if (timeIntervalString.length == 13) {//精确到ms
        timeStr = [timeIntervalString substringToIndex:10];
    }else {
        timeStr = timeIntervalString;
    }
    NSTimeInterval timeIntervel1 = [timeStr floatValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeIntervel1];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    NSString *dateStr = [formatter stringFromDate:date];
    if (timeIntervalString.length) {
        return dateStr ;
    }else {
        return @"";
    }
}


/**
 *  传入相应的时间戳,返回对应的时间
 *
 *  @param timeIntervalString 传入的时间戳字符串
 *
 *  @return 返回的日期 如xx:xx xx:xx
 */
+ (NSString *)getTheNSDateTimeStringWithTheTimeNSTimeIntervalString:(NSString *)timeIntervalString {
    NSString *timeStr;
    if (timeIntervalString.length == 10) {//精确到s
        timeStr = timeIntervalString;
    }else if (timeIntervalString.length == 13) {//精确到ms
        timeStr = [timeIntervalString substringToIndex:10];
    }else {
        timeStr = timeIntervalString;
    }
    NSTimeInterval timeIntervel1 = [timeStr floatValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeIntervel1];
    
    
    
    //    NSDateFormatter *formatter = getDateFormatter();
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *dateStr = [formatter stringFromDate:date];
    
    if (timeIntervalString.length) {
        return [dateStr substringWithRange:NSMakeRange(5,11)];
        return dateStr;
    }else {
        return @"";
    }
}





/**
 *  传入相应的时间戳,返回对应的时间-只有日期+时间
 *
 *  @param timeIntervalString 传入的时间戳字符串
 *
 *  @return 返回的日期--只有日期+时间
 */
+ (NSString *)getDateStringWithString:(NSString *)timeInterval {
    NSString *timeStr;
    if (timeInterval.length == 10) {//精确到s
        timeStr = timeInterval;
    }else if (timeInterval.length == 13) {//精确到ms
        timeStr = [timeInterval substringToIndex:10];
    }else {
        timeStr = timeInterval;
    }
    NSTimeInterval timeIntervel1 = [timeStr floatValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeIntervel1];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *dateStr = [formatter stringFromDate:date];
    if (timeInterval.length) {
        return [dateStr substringWithRange:NSMakeRange(5, 11)];
    }else {
        return @"";
    }
}


/**
 *  传入相应的时间戳,返回对应的时间-只有日期+时间
 *
 *  @param timeInterval 传入的时间戳字符串
 *
 *  @return 返回的日期--只有年份
 */
+ (NSString *)getYearStringWithString:(NSString *)timeInterval {
    NSString *timeStr;
    if (timeInterval.length == 10) {//精确到s
        timeStr = timeInterval;
    }else if (timeInterval.length == 13) {//精确到ms
        timeStr = [timeInterval substringToIndex:10];
    }else {
        timeStr = timeInterval;
    }
    NSTimeInterval timeIntervel1 = [timeStr floatValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeIntervel1];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY"];
    NSString *dateStr = [formatter stringFromDate:date];
    if (timeInterval.length) {
        return dateStr;
    }else {
        return @"";
    }
}

/**
 获取错误码对应的提示信息
 
 @param infor 错误码
 @return 对应的提示信息
 */
+ (NSString *)getErrorInforWithString:(NSString *)infor {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"errorCode" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSMutableDictionary *dic =  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSString *inforStr = [IBXHelpers getStringWithDictionary:dic andForKey:infor];
    if (infor.length) {
        return inforStr.length > 0 ? inforStr : [NSString stringWithFormat:@"%@", infor];
    }else {
        return @"--";
    }
}


/**
 获取全球唯一标志符
 
 @return 返回这个标识符
 */
+ (NSString *)getOnlyGUID {
    
    //    NSString *timeInterviel = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
    //    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    //    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    //    CFRelease(uuid_ref);
    //    NSString *uuid = [NSString stringWithString:(__bridge NSString*)uuid_string_ref];
    //    CFRelease(uuid_string_ref);
    //    return uuid;
    NSString * result;
    CFUUIDRef uuid;
    CFStringRef uuidStr;
    NSString *prefix =  [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
    uuid = CFUUIDCreate(NULL);
    assert(uuid != NULL);
    uuidStr = CFUUIDCreateString(NULL, uuid);
    assert(uuidStr != NULL);
    //  result = [NSTemporaryDirectory()stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-666666-%@", prefix, uuidStr]];
    result = [NSString stringWithFormat:@"%@-%@", prefix, uuidStr];
    assert(result != nil);
    CFRelease(uuidStr);
    CFRelease(uuid);
    return [CDTDataEncryAndDecry decryWithMD5:result];
}




+(NSString *)simplifiedOrTraditionalBySystem
{
    IBLanguageShowType type = [IBTheme() getIBLanguageShowType];
    if(type == IBLanguageShowTypeSimpleChinese)
    {
        return @"BG25";
    }
    else if (type == IBLanguageShowTypeTraditionChinese)
    {
        return @"ST25";
    }
    else
    {
        return @"SE25";
    }
    //return nil;
}




/**
 获取当前的网络状态
 
 @return 返回当前的网络状态
 */
+ (NetWorkStatus)getNetWorkStatus {
    MReachability *reachAbility = [MReachability reachabilityWithHostName:@"www.baidu.com"] ;
    return (NetWorkStatus)[reachAbility currentReachabilityStatus];
    
}


/**
 当网络不可用时----检测网络, 然后跳转到检测网络界面
 */
+ (void)checkTheNetWorkStatus {
    [QNAlertView clearSharedQueue];
    UIViewController *visibleVC = [QNViewUtils visibleViewController:MainController()];
    
    
    UIAlertController *altC = [UIAlertController alertControllerWithTitle:@"提示" message:@"当前网络状态不可用.." preferredStyle:UIAlertControllerStyleAlert];
    [altC addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil]];
    [visibleVC presentViewController:altC animated:YES completion:nil];
    
}



/**
 根据传入的时间戳显示新闻的发布时间, 例如:刚刚, 今天, 几月几号
 
 @param timeInterval 时间戳字符串
 @return 返回封装时间
 */
+ (nullable NSString *)getNewsDateWithInterval:(nullable NSString *)timeInterval {
    NSTimeInterval interval ;
    if (timeInterval.length == 13) {
        interval =  [timeInterval longLongValue] /1000;
    }else {
        interval =  [timeInterval longLongValue] ;
    }
    NSString * timeStr = [NSDate timerShaftStringWithTimeStamp:interval];
    return timeStr;
    
}


/**
 数据转化为JSON
 
 @param data 传入的数据
 @return 返回JSON字符串
 */
+ (nullable NSString *)getJSONWithData:(nullable id)data {
    NSData *nsData = [NSJSONSerialization dataWithJSONObject:data options:0 error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:nsData encoding:NSUTF8StringEncoding];
    return jsonStr;
}

/**
 json字符串转换为字典
 
 @param jsonStr 字符串
 @return 返回结果
 */
+ (NSMutableDictionary *)getDicFormJsonStr:(NSString *)jsonStr {
    if (jsonStr == nil || jsonStr.length < 1) {
        return [NSMutableDictionary dictionaryWithCapacity:0];
    }
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return [dic  mutableCopy];
}


/**
 校验输入密码是否合乎规则:6-8位的数字密码混合
 
 @param psw 输入的密码
 @return YES:合乎标准, NO:不合乎标准
 */
+ ( BOOL)getTradePSWIsQualifiedWithPSW:(nullable NSString *)psw {
    NSString *regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,8}$";
    NSPredicate *   pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:psw];
}


/**
 根据自定义协议解析出来一个字典
 
 @param urlString 传入的URL
 @return 返回的字典
 */
+ (NSDictionary *)getAnalysisDicWithUrl:(NSString *)urlString {
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString *haveNoHeadUrl = [urlString componentsSeparatedByString:@"://"].lastObject;
    NSArray *contentTypeArr = [haveNoHeadUrl componentsSeparatedByString:@"?"];
    
    NSString *bigType = contentTypeArr.firstObject;
    [contentDic setValue:bigType forKey:@"bigType"];
    //    if ([urlString containsString:@"DEEPLINK"] || [urlString containsString:@"deeplink"]) {
    //        [contentDic setValue:@"DEEPLINK" forKey:@"bigType"];
    //    }
    NSArray *contentArr = [contentTypeArr.lastObject componentsSeparatedByString:@"&"];
    for (NSString *contetStr in contentArr) {
        NSArray *content = [contetStr componentsSeparatedByString:@"="];
        [contentDic setValue:content.lastObject forKey:content.firstObject];
    }
    if ([bigType isEqualToString:@"URL"] || [contentDic[@"a"] isEqualToString:@"OPEN_URL"]) {
        NSString *urlStr = contentDic[@"argi"];
        if ([urlString containsString:@"http"] || [urlString containsString:@"https"]) {
            [contentDic setValue: [urlStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"argi"];
        }
    }
    if ([contentDic[@"a"] isEqualToString:@"DEEPLINK"]) {
        NSString *urlStr = contentDic[@"argi"];
        [contentDic setValue: [urlStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"argi"];
    }
    
    return contentDic;
}





/**
 更具代码获取相应的市场
 
 @param code 代码
 @return 返回的市场
 */
+ (NSString *)getMarketWithCode:(NSString *)code {
    if ([code isEqualToString:@"HK"]) {
        return  CustomLocalizedString(@"XIANGGANGJIAGUSHICHANG", nil);
    }else if ([code isEqualToString:@"US"]) {
        return CustomLocalizedString(@"TRADE_MEIGUOSHICHANG", nil);
    }else if ([code isEqualToString:@"BSHARE"]) {
        return CustomLocalizedString(@"TRADE_ZHONGGUOBGUSHICHANG", nil);
    }else if ([code isEqualToString:@"GENERAL"]) {
        return CustomLocalizedString(@"TRADE_QITASHICHANG", nil);
    }else {
        return  code;
    }
}


/**
 通过字符串匹配交易渠道
 
 @param code 代码
 @return 返回渠道
 */
+ (NSString *)getDealMediumWithCode:(NSString *)code {
    
    if ([code isEqualToString:@"STT"]) {
        return CustomLocalizedString(@"FX_BU_ZHIZUNBAO", nil);
    }else if ([code isEqualToString:@"Web"] || [code isEqualToString:@"WEB"] || [code isEqualToString:@"web"]) {
        return CustomLocalizedString(@"FX_BU_WANGSHANGJIAOYI", nil);
    }else if ([code isEqualToString:@"TERMINAL"]) {
        return CustomLocalizedString(@"FX_BU_JINGJI", nil);
    }else if ([code isEqualToString:@"ONLINE"]) {
        return CustomLocalizedString(@"FX_BU_WANGLUO", nil);
    }else if ([code isEqualToString:@"WMT"]) {
        return CustomLocalizedString(@"FX_BU_LIUDONGJIAOYI", nil);
    }else if ([code isEqualToString:@"TDX"]) {
        return CustomLocalizedString(@"FX_BU_FUHZHONGBAO", nil);
    }else if ([code isEqualToString:@"ZZB"]) {
        return CustomLocalizedString(@"FX_BU_ZHAONGHZONGBAO", nil);
    }else if ([code isEqualToString:@"WLS-WSEC"]) {
        return CustomLocalizedString(@"FX_BU_WANGSHANGJIAOYIWL", nil);
    }else if ([code isEqualToString:@"SMT"]) {
        return CustomLocalizedString(@"FX_BU_ZHINENGSHOUJI", nil);
    }else if ([code isEqualToString:@"ETM"]) {
        return CustomLocalizedString(@"FX_BU_JINGJITONG", nil);
    }else if ([code isEqualToString:@"QQM"]) {
        return CustomLocalizedString(@"FX_BU_TENGXUNZIXUANGU", nil);
    }else if ([code isEqualToString:@"MPT"]) {
        return CustomLocalizedString(@"FX_BU_XIXIBAOWANGSHANGBAN", nil);
    }else if ([code isEqualToString:@"MMT"]) {
        return CustomLocalizedString(@"FX_BU_XIXIBAOLIUDONGBAN", nil);
    }else if ([code isEqualToString:@"ALI"]) {
        return CustomLocalizedString(@"FX_BU_ZHIFUBAO", nil);
    }else {
        return code;
    }
}


/**
 *  传入字典和对应的key取出数值后,精度调整后返回字符串,防止进度丢失
 *
 *  @param dictionary 传入的字典
 *  @param key        字典中的key
 *
 *  @return 返回字符串
 */
+ (NSString *_Nullable)getNumFromDictionaryValueWithDictionary:(NSDictionary *_Nullable)dictionary key:(NSString *_Nullable)key {
    if ([dictionary isKindOfClass:[NSDictionary class]]) {
        NSString *returnStr = @"";
        if (![dictionary[key] isEqual:[NSNull null]] && dictionary[key]) {
            id value = dictionary[key];
            if ([value isKindOfClass:[NSNumber class]]){
                if(strcmp([value objCType], @encode(BOOL)) == 0) {
                    [value boolValue];
                }
                else if(strcmp([value objCType], @encode(int)) == 0)  {
                    returnStr = [value stringValue];
                }
                else if(strcmp([value objCType], @encode(unsigned int)) == 0) {
                    returnStr = [value stringValue];
                }
                else if(strcmp([value objCType], @encode(long)) == 0)  {
                    returnStr = [value stringValue];
                }
                else if (strcmp([value objCType], @encode(long long)) == 0)  {
                    returnStr = [value stringValue];
                }
                else if (strcmp([value objCType], @encode(unsigned long)) == 0)  {
                    returnStr = [value stringValue];
                }
                else if (strcmp([value objCType], @encode(unsigned long long)) == 0)   {
                    returnStr = [value stringValue];
                }
                else if(strcmp([value objCType], @encode(float)) == 0)  {
                    returnStr = [NSString stringWithFormat:@"%.2f",[value floatValue]];
                }
                else if(strcmp([value objCType], @encode(double)) == 0) {
                    returnStr = [NSString stringWithFormat:@"%.2f",[value doubleValue]];
                }
                else if(strcmp([value objCType], @encode(float)) == 0) {
                    NSString *floatValueString = [value stringValue];
                    NSDecimalNumber *decimalNumber = [NSDecimalNumber decimalNumberWithString:floatValueString];
                    returnStr = [NSString stringWithFormat:@"%@",decimalNumber];
                }
                else if(strcmp([value objCType], @encode(double)) == 0) {
                    NSString *doubleValueString = [value stringValue];
                    NSDecimalNumber *decimalNumber = [NSDecimalNumber decimalNumberWithString:doubleValueString];
                    returnStr = [NSString stringWithFormat:@"%@",decimalNumber];
                }
            }
            else {
                returnStr = dictionary[key];
            }
            //          returnStr = [value isKindOfClass:[NSNumber class]] ? [value stringValue] : dictionary[key];
        }
        return  returnStr;
    }
    else {
        
        return @"";
    }
}








/**
 判断两个小数是否能被整除
 
 @param num1 第一个数
 @param num2 第二个书
 @return 返回是否能被整除的结果
 */
+ (BOOL)getDivisibleWithFirstNum:(double)num1 withSecondNum:(double)num2 {
    BOOL isDivisible = YES;
    if (num2 == 0) {
        return NO;
    }
    double result = num1 / num2;
    NSString * resultStr = [NSString stringWithFormat:@"%f", result];
    NSRange range = [resultStr rangeOfString:@"."];
    NSString * subStr = [resultStr substringFromIndex:range.location + 1];
    
    for (NSInteger index = 0; index < subStr.length; index ++) {
        unichar ch = [subStr characterAtIndex:index];
        // 后面的字符中只要有一个不为0，就可判定不能整除，跳出循环
        if ('0' != ch) {
            isDivisible = NO;
            break;
        }
    }
    return isDivisible;
}



/**
 压缩图片, wifi情况下压缩为500k, 非wifi情况下压缩到200k, 小于200k不压缩
 
 @param image 将要压缩的image
 @return 压缩后返回的NSData
 */
+ (NSData *)getZipImage:(UIImage *)image {
    if (!image) {
        return nil;
    }
    CGFloat scale;
    if ([IBXHelpers getNetWorkStatus] == NetWorkStatusWiFi) {
        scale = 8;
    }else {
        scale = 5;
    }
    
    CGFloat maxFileSize = scale * 100 *1024;
    CGFloat compression = 1.0f;
    NSData *compressedData = UIImageJPEGRepresentation(image, compression);
    while ([compressedData length] > maxFileSize) {
        compression *= 0.9;
        compressedData = UIImageJPEGRepresentation([[self class] compressImage:image newWidth:image.size.width*compression], compression);
    }
    return compressedData;
}

/**
 *  等比缩放本图片大小
 *
 *  @param newImageWidth 缩放后图片宽度，像素为单位
 *
 *  @return self-->(image)
 */
+ (UIImage *)compressImage:(UIImage *)image newWidth:(CGFloat)newImageWidth {
    if (!image) return nil;
    float imageWidth = image.size.width;
    float imageHeight = image.size.height;
    float width = newImageWidth;
    float height = image.size.height/(image.size.width/width);
    
    float widthScale = imageWidth /width;
    float heightScale = imageHeight /height;
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    
    if (widthScale > heightScale) {
        [image drawInRect:CGRectMake(0, 0, imageWidth /heightScale , height)];
    }
    else {
        [image drawInRect:CGRectMake(0, 0, width , imageHeight /widthScale)];
    }
    // 从当前context中创建一个改变大小后的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    return newImage;
    
}




/**
 根据颜色值渲染成图片
 
 @param color 传入的颜色值
 @return 渲染成的图片
 */
+ (UIImage * _Nonnull )getImageWithColor:(UIColor *_Nonnull)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}



/**
 将转码后的HTML5字符串通过固定格式替换
 
 @param htmlStr 待处理的字符串
 @return 处理后的字符串
 */
+ (NSString *)getDecodeHtmlString:(NSString *)htmlStr {
    if (htmlStr == nil) {
        return @"";
    }
    if (htmlStr.length == 0) {
        return @"";
    }
    
    htmlStr = [htmlStr stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    htmlStr = [htmlStr stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
    htmlStr = [htmlStr stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    htmlStr = [htmlStr stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    htmlStr = [htmlStr stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"]; // Do this last so that, e.g. @"&amp;lt;" goes to @"&lt;" not @"<"
    
    return htmlStr;
}





/**
 设置状态栏的背影色
 
 @param color 颜色
 */
+(void)setStatusBarBackgroundColor:(UIColor *)color {
    UIView * statusBarView = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"]valueForKey:@"statusBar"];
    if ([statusBarView respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBarView.backgroundColor = color;
    }
}



/**
 默认是除了证券已经登录的其他情况;
 
 @param controller 跳转源头
 @param success 登录成功
 */
+ (void)getStockJudgeJumpActionWithController:(UIViewController *)controller withLoginSuccess:(void(^)(BOOL success))successBL {
    if ([IBGlobalMethod isLogin]) {
        if ([IBGlobalMethod getTradeAccountId].length < 2) {
            IBTradeOpenAccountGuideController  *openC = [[UIStoryboard storyboardWithName:@"TradeMain" bundle:nil] instantiateViewControllerWithIdentifier:@"IBTradeOpenAccountGuideController"];
            openC.hidesBottomBarWhenPushed = YES;
            openC.m_Type = TradeOpenAccountGuideType_StockDeal;
            [controller.navigationController pushViewController:openC animated:YES];
        }else {
            IBTradeLoginViewController *loginV = [[IBTradeLoginViewController alloc] initWithNibName:@"IBTradeLoginViewController" bundle:nil];
            [loginV loginSuccessWithBlock:^(BOOL success, NSString *inftorType) {
                if (success) {
                    successBL(YES);
                }
            }];
            [controller presentViewController:loginV animated:YES completion:nil];
        }
    }else {
        [IBViewControllerHelp showLoginRegistControllerWithBTradeLogin:IBQTLoginTypeTLoginHandle];
    }
}




/**
 默认是除了外汇已经登录的其他情况;
 
 @param controller 跳转源头
 @param success 登录成功
 */
+ (void)getFXJudgeJumpActionWithController:(UIViewController *)controller withLoginSuccess:(void(^)(BOOL success))success {
    if ([IBGlobalMethod isFXTradeLogined]) {
        success(YES);
        return;
    }
    if (![IBGlobalMethod isLogin]) {
        [IBViewControllerHelp showLoginRegistControllerWithBTradeLogin:IBQTLoginTypeTLoginHandle];
    }else {
        if ([IBGlobalMethod isFXTradeBinded]) {
            IBFXLoginViewController *logC = [[IBFXLoginViewController alloc] initWithNibName:@"IBFXLoginViewController" bundle:nil withLoginCallBack:^(BOOL loginSuccess) {
                if (success) {
                    success(YES);
                }
            } withType:FXLoginType_Login_FX];
            [controller presentViewController:logC animated:YES completion:nil];
        }else {
            IBFXUnbindInforController *c = [[UIStoryboard storyboardWithName:Storyboard_FX_Bind bundle:nil] instantiateViewControllerWithIdentifier:@"IBFXUnbindInforController"];
            c.hidesBottomBarWhenPushed = YES;
            c.unBindType = BindSuccessInforType_FX;
            [controller.navigationController pushViewController:c animated:YES];
        }
    }
}





/**
 默认是除了贵金属已经登录的其他情况;
 
 @param controller 跳转源头
 @param success 登录成功
 */
+ (void)getPMJudgeJumpActionWithController:(UIViewController *)controller withLoginSuccess:(void(^)(BOOL success))success {
    if ([IBGlobalMethod isPMTradeLogined]) {
        success(YES);
        return;
    }
    if (![IBGlobalMethod isLogin]) {
        [IBViewControllerHelp showLoginRegistControllerWithBTradeLogin:IBQTLoginTypeTLoginHandle];
    }else {
        if ([IBGlobalMethod isPMTradeBinded]) {
            IBFXLoginViewController *logC = [[IBFXLoginViewController alloc] initWithNibName:@"IBFXLoginViewController" bundle:nil withLoginCallBack:^(BOOL loginSuccess) {
                if (success) {
                    success(YES);
                }
            } withType:FXLoginType_Login_PM];
            [controller presentViewController:logC animated:YES completion:nil];
        }else {
            IBFXUnbindInforController *c = [[UIStoryboard storyboardWithName:Storyboard_FX_Bind bundle:nil] instantiateViewControllerWithIdentifier:@"IBFXUnbindInforController"];
            c.hidesBottomBarWhenPushed = YES;
            c.unBindType = BindSuccessInforType_PM;
            [controller.navigationController pushViewController:c animated:YES];
        }
    }
}


/**
 外汇或者贵金属, 跳转到修改密码界面
 
 @param controller 当前controller
 @param type 0: 外汇, 1: 贵金属
 */
+ (void)getJumpToChangePSWWithController:(UIViewController *)controller withType:(NSInteger)type {
    if (type == 0) {
        [IBXHelpers getFXJudgeJumpActionWithController:controller withLoginSuccess:^(BOOL success) {
            IBFXChangePSWViewController *changeC = [[UIStoryboard storyboardWithName:Storyboard_FX_Change_PSW bundle:nil] instantiateViewControllerWithIdentifier:@"IBFXChangePSWViewController"];
            changeC.changePSWType = FXChangePSWType_FX;
            [controller.navigationController pushViewController:changeC animated:YES];
        }];
    }else {
        [IBXHelpers getPMJudgeJumpActionWithController:controller withLoginSuccess:^(BOOL success) {
            IBFXChangePSWViewController *changeC = [[UIStoryboard storyboardWithName:Storyboard_FX_Change_PSW bundle:nil] instantiateViewControllerWithIdentifier:@"IBFXChangePSWViewController"];
            changeC.changePSWType = FXChangePSWType_PM;
            [controller.navigationController pushViewController:changeC animated:YES];
        }];
    }
}


/**
 外汇/贵金属绑定成功后跳转的界面
 
 @param controller 动力源controller
 @param type 0:外汇, 1:贵金属
 */
+ (void)getFX_PMBindSuccessWithController:(UIViewController *)controller withType:(NSInteger)type {
    IBFXBindSuccessInforViewController *successC = [[UIStoryboard storyboardWithName:Storyboard_FX_Bind bundle:nil] instantiateViewControllerWithIdentifier:@"IBFXBindSuccessInforViewController"];
    if (type == 0) {
        successC.m_InforType = BindSuccessInforType_FX;
    }else {
        successC.m_InforType = BindSuccessInforType_PM;
    }
    [controller.navigationController pushViewController:successC animated:YES];
}





/**
 外汇/贵金属的 校验价格
 
 @param callBack 提示信息回调
 @param dealModel 入参
 @param type 0: 外汇, 1:贵金属
 @return 是否符合校验
 */
+ (BOOL)getJudge_Price_WithCallBack:(void(^)(NSString *infor, NSString *judgePrice, NSString *judgePricePlus))callBack withDealModel:(IBFXDealModel *)dealModel wityType:(NSInteger)type {
    IBFXQuoteConfigJsonModel *configModel;
    IBFXQuoteModel *quoteModel;
    if (type == 0) {
        configModel = [FXQuoteManager().fxQuoteConficDic objectForKey: dealModel.contract ];
        quoteModel = [FXQuoteManager().fxQuoteDic objectForKey:dealModel.contract];
    }else {
        configModel = [FXQuoteManager().pmQuoteConficDic objectForKey: dealModel.contract ];
        quoteModel = [FXQuoteManager().pmQuoteDic objectForKey:dealModel.contract];
    }
    switch (dealModel.orderType) {
        case 0: {///市价单
            return YES;
            break;
        }
        case 1: {///限价单
            if (dealModel.buySellType == 1) {
                double level = [quoteModel.Ask doubleValue] - configModel.pipValue * dealModel.minPendingOrderPipsOffset_Caculator;
                NSString *caculatorPrice = [NSString stringWithFormat:[IBFXQuoteOpr radixPointFormSymbol:dealModel.contract], level];
                if ([dealModel.price doubleValue] > level) {
                    
                    callBack([NSString stringWithFormat:@"%@%@",CustomLocalizedString(@"FX_BU_JIAOYIJIAGEYINGXIAOYUDENGYU", nil), caculatorPrice], caculatorPrice, [NSString stringWithFormat:@"%@≧", caculatorPrice]);
                    return NO;
                }else {
                    callBack(@"", caculatorPrice, [NSString stringWithFormat:@"%@≧", caculatorPrice]);
                    return YES;
                }
            }else {
                double level = [quoteModel.Bid doubleValue] + configModel.pipValue * dealModel.minPendingOrderPipsOffset_Caculator;
                NSString *caculatorPrice = [NSString stringWithFormat:[IBFXQuoteOpr radixPointFormSymbol:dealModel.contract], level];
                if ([dealModel.price doubleValue] < level) {
                    callBack([NSString stringWithFormat:@"%@%@",CustomLocalizedString(@"FX_BU_JIAOYIJIAGEYINGDAYUDENGYU", nil), caculatorPrice], caculatorPrice, [NSString stringWithFormat:@"%@≦", caculatorPrice]);
                    return NO;
                }else {
                    callBack(@"", caculatorPrice, [NSString stringWithFormat:@"%@≦", caculatorPrice]);
                    return YES;
                }
            }
            break;
        }
        case 2: {///止损单
            if (dealModel.buySellType == 1) {
                double level = [quoteModel.Ask doubleValue] + configModel.pipValue * dealModel.minPendingOrderPipsOffset_Caculator;
                NSString *caculatorPrice = [NSString stringWithFormat:[IBFXQuoteOpr radixPointFormSymbol:dealModel.contract], level];
                if ([dealModel.price doubleValue] < level) {
                    callBack([NSString stringWithFormat:@"%@%@",CustomLocalizedString(@"FX_BU_JIAOYIJIAGEYINGDAYUDENGYU", nil), caculatorPrice], caculatorPrice, [NSString stringWithFormat:@"%@≦", caculatorPrice]);
                    return NO;
                }else {
                    callBack(@"", caculatorPrice, [NSString stringWithFormat:@"%@≦", caculatorPrice]);
                    return YES;
                }
            }else {
                double level = [quoteModel.Bid doubleValue] - configModel.pipValue * dealModel.minPendingOrderPipsOffset_Caculator;
                NSString *caculatorPrice = [NSString stringWithFormat:[IBFXQuoteOpr radixPointFormSymbol:dealModel.contract], level];
                if ([dealModel.price doubleValue] > level) {
                    callBack([NSString stringWithFormat:@"%@%@",CustomLocalizedString(@"FX_BU_JIAOYIJIAGEYINGXIAOYUDENGYU", nil), caculatorPrice], caculatorPrice, [NSString stringWithFormat:@"%@≧", caculatorPrice]);
                    return NO;
                }else {
                    callBack(@"", caculatorPrice, [NSString stringWithFormat:@"%@≧", caculatorPrice]);
                    return YES;
                }
            }
            break;
        }
        default: {
            return NO;
            break;
        }
    }
}



/**
 外汇/贵金属的 止盈价校验
 
 @param callBack 提示信息回调
 @param dealModel 入参
 @param type 0: 外汇, 1:贵金属
 @return 是否符合校验
 */
+ (BOOL)getJudge_StopProfit_WithCallBack:(void(^)(NSString *infor, NSString *judgeZhiYing, NSString *judgeZhiYingPlus))callBack withDealModel:(IBFXDealModel *)dealModel wityType:(NSInteger)type {
    IBFXQuoteConfigJsonModel *configModel;
    IBFXQuoteModel *quoteModel;
    if (type == 0) {
        configModel = [FXQuoteManager().fxQuoteConficDic objectForKey: dealModel.contract ];
        quoteModel = [FXQuoteManager().fxQuoteDic objectForKey:dealModel.contract];
    }else {
        configModel = [FXQuoteManager().pmQuoteConficDic objectForKey: dealModel.contract ];
        quoteModel = [FXQuoteManager().pmQuoteDic objectForKey:dealModel.contract];
    }
    
    switch (dealModel.orderType) {
        case 0: {///市价单
            
            if (dealModel.buySellType == 1) {
                double level = [quoteModel.Bid doubleValue] + configModel.pipValue * dealModel.minPendingOrderPipsOffset_Caculator;
                if (level <= 0) {
                    level = 0.00;
                }
                NSString *caculatorPrice = [NSString stringWithFormat:[IBFXQuoteOpr radixPointFormSymbol:dealModel.contract], level];
                if (dealModel.stopProfit == nil || dealModel.stopProfit.length < 1  ) {
                    callBack(@"", caculatorPrice,  [NSString stringWithFormat:@"%@≦", caculatorPrice]);
                    return YES;
                }
                if ([dealModel.stopProfit doubleValue] < level) {
                    callBack([NSString stringWithFormat:@"%@%@",CustomLocalizedString(@"FX_BU_ZHIYINGJIAGEYINGDAYUDENGYU", nil), caculatorPrice], caculatorPrice,  [NSString stringWithFormat:@"%@≦", caculatorPrice]);
                    return NO;
                }else {
                    callBack(@"", caculatorPrice,  [NSString stringWithFormat:@"%@≦", caculatorPrice]);
                    return YES;
                }
            }else {
                double level = [quoteModel.Ask doubleValue] - configModel.pipValue * dealModel.minPendingOrderPipsOffset_Caculator;
                if (level <= 0) {
                    level = 0.00;
                }
                NSString *caculatorPrice = [NSString stringWithFormat:[IBFXQuoteOpr radixPointFormSymbol:dealModel.contract], level];
                if (dealModel.stopProfit == nil || dealModel.stopProfit.length < 1  ) {
                    callBack(@"", caculatorPrice, [NSString stringWithFormat:@"%@≧", caculatorPrice]);
                    return YES;
                }
                if ([dealModel.stopProfit doubleValue] > level) {
                    callBack([NSString stringWithFormat:@"%@%@",CustomLocalizedString(@"FX_BU_ZHIYINGJIAGEYINGXIAOYUDENGYU", nil), caculatorPrice], caculatorPrice, [NSString stringWithFormat:@"%@≧", caculatorPrice]);
                    return NO;
                }else {
                    callBack(@"", caculatorPrice, [NSString stringWithFormat:@"%@≧", caculatorPrice]);
                    return YES;
                }
            }
            break;
        }
        case 1: {///限价单
            
            /**
             Spread计算公式
             Spread = Ask - Bid
             */
            double spread = [quoteModel.Ask doubleValue] - [quoteModel.Bid doubleValue];
            double offset = configModel.pipValue * dealModel.minPendingOrderPipsOffset_Caculator;
            
            if (dealModel.buySellType == 1) {
                double level = [dealModel.price doubleValue] - spread + offset;
                if (level <= 0) {
                    level = 0.00;
                }
                NSString *caculatorPrice = [NSString stringWithFormat:[IBFXQuoteOpr radixPointFormSymbol:dealModel.contract], level];
                if (dealModel.stopProfit == nil || dealModel.stopProfit.length < 1  ) {
                    callBack(@"", caculatorPrice, [NSString stringWithFormat:@"%@≦", caculatorPrice]);
                    return YES;
                }
                if ([dealModel.stopProfit doubleValue] < level) {
                    callBack([NSString stringWithFormat:@"%@%@",CustomLocalizedString(@"FX_BU_ZHIYINGJIAGEYINGDAYUDENGYU", nil), caculatorPrice], caculatorPrice, [NSString stringWithFormat:@"%@≦", caculatorPrice]);
                    return NO;
                }else {
                    callBack(@"", caculatorPrice, [NSString stringWithFormat:@"%@≦", caculatorPrice]);
                    return YES;
                }
            }else {
                double level = [dealModel.price doubleValue] + spread - offset;
                if (level <= 0) {
                    level = 0.00;
                }
                NSString *caculatorPrice = [NSString stringWithFormat:[IBFXQuoteOpr radixPointFormSymbol:dealModel.contract], level];
                if (dealModel.stopProfit == nil || dealModel.stopProfit.length < 1  ) {
                    callBack(@"", caculatorPrice, [NSString stringWithFormat:@"%@≧", caculatorPrice]);
                    return YES;
                }
                if ([dealModel.stopProfit doubleValue] > level) {
                    callBack([NSString stringWithFormat:@"%@%@",CustomLocalizedString(@"FX_BU_ZHIYINGJIAGEYINGXIAOYUDENGYU", nil), caculatorPrice], caculatorPrice, [NSString stringWithFormat:@"%@≧", caculatorPrice]);
                    return NO;
                }else {
                    callBack(@"", caculatorPrice, [NSString stringWithFormat:@"%@≧", caculatorPrice]);
                    return YES;
                }
            }
            break;
        }
        case 2: {///止损单
            
            /**
             Spread计算公式
             Spread = Ask - Bid
             */
            double spread = [quoteModel.Ask doubleValue] - [quoteModel.Bid doubleValue];
            double offset = configModel.pipValue * dealModel.minPendingOrderPipsOffset_Caculator;
            if (dealModel.buySellType == 1) {
                double level = [dealModel.price doubleValue] - spread + offset;
                if (level <= 0) {
                    level = 0.00;
                }
                NSString *caculatorPrice = [NSString stringWithFormat:[IBFXQuoteOpr radixPointFormSymbol:dealModel.contract], level];
                if (dealModel.stopProfit == nil || dealModel.stopProfit.length < 1) {
                    callBack(@"", caculatorPrice, [NSString stringWithFormat:@"%@≦", caculatorPrice]);
                    return YES;
                }
                if ([dealModel.stopProfit doubleValue] < level) {
                    callBack([NSString stringWithFormat:@"%@%@",CustomLocalizedString(@"FX_BU_ZHIYINGJIAGEYINGDAYUDENGYU", nil), caculatorPrice], caculatorPrice, [NSString stringWithFormat:@"%@≦", caculatorPrice]);
                    return NO;
                }else {
                    callBack(@"", caculatorPrice, [NSString stringWithFormat:@"%@≦", caculatorPrice]);
                    return YES;
                }
            }else {
                double level = [dealModel.price doubleValue] + spread - offset;
                if (level <= 0) {
                    level = 0.00;
                }
                NSString *caculatorPrice = [NSString stringWithFormat:[IBFXQuoteOpr radixPointFormSymbol:dealModel.contract], level];
                if (dealModel.stopProfit == nil || dealModel.stopProfit.length < 1) {
                    callBack(@"", caculatorPrice, [NSString stringWithFormat:@"%@≧", caculatorPrice]);
                    return YES;
                }
                if ([dealModel.stopProfit doubleValue] > level) {
                    callBack([NSString stringWithFormat:@"%@%@",CustomLocalizedString(@"FX_BU_ZHIYINGJIAGEYINGXIAOYUDENGYU", nil), caculatorPrice], caculatorPrice, [NSString stringWithFormat:@"%@≧", caculatorPrice]);
                    return NO;
                }else {
                    callBack(@"", caculatorPrice, [NSString stringWithFormat:@"%@≧", caculatorPrice]);
                    return YES;
                }
            }
            break;
        }
        default: {
            return NO;
            break;
        }
    }
}




/**
 外汇/贵金属的 止损价校验
 
 @param callBack 提示信息回调
 @param dealModel 入参
 @param type 0: 外汇, 1:贵金属
 @return 是否符合校验
 */
+ (BOOL)getJudge_StopLoss_WithCallBack:(void(^)(NSString *infor, NSString *judgeZhiSun, NSString *judgeZhiSunPlus))callBack withDealModel:(IBFXDealModel *)dealModel wityType:(NSInteger)type {
    IBFXQuoteConfigJsonModel *configModel;
    IBFXQuoteModel *quoteModel;
    if (type == 0) {
        configModel = [FXQuoteManager().fxQuoteConficDic objectForKey: dealModel.contract ];
        quoteModel = [FXQuoteManager().fxQuoteDic objectForKey:dealModel.contract];
    }else {
        configModel = [FXQuoteManager().pmQuoteConficDic objectForKey: dealModel.contract ];
        quoteModel = [FXQuoteManager().pmQuoteDic objectForKey:dealModel.contract];
    }
    
    switch (dealModel.orderType) {
        case 0: {///市价单
            if (dealModel.buySellType == 1) {
                double level = [quoteModel.Bid doubleValue] - configModel.pipValue * dealModel.minPendingOrderPipsOffset_Caculator;
                if (level <= 0) {
                    level = 0.00;
                }
                NSString *caculatorPrice = [NSString stringWithFormat:[IBFXQuoteOpr radixPointFormSymbol:dealModel.contract], level];
                if (dealModel.stopLoss == nil || dealModel.stopLoss.length < 1) {
                    callBack(@"", caculatorPrice, [NSString stringWithFormat:@"%@≧", caculatorPrice]);
                    return YES;
                }
                if ([dealModel.stopLoss doubleValue] > level) {
                    callBack([NSString stringWithFormat:@"%@%@",CustomLocalizedString(@"FX_BU_ZHISUIJIAGEYINGXIAOYUDENGYU", nil), caculatorPrice], caculatorPrice, [NSString stringWithFormat:@"%@≧", caculatorPrice]);
                    return NO;
                }else {
                    callBack(@"", caculatorPrice, [NSString stringWithFormat:@"%@≧", caculatorPrice]);
                    return YES;
                }
            }else {
                double level = [quoteModel.Ask doubleValue] + configModel.pipValue * dealModel.minPendingOrderPipsOffset_Caculator;
                if (level <= 0) {
                    level = 0.00;
                }
                NSString *caculatorPrice = [NSString stringWithFormat:[IBFXQuoteOpr radixPointFormSymbol:dealModel.contract], level];
                if (dealModel.stopLoss == nil || dealModel.stopLoss.length < 1) {
                    callBack(@"", caculatorPrice, [NSString stringWithFormat:@"%@≦", caculatorPrice]);
                    return YES;
                }
                if ([dealModel.stopLoss doubleValue] < level) {
                    callBack([NSString stringWithFormat:@"%@%@",CustomLocalizedString(@"FX_BU_ZHISUNJIAGEYINGDAYUEDENGYU", nil), caculatorPrice], caculatorPrice, [NSString stringWithFormat:@"%@≦", caculatorPrice]);
                    return NO;
                }else {
                    callBack(@"", caculatorPrice, [NSString stringWithFormat:@"%@≦", caculatorPrice]);
                    return YES;
                }
            }
            break;
        }
        case 1: {///限价单
            
            
            /**
             Spread计算公式
             Spread = Ask - Bid
             */
            double spread = [quoteModel.Ask doubleValue] - [quoteModel.Bid doubleValue];
            double offset = configModel.pipValue * dealModel.minPendingOrderPipsOffset_Caculator;
            if (dealModel.buySellType == 1) {
                double level = [dealModel.price doubleValue] - spread - offset;
                if (level <= 0) {
                    level = 0.00;
                }
                NSString *caculatorPrice = [NSString stringWithFormat:[IBFXQuoteOpr radixPointFormSymbol:dealModel.contract], level];
                if (dealModel.stopLoss == nil || dealModel.stopLoss.length < 1) {
                    callBack(@"", caculatorPrice, [NSString stringWithFormat:@"%@≧", caculatorPrice]);
                    return YES;
                }
                if ([dealModel.stopLoss doubleValue] > level) {
                    callBack([NSString stringWithFormat:@"%@%@",CustomLocalizedString(@"FX_BU_ZHISUIJIAGEYINGXIAOYUDENGYU", nil), caculatorPrice], caculatorPrice, [NSString stringWithFormat:@"%@≧", caculatorPrice]);
                    return NO;
                }else {
                    callBack(@"",caculatorPrice, [NSString stringWithFormat:@"%@≧", caculatorPrice]);
                    return YES;
                }
            }else {
                double level = [dealModel.price doubleValue] + spread + offset;
                if (level <= 0) {
                    level = 0.00;
                }
                NSString *caculatorPrice = [NSString stringWithFormat:[IBFXQuoteOpr radixPointFormSymbol:dealModel.contract], level];
                if (dealModel.stopLoss == nil || dealModel.stopLoss.length < 1) {
                    callBack(@"", caculatorPrice, [NSString stringWithFormat:@"%@≦", caculatorPrice]);
                    return YES;
                }
                if ([dealModel.stopLoss doubleValue] < level) {
                    callBack([NSString stringWithFormat:@"%@%@",CustomLocalizedString(@"FX_BU_ZHISUNJIAGEYINGDAYUEDENGYU", nil), caculatorPrice], caculatorPrice, [NSString stringWithFormat:@"%@≦", caculatorPrice]);
                    return NO;
                }else {
                    callBack(@"", caculatorPrice, [NSString stringWithFormat:@"%@≦", caculatorPrice]);
                    return YES;
                }
            }
            break;
        }
        case 2: {///止损单
            /**
             Spread计算公式
             Spread = Ask - Bid
             */
            double spread = [quoteModel.Ask doubleValue] - [quoteModel.Bid doubleValue];
            double offset = configModel.pipValue * dealModel.minPendingOrderPipsOffset_Caculator;
            if (dealModel.buySellType == 1) {
                double level = [dealModel.price doubleValue] - spread - offset;
                if (level <= 0) {
                    level = 0.00;
                }
                NSString *caculatorPrice = [NSString stringWithFormat:[IBFXQuoteOpr radixPointFormSymbol:dealModel.contract], level];
                if (dealModel.stopLoss == nil || dealModel.stopLoss.length < 1) {
                    callBack(@"", caculatorPrice, [NSString stringWithFormat:@"%@≧", caculatorPrice]);
                    return YES;
                }
                if ([dealModel.stopLoss doubleValue] > level) {
                    callBack([NSString stringWithFormat:@"%@%@",CustomLocalizedString(@"FX_BU_ZHISUIJIAGEYINGXIAOYUDENGYU", nil), caculatorPrice], caculatorPrice, [NSString stringWithFormat:@"%@≧", caculatorPrice]);
                    return NO;
                }else {
                    callBack(@"", caculatorPrice, [NSString stringWithFormat:@"%@≧", caculatorPrice]);
                    return YES;
                }
            }else {
                double level = [dealModel.price doubleValue] + spread + offset;
                if (level <= 0) {
                    level = 0.00;
                }
                NSString *caculatorPrice = [NSString stringWithFormat:[IBFXQuoteOpr radixPointFormSymbol:dealModel.contract], level];
                if (dealModel.stopLoss == nil || dealModel.stopLoss.length < 1) {
                    callBack(@"", caculatorPrice, [NSString stringWithFormat:@"%@≦", caculatorPrice]);
                    return YES;
                }
                if ([dealModel.stopLoss doubleValue] < level) {
                    callBack([NSString stringWithFormat:@"%@%@",CustomLocalizedString(@"FX_BU_ZHISUNJIAGEYINGDAYUEDENGYU", nil), caculatorPrice], caculatorPrice, [NSString stringWithFormat:@"%@≦", caculatorPrice]);
                    return NO;
                }else {
                    callBack(@"", caculatorPrice, [NSString stringWithFormat:@"%@≦", caculatorPrice]);
                    return YES;
                }
            }
            break;
        }
        default: {
            return NO;
            break;
        }
    }
}




/**
 弹出扫描二维码的面
 
 @param callBack 回到扫到结果
 @param controller 动力源
 @param type 0:present出来(controller不能为空, 为空默认push),1: push出来
 */
+ (void)getSweepQRCodeWithCallBack:(void(^)(NSString *infor))callBack withController:(UIViewController *)controller withType:(NSInteger )type {
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied) { //无权限 做一个友好的提示
        UIAlertView * alart = [[UIAlertView alloc]initWithTitle:CustomLocalizedString(@"MINEWENXINTISHI", nil) message:CustomLocalizedString(@"FX_BU_QINGQUSHEZHIDAKAIFANGWENKAIGUAN", nil) delegate:nil cancelButtonTitle:CustomLocalizedString(@"COMMAND_OK", nil) otherButtonTitles:nil, nil];
        [alart show];
    }else { //调用相机
        ///调用扫一扫界面
        SweepQRCodeViewController *sweepC = [[SweepQRCodeViewController alloc] init];
        QNBaseNavController *navC = [[QNBaseNavController alloc] initWithRootViewController:sweepC];
        [sweepC getBlockFromOutSide:^(NSString *qrCodeString) {
            if (callBack) {
                callBack(qrCodeString);
            }
        }];
        if (controller && type == 0) {
            [controller presentViewController:navC animated:YES completion:nil];
        }else {
            [controller.navigationController pushViewController:sweepC animated:YES];
        }
    }
}


/**
 *  字典 转换JSON 方法
 *
 *  @param object 字典
 *
 *  @return 返回JSON字符串
 */
+ (NSString *)getDataToJSONString:(id)object {
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:0 // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (!jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}






/**
 点击获取相机权限, 如果可以获取到权限则在block中回调
 
 @param callBack 回调
 */
+ (void)getCameraLimitWithCallBack:(void(^_Nullable)(void))callBack {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusRestricted || status == AVAuthorizationStatusDenied) {
        [IBCustomOrderView showCustomOrderViewWithBlock:^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        } withType:ConfirmOrderType_CameraLimit];
    }else {
        callBack();
    }
}


/**
 点击获取相册权限, 如果可以获取到权限则在block中回调
 
 @param callBack 回调
 */
+ (void)getAlbumLimitWithCallBack:(void(^_Nullable)(void))callBack {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied) {
        [IBCustomOrderView showCustomOrderViewWithBlock:^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        } withType:ConfirmOrderType_CameraLimit];
    }else {
        callBack();
    }
}


/**
 外汇/贵金属  根据传入的小数位数, 返回相应的占位文字
 
 @param decimalCount 小数位数
 @return 返回占位文字
 */
+ (NSString *_Nullable)getPlaceholderWithDecimalCount:(NSInteger)decimalCount {
    switch (decimalCount) {
        case 0: {
            return @"0";
            break;
        }
        case 1: {
            return @"0.0";
            break;
        }
        case 2: {
            return @"0.00";
            break;
        }
        case 3: {
            return @"0.000";
            break;
        }
        case 4: {
            return @"0.0000";
            break;
        }
        case 5: {
            return @"0.00000";
            break;
        }
        case 6: {
            return @"0.000000";
            break;
        }
        default:
            return 0;
            break;
    }
}





/**
 贵金属.外汇 下改撤  为价格相关校验添加边框
 
 @param color 颜色
 @param lable 添加对象
 */
+ (void)getAddBorderWithColor:(UIColor *)color withLable:(UILabel *)lable {
    dispatch_async(dispatch_get_main_queue(), ^{
        lable.textColor = color;
        lable.layer.borderWidth = 1;
        lable.layer.borderColor = color.CGColor;
//        [IBXHelpers getAddBorderToLayer:lable withColor:color];
    });
}



/**
 为一个View添加虚线边框

 @param view 要添加的view
 @param color 颜色
 */

+ (void)getAddBorderToLayer:(UIView *)view withColor:(UIColor *)color{
    CAShapeLayer *border = [CAShapeLayer layer];
    border.strokeColor = color.CGColor;
    border.fillColor = nil;
    border.path = [UIBezierPath bezierPathWithRect:view.bounds].CGPath;
    border.frame = view.bounds;
    border.lineWidth = 1;
    border.lineCap = @"square";
    border.lineDashPattern = @[@2, @2];
    [view.layer addSublayer:border];
}
    

/**
 获取当前手机设置的语言信息
 
 @return 返回语言信息
 */
+ (LanguageType)getLanguageType {
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSArray * allLanguages = [defaults objectForKey:@"AppleLanguages"];
    NSString * nowLanguage = [allLanguages objectAtIndex:0];
    if (SystemVersion.integerValue < 9) {
        if ([nowLanguage hasPrefix:@"zh-Hans"]) {
            return LanguageType_SimpleChinese;
        }
        if ([nowLanguage hasPrefix:@"zh-Hant"] || [nowLanguage hasPrefix:@"zh-HK"]) {
            return LanguageType_TraditionChinese;
        }else {
            return LanguageType_English;
        }
    }else {
        if ([nowLanguage hasPrefix:@"zh-Hans-CN"]) {
            return LanguageType_SimpleChinese;
        }
        if ([nowLanguage hasPrefix:@"zh-Hant-CN"] || [nowLanguage hasPrefix:@"zh-HK"] || [nowLanguage hasPrefix:@"zh-TW"]) {
            return LanguageType_TraditionChinese;
        }else {
            return LanguageType_English;
        }
    }
}

/**
 获取证券http请求时入参语言类型
 
 @return 类型
 */
+ (NSString *)getStockLanguageType {
    if ([IBTheme()  getIBLanguageShowType] == IBLanguageShowTypeSimpleChinese) {
        return @"BG25";
    }else if ([IBTheme()  getIBLanguageShowType] == IBLanguageShowTypeTraditionChinese) {
        return @"BT25";
    }else {
        return @"BE25";
    }
}










@end
