//
//  IBModeDecoder.h
//  iBestStandard
//
//  Created by bingo on 2018/5/15.
//  Copyright © 2018年 iBest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IBModeDecoder : NSObject

+ (NSString*)decodeKeyString:(NSString*)key FromDictonary:(NSDictionary*)dic;

NSString* decodePriceString(NSString *key, NSDictionary *dic);

+ (void)decodeDoubleToObj:(double*)obj KeyString:(NSString*)key FromDictonary:(NSDictionary*)dic;

+ (void)decodeDefaultDoubleToObj:(double*)obj KeyString:(NSString*)key FromDictonary:(NSDictionary*)dic;

+ (void)decodeInt64ValueToObj:(int64_t*)obj KeyString:(NSString*)key FromDictonary:(NSDictionary*)dic;

+ (void)decodeInt32ValueToObj:(int32_t*)obj KeyString:(NSString*)key FromDictonary:(NSDictionary*)dic;

+ (void)decodeInt16ValueToObj:(int16_t*)obj KeyString:(NSString*)key FromDictonary:(NSDictionary*)dic;

+ (void)decodeInt8ValueToObj:(int8_t*)obj KeyString:(NSString*)key FromDictonary:(NSDictionary*)dic;

+ (void)decodeIntegerValueToObj:(NSInteger*)obj KeyString:(NSString*)key FromDictonary:(NSDictionary*)dic;


@end
