//
//  IBDeviceInfo.h
//  IBEngine
//
//  Created by manny on 14-12-16.
//  Copyright (c) 2014年 Bacai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTDeviceInfo : NSObject

+ (NSString *)appVersion;
+ (NSString *)appBuild;
+ (NSString *)deviceIdentifier;
+ (NSString *)deviceName;
+ (NSString *)deviceModel;
+ (NSString *)osName;
+ (NSString *)osVersion;
+ (NSNumber *)osType;
+ (NSNumber *)deviceType;

+ (NSDictionary *)deviceDictionary;

@end
