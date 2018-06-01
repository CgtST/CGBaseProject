//
//  IBAccount.h
//  iBestStandard
//
//  Created by bingo on 2018/5/16.
//  Copyright © 2018年 iBest. All rights reserved.
//



#import <Foundation/Foundation.h>


@class IBUserData;


@interface IBAccount : NSObject<NSCoding>


/**
 *  用户session
 */
@property (nonatomic, strong) NSString *session;

/**
 *  用户User ID
 */
@property (nonatomic) int64_t userID;


/**
 *  保存账号
 *
 *  @param account QNAccount Instance
 *  @return 是否成功保存
 */
+ (BOOL)saveAccount:(IBAccount *)account;

/**
 *  当前账号
 *
 *  @return QNAccount Instance
 */
+ (IBAccount *)currentAccount;

/**
 *  是否允许自动登录
 *
 *  @return YES@NO
 */
- (BOOL)availableAutoLogin;

- (instancetype)initWithUserId:(int64_t)userID
                       session:(NSString *)session;

/**
 *  储存用户信息
 *
 *  @param userData 提供储存信息的对象
 */
- (void)saveUserData:(IBUserData *)userData;

/**
 *  填充用户信息
 *
 *  @param userData 需要填充的用户信息对象
 */
- (void)fillUserData:(IBUserData *)userData;


@end
