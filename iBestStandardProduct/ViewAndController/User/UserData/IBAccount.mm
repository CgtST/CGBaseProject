//
//  IBAccount.m
//  iBestStandard
//
//  Created by bingo on 2018/5/16.
//  Copyright © 2018年 iBest. All rights reserved.
//

#import "IBAccount.h"
#import "NSPathEx.h"
#import "IBUserData.h"


static NSString *kAccountPath = @"/userAccounts.dat";

@interface IBAccount ()
/**
 归档路径
 */
@property (nonatomic, strong) NSString *docPath;

/**
 *   当前用户信息
 */
@property (nonatomic, copy) NSString *userData;

@end

@implementation IBAccount




#pragma mark - Publice Methods

- (instancetype)initWithUserId:(int64_t)userID
                       session:(NSString *)session {
    self = [super init];
    if (self) {
        self.userID = userID;
        self.session = session;
    }
    return self;
}


+ (BOOL)saveAccount:(IBAccount *)account {
    BOOL __block success = NO;
    dispatch_queue_t dqueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_sync(dqueue, ^{
        NSString *path = [[NSPathEx docPath] stringByAppendingString:kAccountPath];
        if (account) {
            success = [NSKeyedArchiver archiveRootObject:@[account] toFile:path];
        }
    });
    if (success) {
        NSLog(@"Save Accounts Successful");
    }
    return success;
}


+ (IBAccount *)currentAccount
{
    NSString *path = [[NSPathEx docPath] stringByAppendingString:kAccountPath];
    NSArray *accounts = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    if ([accounts count])
    {
        IBAccount *account = accounts[0];
        if ([account isKindOfClass:[IBAccount class]])
        {
            return account;
        }else
        {
            return nil;
        }
    }
    else
    {
        return nil;
    }
}

//判断是否能session自动登录
- (BOOL)availableAutoLogin;
{
    return [self.session length] && self.userID != 0 && ![self.session isEqualToString:INVALID_SESSION];
}

- (void)saveUserData:(IBUserData *)userData {
    self.userID = userData.ID;
    NSDictionary *userDic = @{
                              /*@"avatorUrlString": userData.avatorUrlString ?userData.avatorUrlString : @"",
                              @"nickname": userData.nickname ?userData.nickname:@"",
                              @"gender": @(userData.gender)?@(userData.gender):@(QNGenderUnknow),*/
                              @"phoneNumber": userData.phoneNumber?userData.phoneNumber:@"",/*
                              @"profile": userData.profile?userData.profile:@"",
                              @"signature": userData.signature?userData.signature:@"",
                              @"bigAvatarUrlString": userData.bigAvatarUrlString?userData.bigAvatarUrlString:@"",
                              @"verifyTitle": userData.verifyTitle?userData.verifyTitle:@"",
                              @"verifyType": @(userData.verifyType)?@(userData.verifyType):@(QNVerifyTypeUnknow),
                              @"imId": userData.imId ?: @"",
                              @"imPassword": userData.imPassword ?: @""
                              @"adviserType": @(userData.adviserType),
                              @"adviserName": userData.adviserName ?: @"",
                              @"uType": @(userData.userType) ?: @(QNUserTypeGuest),
                              @"isLv2Vip":userData.isLevelTwo?:@"",
                              @"quotePassword":userData.quotePassword?:@""*/
                              };
    
    NSError __autoreleasing *error = nil;
    NSData *userDataToSave = [NSJSONSerialization dataWithJSONObject:userDic options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        NSLog(@"从account反序列化userData失败");
    }
    NSString *userDataString = [[NSString alloc] initWithData:userDataToSave encoding:NSUTF8StringEncoding];
    self.userData = userDataString;
}

- (void)fillUserData:(IBUserData *)userData {
    if (![self.userData length]) return;
    
    NSData *userSavedData = [self.userData dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError __autoreleasing *error = nil;
    NSDictionary *userDic = [NSJSONSerialization JSONObjectWithData:userSavedData options:NSJSONReadingMutableContainers error:&error];
    if (error) {
        NSLog(@"从account序列化userData失败");
        
    }
    
//    userData.avatorUrlString = userDic[@"avatorUrlString"];
//    userData.nickname = userDic[@"nickname"];
//    userData.gender = (QNGender)[userDic[@"gender"] integerValue];
    userData.phoneNumber = userDic[@"phoneNumber"];
//    userData.profile = userDic[@"profile"];
//    userData.signature = userDic[@"signature"];
//    userData.bigAvatarUrlString = userDic[@"bigAvatarUrlString"];
//    userData.verifyTitle = userDic[@"verifyTitle"];
//    userData.verifyType = (int8_t)[userDic[@"verifyType"] integerValue];
//    userData.imId = userDic[@"imId"];
//    userData.imPassword = userDic[@"imPassword"];
//    userData.adviserType = (QNUserAdviserType)[userDic[@"adviserType"] integerValue];
//    userData.adviserName = userDic[@"adviserName"];
//    userData.userType = (QNUserType)[userDic[@"uType"] integerValue];
//    userData.isLevelTwo = userDic[@"isLv2Vip"];
//    userData.quotePassword = userDic[@"quotePassword"];
}

#pragma mark - NSCording

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [self init];
    if (self) {
        self.userID = [aDecoder decodeInt64ForKey: @"userID"];
        self.session = [aDecoder decodeObjectForKey:@"session"];
#warning 暂时去掉加密
        //        NSString *userData = [aDecoder decodeObjectForKey:@"userData"];
        //        self.userData = [sharedQNSecurityManager() decryptLocData:userData userId:[@(self.userID) stringValue]];
        self.userData = [aDecoder decodeObjectForKey:@"userData"];
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInt64: self.userID forKey: @"userID"];
    [aCoder encodeObject:self.session forKey:@"session"];
    
#warning 暂时去掉加密
    
    //    NSString *userData = [sharedQNSecurityManager() encryptLocalData:self.userData userId:[@(self.userID) stringValue]];
    //    [aCoder encodeObject:userData forKey:@"userData"];
    [aCoder encodeObject:self.userData forKey:@"userData"];
}

- (BOOL)isEqual:(id)object
{
    if ([object isKindOfClass:[IBAccount class]]) {
        IBAccount *account = (IBAccount *)object;
        return account.userID == self.userID;
    }
    return NO;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Account : (uid : %@) (session : %@)",@(self.userID), self.session];
}

#pragma mark - File Manager
- (void)cleanData
{
    [[NSFileManager defaultManager] removeItemAtPath:self.docPath error:nil];
}

- (NSString *)docPath
{
    if (_docPath == nil)
    {
        _docPath = [[NSPathEx docPath] stringByAppendingFormat:@"/%llu", self.userID];
        if (![[NSFileManager defaultManager] fileExistsAtPath:_docPath])
        {
            [[NSFileManager defaultManager] createDirectoryAtPath:_docPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    return _docPath;
}
@end
