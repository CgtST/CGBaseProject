//
//  IBModeDecoder.m
//  iBestStandard
//
//  Created by bingo on 2018/5/15.
//  Copyright © 2018年 iBest. All rights reserved.
//

#import "IBModeDecoder.h"

@implementation IBModeDecoder

+ (NSString*)decodeKeyString:(NSString*)key FromDictonary:(NSDictionary*)dic{
    if (![self ifCanDecodeWithKey:key Dictionay:dic]) {
        return nil;
    }
    
    NSString *str = dic[key];
    if ([str isKindOfClass:[NSString class]] && [str length]) {
        return dic[key];
    }
    return @"";
}


NSString* decodeString(NSString *key, NSDictionary *dic) {
    if (!([dic isKindOfClass:[NSDictionary class] ]&& [key isKindOfClass:[NSString class]])) {
        return nil;
    }
    
    NSString *str = dic[key];
    if ([str isKindOfClass:[NSString class]] && [str length]) {
        return dic[key];
    }
    return @"";
}

NSString* decodePriceString(NSString *key, NSDictionary *dic) {
    if (!([dic isKindOfClass:[NSDictionary class] ]&& [key isKindOfClass:[NSString class]])) {
        return nil;
    }
    
    NSString *str = dic[key];
    if ([str isKindOfClass:[NSString class]] && [str length]) {
        return dic[key];
    }
    return @"--";
}


+ (void)decodeDoubleToObj:(double*)obj KeyString:(NSString*)key FromDictonary:(NSDictionary*)dic{
    if (![self ifCanDecodeWithKey:key Dictionay:dic]) {
        return;
    }
    if (dic[key]) {
        *obj = [dic[key] doubleValue];
    }
}

+ (void)decodeDefaultDoubleToObj:(double*)obj KeyString:(NSString*)key FromDictonary:(NSDictionary*)dic{
    if (![self ifCanDecodeWithKey:key Dictionay:dic]) {
        return;
    }
    if (dic[key]) {
        *obj = [dic[key] doubleValue];
    }else{
        *obj = DEFAULT_DOUBLEVALUE;
    }
}

+ (void)decodeInt64ValueToObj:(int64_t*)obj KeyString:(NSString*)key FromDictonary:(NSDictionary*)dic{
    if (![self ifCanDecodeWithKey:key Dictionay:dic]) {
        return;
    }
    if (dic[key]) {
        *obj = [[dic[key] stringValue] longLongValue];
    }
}

+ (void)decodeInt32ValueToObj:(int32_t*)obj KeyString:(NSString*)key FromDictonary:(NSDictionary*)dic{
    if (![self ifCanDecodeWithKey:key Dictionay:dic]) {
        return;
    }
    if (dic[key]) {
        *obj = (int32_t)[dic[key] integerValue];
    }
}

+ (void)decodeInt16ValueToObj:(int16_t*)obj KeyString:(NSString*)key FromDictonary:(NSDictionary*)dic{
    if (![self ifCanDecodeWithKey:key Dictionay:dic]) {
        return;
    }
    if (dic[key]) {
        *obj = (int16_t)[dic[key] integerValue];
    }
}

+ (void)decodeInt8ValueToObj:(int8_t*)obj KeyString:(NSString*)key FromDictonary:(NSDictionary*)dic{
    if (![self ifCanDecodeWithKey:key Dictionay:dic]) {
        return;
    }
    if (dic[key]) {
        *obj = (int8_t)[dic[key] integerValue];
    }
}

+ (void)decodeIntegerValueToObj:(NSInteger*)obj KeyString:(NSString*)key FromDictonary:(NSDictionary*)dic{
    if (![self ifCanDecodeWithKey:key Dictionay:dic]) {
        return;
    }
    if (dic[key]) {
        *obj = [dic[key] integerValue];
    }
}


+ (BOOL)ifCanDecodeWithKey:(NSString*)key Dictionay:(NSDictionary*)dic{
    if ([dic isKindOfClass:[NSDictionary class] ]&& [key isKindOfClass:[NSString class]]) {
        return YES;
    }else {
        return NO;
    }
}

@end
