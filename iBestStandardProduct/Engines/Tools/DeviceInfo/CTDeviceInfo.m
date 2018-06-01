//
//  IBDeviceInfo.m
//  IBEngine
//
//  Created by manny on 14-12-16.
//  Copyright (c) 2014年 Bacai. All rights reserved.
//

#import "CTDeviceInfo.h"
#import <UIKit/UIKit.h>
#import <SFHFKeychainUtils.h>


#define kKeychainServiceName "uuid.com.ibest.www"
#define kKeyServerNameUDID  @"kKeyServerNameUDID"
#define kKeyUserName        @"kKeyUserNameSTOPENUDID"
#define kUDIDKey            @"com.ibest.udidkey"



NSString *uuid()
{
    CFUUIDRef puuid = CFUUIDCreate(nil);
    CFStringRef uuidString = CFUUIDCreateString(nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy(NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    
    return result;
}

@implementation CTDeviceInfo

+ (NSDictionary *)deviceDictionary
{
    static NSMutableDictionary *s_dic;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_dic = [NSMutableDictionary dictionary];
        
        [s_dic setObject: [self deviceIdentifier] forKey: @"deviceCode"];
        [s_dic setObject: [self deviceName] forKey: @"deviceName"];
        [s_dic setObject: [self deviceModel] forKey: @"deviceModel"];
        [s_dic setObject: [self osName] forKey: @"osName"];
        [s_dic setObject: [self osVersion] forKey: @"osVersion"];
        [s_dic setObject: [self osType] forKey: @"osType"];
        [s_dic setObject: [self appVersion] forKey: @"appVersion"];
        [s_dic setObject: [self deviceType] forKey: @"deviceType"];
    });
    return s_dic;
}


#pragma mark - GETTER
+ (NSString *)appVersion
{
    /*
#if DEBUG
    NSArray *test = @[@"0.0.002", @"0.0.003", @"0.0.004", @"0.0.005"];
    static NSInteger i = 0;
    NSString *version = test[i];
    i++;
    i = i%4;
    return version;
#endif
     */
    NSString * version = [[NSBundle mainBundle].infoDictionary objectForKey: @"CFBundleShortVersionString"];
    return version;
}

+ (NSString *)appBuild {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

+ (NSString *)deviceIdentifier
{
    return [[self class] udidFromKeychain];
}
+ (NSString *)deviceName
{
    return [UIDevice currentDevice].name;
}
+ (NSString *)deviceModel
{
    return [UIDevice currentDevice].model;
}
+ (NSNumber *)deviceType
{
    /* 0 PC
     * 1 phone
     * 2 pad
     */
    return @(1);
}
+ (NSString *)osName
{
    return [UIDevice currentDevice].systemName;
}
+ (NSString *)osVersion
{
    return [UIDevice currentDevice].systemVersion;
}
+ (NSNumber *)osType
{
    return @(1);
}

+ (NSString *)udidFromKeychain
{
    
    NSString *udid =[[NSUserDefaults standardUserDefaults] objectForKey:kUDIDKey];
    //如果应用内没有，从keychain拿
    if (![udid length]) {
        udid = [SFHFKeychainUtils getPasswordForUsernameOld: kKeyUserName
                                          andServiceName: kKeyServerNameUDID
                                                   error: nil];
        if ([udid length]) {
            [[NSUserDefaults standardUserDefaults] setObject:udid forKey:kUDIDKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            return udid;
        }
    }else {//如果应用内有，keychain里面没有，同步一下数据到kaychain


        NSString *keychainUDID = [SFHFKeychainUtils getPasswordForUsernameOld: kKeyUserName
                                                            andServiceName: kKeyServerNameUDID
                                                                     error: nil];
        if (![keychainUDID length]) {
            [SFHFKeychainUtils storeUsername: kKeyUserName andPassword: udid
                              forServiceName: kKeyServerNameUDID
                              updateExisting: YES
                                       error: nil];
        }
    }


    //如果应用内，keychain都没有udid，则生成新的udid，并保存到应用内和keychain
    if (![udid length]) {
        [self storeUDIDToKeychain];
        udid = [[NSUserDefaults standardUserDefaults] objectForKey:kUDIDKey];
    }
    
    if (udid.length == 0) {
        udid = @"AnErrorPlaceholderUDID";
    }
    NSLog(@"udid is %@", udid);
    return udid;
}


+ (BOOL)storeUDIDToKeychain
{
    NSString *udid = nil;
    
    udid =[[NSUserDefaults standardUserDefaults] objectForKey:kUDIDKey];
    
    if ([udid length]) {
        return YES;
    }else {
        udid = [SFHFKeychainUtils getPasswordForUsernameOld: kKeyUserName
                                          andServiceName: kKeyServerNameUDID
                                                   error: nil];
        if ([udid length]) {
            return YES;
        }
    }
    
    if ([[UIDevice currentDevice] respondsToSelector:@selector(identifierForVendor)]) {
        NSUUID *uuid = [UIDevice currentDevice].identifierForVendor;
        udid = [uuid UUIDString];
    }else {
        udid = uuid();
    }
    NSLog(@"UDID is %@", udid);
    if ([udid length]) {
        [[NSUserDefaults standardUserDefaults] setObject:udid forKey:kUDIDKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [SFHFKeychainUtils storeUsername: kKeyUserName andPassword: udid
                          forServiceName: kKeyServerNameUDID
                          updateExisting: YES
                                   error: nil];
        return YES;
    }else {
        return NO;
    }
}

@end
