//
//  IBErrKeys.h
//  iBestStandard
//
//  Created by bingo on 2018/5/24.
//  Copyright © 2018年 iBest. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - 网络错误


/*
 * 网络请求相关错误码
 */
typedef NS_ENUM(int32_t, ErrorCode) {
    
    
    //服务器返回错误码
    ErrorCodeClientShouldDisplayErrMsg = 888,
    ErrorCodeHadRegister = 1000,
    ErrorCodeNotRegister = 1001,
    ErrorCodeErrPassword = 1002,
    ErrorCodeUpdateSuggest = 1003,
    ErrorCodeUpdateForce   = 1004,
    ErrorCodeSessionInvalid= 1006,
    ErrorCodeErrInvitation = 1011,
    ErrorCodeExpiredInvitation = 1012,
    ErrorCodeErrCaptcha = 1021,
    ErrorCodeErrGuestInsufficientPermissions = 1111,
    ErrorCodeNotBindPhone = 1022,
    
    ErrorCodeClientNetworkError = -4001,
    ErrorCodeEmptyErrorMessage = -4002,
    ErrorCodeEmptyResponseCode = -4003,
    ErrorCodeBadResponseData = -4004,
    ErrorCodeClientUnknowError = -9999,
};
