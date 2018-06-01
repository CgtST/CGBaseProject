//
//  IBUserSystemManager.m
//  iBestStandard
//
//  Created by bingo on 2018/5/17.
//  Copyright © 2018年 iBest. All rights reserved.
//

#import "IBUserSystemManager.h"
#import "IBAccount.h"
#import "CTDeviceInfo.h"
#import "IBUserData.h"
#import "IBLoginParm.h"
#import "IBLoginApi.h"



@implementation IBUserSystemManager


@synthesize sessionID = _sessionID;


#pragma mark - Singleton
IBUserSystemManager* sharedIBUserSystemManager() {
    static dispatch_once_t onceToken;
    static IBUserSystemManager *s_manager = nil;
    dispatch_once(&onceToken, ^{
        s_manager = [[IBUserSystemManager alloc] init];
    });
    return s_manager;
}


IBUserData *User() {
    return sharedIBUserSystemManager().user;
}



#pragma mark - Public



/**
 游客登录

 @param resultBlock resultBlock description
 */
- (void)IBRegisterGuest:(void(^)(BOOL loginResult))resultBlock {
    
    WEAKSELF
    IBLoginParm *loginParam = [[IBLoginParm alloc] init];
    loginParam.certType = IBCertTypeGuest; //游客
    
    __block  IBLoginApi *loginApi = [[IBLoginApi alloc] initWithParm:loginParam];
    
    
    [loginApi ibGestLoginResultBlock:^(id response, NSError *error) {
        if (!error) {
            weakSelf.sessionID = loginApi.sessionId;
            NSDictionary * userInfo = loginApi.userInfo;
            [User()  decodeUserDataWithWebDic:userInfo];
            [weakSelf initForUser:loginApi.userID];
            resultBlock(YES);
        }else{
            resultBlock(NO);
        }
    }];
    

    
    
}


/**
 ibest 自动登录

 @param resultBlock resultBlock description
 */
- (void)IBAutoLogin:(void(^)(BOOL loginResult))resultBlock
{
     // 检查当前是否有保存的账户信息，如果有，则自动登录，没有就帮用户注册游客身份。
    __block IBAccount *account = [IBAccount currentAccount];
    if (!account || (![account availableAutoLogin]))
    {
        [self IBRegisterGuest:resultBlock];
    }
    else
    {
//        //首先需要更新session，其次才可以做其他动作。否则会导致出现用以前老session进行请求的问题。
//        NSDictionary * deviceInfo = [CTDeviceInfo deviceDictionary];
//        [NetService().userHandler fetchSessionLoginWithDeviceInfo:deviceInfo sessionId:self.sessionID resultBlock:^(id responseObject, NSError *error) {
//            if (!error) {
//                if (responseObject[@"sessionId"]) {
//                    sharedIBUserSystemManager().sessionID = responseObject[@"sessionId"];  //更新sessionid
//                }
//
//                NSDictionary * userinfoDic = responseObject[@"userInfo"];
//
//                [User() decodeUserDataWithWebDic:userinfoDic];
//                if ([IBGlobalMethod quotePhoneNum].length>0) {
//                    [IBOptionPlistSingleton shareIntance].thirdLoginOpenId = [IBGlobalMethod quotePhoneNum];
//                }
//
//                resultBlock(YES);
//
//            }else{
//                resultBlock(NO);
//
//            }
//
//        }];
    }
}

- (void)logout
{
    //退出时清空本地保存的登录用户的session（session已经失效）
    IBAccount *account = [IBAccount currentAccount];
    if (account) {
        account.session = INVALID_SESSION;
        [IBAccount saveAccount:account];
    }
    _sessionID = INVALID_SESSION;
    self.user = nil;
    [NetService() logout];
    
    //取消socket重连接
    [Socket() cutOffSocket];
    [Socket() socketConnectHost];
}



- (void) initForUser:(int64_t) userID
{
    self.user.ID = userID;
    [NetService() successLogin];

    //保存当前登录
    IBAccount *account = [[IBAccount alloc] initWithUserId:self.user.ID session:self.sessionID];
    [account saveUserData:self.user];
    [IBAccount saveAccount:account];
    
}


#pragma mark – getter/setter
- (IBUserData *)user {
    if (_user == nil) {
        @synchronized(_user) {
            if (_user == nil) {
                _user = [[IBUserData alloc] init];
            }
        }
    }
    return _user;
}


- (NSString *)sessionID {
    //Session为空或者无效时，从持久化文件获取Session.
    if (!_sessionID.length || [_sessionID isEqualToString:INVALID_SESSION]) {
        @synchronized(self) {
            IBAccount *account = [IBAccount currentAccount];
            if (account && [account.session length]) {
                _sessionID = account.session;
            }else {
                return INVALID_SESSION;
            }
        }
    }
    return _sessionID;
}


- (void)setSessionID:(NSString *)sessionID {
    _sessionID = sessionID;
    
}



@end
